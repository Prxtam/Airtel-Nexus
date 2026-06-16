import re

def fix_industry():
    with open('lib/features/airtel_iq/knowledge/industry_intelligence.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    content = content.replace("'Airtel Cloud'", "'Airtel Public Cloud'")
    content = content.replace("Airtel Cloud)", "Airtel Public Cloud)")
    content = content.replace("Airtel Cloud /", "Airtel Public Cloud /")

    with open('lib/features/airtel_iq/knowledge/industry_intelligence.dart', 'w', encoding='utf-8') as f:
        f.write(content)

def fix_product():
    with open('lib/features/airtel_iq/knowledge/product_intelligence.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace Secure Internet pain points
    match = re.search(r"(id:\s*'prod_secure_internet'.*?painPointsSolved:\s*\[)(.*?)(],)", content, re.DOTALL)
    if match:
        new_pps = """
      'Distributed Network Security',
      'Security & Compliance',
      'Fraud and Breach Prevention',
      'DDoS Attacks',
      'Legacy System Vulnerabilities',
    """
        content = content[:match.start(2)] + new_pps + content[match.end(2):]

    with open('lib/features/airtel_iq/knowledge/product_intelligence.dart', 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == '__main__':
    fix_industry()
    fix_product()
    print("Fixes applied successfully.")
