import re

ind = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\industry_intelligence.dart", encoding='utf-8').read()
prod = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\product_intelligence.dart", encoding='utf-8').read()
engine = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\services\meeting_prep_intelligence_engine.dart", encoding='utf-8').read()

print("--- Banking Recommended Products ---")
banking_block = ind[ind.find("'Banking & Financial Services'"):ind.find("const IndustryIntelligence", ind.find("'Banking & Financial Services'"))]
rec_prods = re.search(r"recommendedProducts:\s*\[(.*?)\]", banking_block, re.DOTALL)
if rec_prods:
    print(rec_prods.group(1).strip())

print("\n--- Airtel Public Cloud Pain Points ---")
pub_block = prod[prod.find("'Airtel Public Cloud'"):prod.find("const ProductIntelligence", prod.find("'Airtel Public Cloud'"))]
pub_pp = re.search(r"painPointsSolved:\s*\[(.*?)\]", pub_block, re.DOTALL)
if pub_pp:
    print(pub_pp.group(1).strip())

print("\n--- Airtel Colocation (Nxtra) Pain Points ---")
colo_block = prod[prod.find("'Airtel Colocation (Nxtra)'"):prod.find("const ProductIntelligence", prod.find("'Airtel Colocation (Nxtra)'"))]
colo_pp = re.search(r"painPointsSolved:\s*\[(.*?)\]", colo_block, re.DOTALL)
if colo_pp:
    print(colo_pp.group(1).strip())

