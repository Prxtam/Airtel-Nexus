import os
import re
import json

engine = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\services\meeting_prep_intelligence_engine.dart", encoding='utf-8').read()
ind = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\industry_intelligence.dart", encoding='utf-8').read()
prod = open(r"c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\product_intelligence.dart", encoding='utf-8').read()

content = engine + ind + prod

p1 = len(re.findall(r'Demonstrate Airtel.*?specific solution fit', content))
p2 = len(re.findall(r'Engage with the Airtel enterprise team for a tailored response', content))

print(f"Number of placeholder objection responses remaining: {p1 + p2}")
