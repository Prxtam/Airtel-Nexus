import re

repo_path = r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\product_enablement_repository.dart"
content = open(repo_path, 'r', encoding='utf-8').read()

def print_copilot_card(product_name):
    # Extract the block for the given product
    pattern = f"productName:\s*'{product_name}'.*?crossSellProducts:\s*\[(.*?)\]"
    match = re.search(pattern, content, re.DOTALL)
    if not match:
        print(f"Product {product_name} not found.")
        return
        
    block = content[content.find(f"'{product_name}'"):content.find("]", content.find(f"'{product_name}'"))+1]
    
    positionItAs = re.search(r"positionItAs:\s*'(.*?)',", block).group(1)
    conversationStarter = re.search(r"conversationStarter:\s*'(.*?)',", block).group(1)
    businessOutcome = re.search(r"businessOutcome:\s*'(.*?)',", block).group(1)
    avoidSaying = re.search(r"avoidSaying:\s*'(.*?)',", block).group(1)
    
    listenFor_match = re.search(r"listenFor:\s*\[(.*?)\]", block, re.DOTALL)
    listenFor = [l.strip().strip("'") for l in listenFor_match.group(1).split(",") if l.strip()]
    
    crossSell_match = re.search(r"crossSellProducts:\s*\[(.*?)\]", block, re.DOTALL)
    crossSell = [c.strip().strip("'") for c in crossSell_match.group(1).split(",") if c.strip()]
    
    print(f"=== {product_name} AM Copilot ===")
    print("▼ AM Copilot")
    print("-------------------------------------------------")
    print("[ Talk ] [ Pitch ] [ Expand ]")
    print("-------------------------------------------------")
    print("If 'Talk' tab is selected:")
    print(f"Conversation Starter:\n{conversationStarter}\n")
    print("Listen For:")
    for l in listenFor:
        print(f"• {l}")
    print(f"\nAvoid Saying:\n{avoidSaying}")
    print("-------------------------------------------------")
    print("If 'Pitch' tab is selected:")
    print(f"Position It As:\n{positionItAs}\n")
    print(f"Business Outcome:\n{businessOutcome}")
    print("-------------------------------------------------")
    print("If 'Expand' tab is selected:")
    print("Cross-Sell Opportunities:")
    for c in crossSell:
        print(f"• {c}")
    print("=================================================\n")

print_copilot_card("Airtel Public Cloud")
print_copilot_card("Airtel IoT Connectivity")
print_copilot_card("Airtel IQ Business Connect")
