import re

file_path = r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\product_intelligence.dart"

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add to IoT Connectivity
content = content.replace(
    "'Predictive Maintenance',\\n      'Remote Monitoring',",
    "'Predictive Maintenance',\\n      'Remote Monitoring',\\n      'Smart Factory',\\n      'Factory Automation',"
)

# Add to 5G for Enterprise
content = content.replace(
    "'Network Visibility',\\n      'Unreliable Connectivity',",
    "'Network Visibility',\\n      'Unreliable Connectivity',\\n      'Smart Factory',\\n      'Factory Automation',"
)

# Private 5G - let's check what it has currently
# Search for Airtel Private 5G block and add if needed
blocks = content.split('const ProductIntelligence')
new_blocks = [blocks[0]]
for block in blocks[1:]:
    if 'Airtel Private 5G' in block:
        if 'Smart Factory' not in block:
            block = block.replace("painPointsSolved: [\\n", "painPointsSolved: [\\n      'Smart Factory',\\n      'Factory Automation',\\n")
    if 'Airtel IoT Connectivity' in block:
        if 'Smart Factory' not in block:
            block = block.replace("painPointsSolved: [\\n", "painPointsSolved: [\\n      'Smart Factory',\\n      'Factory Automation',\\n")
    if 'Airtel 5G for Enterprise' in block:
        if 'Smart Factory' not in block:
            block = block.replace("painPointsSolved: [\\n", "painPointsSolved: [\\n      'Smart Factory',\\n      'Factory Automation',\\n")
    new_blocks.append(block)

content = 'const ProductIntelligence'.join(new_blocks)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated product_intelligence.dart")
