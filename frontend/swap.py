import re

path = r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\product_intelligence.dart"
content = open(path, 'r', encoding='utf-8').read()

cloud_block = content[content.find("  const ProductIntelligence(\n    id: 'prod_public_cloud',"):content.find("  const ProductIntelligence(\n    id: 'prod_secure_internet',")]
secure_block = content[content.find("  const ProductIntelligence(\n    id: 'prod_secure_internet',"):content.find("  const ProductIntelligence(\n    id: 'prod_vpn_mpls',")]

content = content.replace(cloud_block, "###CLOUD###")
content = content.replace(secure_block, "###SECURE###")
content = content.replace("###CLOUD###", secure_block)
content = content.replace("###SECURE###", cloud_block)

open(path, 'w', encoding='utf-8').write(content)
print("Swapped!")
