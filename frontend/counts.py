import re

engine = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\services\meeting_prep_intelligence_engine.dart", encoding='utf-8').read()
ind_content = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\industry_intelligence.dart", encoding='utf-8').read()
prod_content = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\product_intelligence.dart", encoding='utf-8').read()

def extract_list(text, field_name):
    pattern = field_name + r":\s*\[(.*?)\]"
    matches = re.findall(pattern, text, re.DOTALL)
    items = []
    for match in matches:
        extracted = re.findall(r"'(.*?)'", match, re.DOTALL)
        items.extend([i.strip() for i in extracted if i.strip()])
    return items

industries = re.findall(r"industryName:\s*'(.*?)'", ind_content)
products = re.findall(r"name:\s*'(.*?)'", prod_content)

business_challenges = extract_list(ind_content, 'businessChallenges')
tech_challenges = extract_list(ind_content, 'technologyChallenges')
pain_points = extract_list(prod_content, 'painPointsSolved')
unique_pain_points = len(set(business_challenges + tech_challenges + pain_points))

discovery_qs = extract_list(ind_content, 'discoveryQuestions') + extract_list(prod_content, 'discoveryQuestions')
objections = extract_list(ind_content, 'objections') + extract_list(prod_content, 'objections')

print(f"Total industries: {len(industries)}")
print(f"Total products: {len(products)}")
print(f"Total unique pain points: {unique_pain_points}")
print(f"Total discovery questions: {len(discovery_qs)}")
print(f"Total objections: {len(objections)}")

for i in industries:
    print(f"- {i}")
