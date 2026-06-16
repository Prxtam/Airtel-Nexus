import re

def fix_industry_intelligence():
    with open('lib/features/airtel_iq/knowledge/industry_intelligence.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    # Banking: Remove CCaaS and IQ Business Connect, Add Colocation and VPN/MPLS
    banking_match = re.search(r"(industryName:\s*'Banking & Financial Services'.*?recommendedProducts:\s*\[)(.*?)(],)", content, re.DOTALL)
    if banking_match:
        recs = banking_match.group(2)
        recs = re.sub(r"\s*'Airtel Contact Center as a Service',", "", recs)
        recs = re.sub(r"\s*'Airtel IQ Business Connect',", "", recs)
        if "'Airtel Colocation (Nxtra)'" not in recs:
            recs += "\n      'Airtel Colocation (Nxtra)',"
        if "'Airtel VPN/MPLS'" not in recs:
            recs += "\n      'Airtel VPN/MPLS',"
        content = content[:banking_match.start(2)] + recs + content[banking_match.end(2):]

    # IT & ITES: Remove CCaaS
    it_match = re.search(r"(industryName:\s*'IT & ITES'.*?recommendedProducts:\s*\[)(.*?)(],)", content, re.DOTALL)
    if it_match:
        recs = it_match.group(2)
        recs = re.sub(r"\s*'Airtel Contact Center as a Service',", "", recs)
        content = content[:it_match.start(2)] + recs + content[it_match.end(2):]

    # Manufacturing: Remove IQ Business Connect
    mfg_match = re.search(r"(industryName:\s*'Manufacturing'.*?recommendedProducts:\s*\[)(.*?)(],)", content, re.DOTALL)
    if mfg_match:
        recs = mfg_match.group(2)
        recs = re.sub(r"\s*'Airtel IQ Business Connect',", "", recs)
        content = content[:mfg_match.start(2)] + recs + content[mfg_match.end(2):]

    # Healthcare: Remove IQ Business Connect
    hc_match = re.search(r"(industryName:\s*'Healthcare'.*?recommendedProducts:\s*\[)(.*?)(],)", content, re.DOTALL)
    if hc_match:
        recs = hc_match.group(2)
        recs = re.sub(r"\s*'Airtel IQ Business Connect',", "", recs)
        content = content[:hc_match.start(2)] + recs + content[hc_match.end(2):]

    # Government: Remove IQ Business Connect
    gov_match = re.search(r"(industryName:\s*'Government'.*?recommendedProducts:\s*\[)(.*?)(],)", content, re.DOTALL)
    if gov_match:
        recs = gov_match.group(2)
        recs = re.sub(r"\s*'Airtel IQ Business Connect',", "", recs)
        content = content[:gov_match.start(2)] + recs + content[gov_match.end(2):]

    # Energy: Remove IQ Business Connect
    energy_match = re.search(r"(industryName:\s*'Energy & Utilities'.*?recommendedProducts:\s*\[)(.*?)(],)", content, re.DOTALL)
    if energy_match:
        recs = energy_match.group(2)
        recs = re.sub(r"\s*'Airtel IQ Business Connect',", "", recs)
        content = content[:energy_match.start(2)] + recs + content[energy_match.end(2):]

    with open('lib/features/airtel_iq/knowledge/industry_intelligence.dart', 'w', encoding='utf-8') as f:
        f.write(content)

def fix_product_intelligence():
    with open('lib/features/airtel_iq/knowledge/product_intelligence.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. UTF Encoding Fixes (use \\' for apostrophes inside Dart single quotes)
    replacements = {
        'â€”': '—',
        'â€™': "\\'",
        'â€œ': '"',
        'â€': '"',
        'â€“': '-'
    }
    for broken, fixed in replacements.items():
        content = content.replace(broken, fixed)
        
    # Also fix the previous apostrophe issues manually introduced
    content = content.replace("Airtel's", "Airtel\\'s")
    # Actually wait, if I use git restore, "Airtel's" is already restored to the broken one without \ if it existed in the git branch.
    # The broken ones were `Airtel's` in `executivePitch` and `objectionResponses` that I manually fixed before. Wait, I fixed it in git before but let me just make sure any unescaped "Airtel's" becomes "Airtel\'s"
    # To be safe, I'll just use regex to replace unescaped apostrophes inside words.
    content = re.sub(r"(?<=[a-zA-Z])'(?=[a-zA-Z])", r"\\'", content)


    # 2. Fix Secure Internet Discovery Questions
    secure_internet_match = re.search(r"(id:\s*'prod_secure_internet'.*?discoveryQuestions:\s*\[)(.*?)(],)", content, re.DOTALL)
    if secure_internet_match:
        new_qs = """
      'How are you enforcing security controls across your increasingly distributed network edges?',
      'During compliance audits, how difficult is it to consolidate logs and prove continuous threat monitoring?',
      'Are you exploring zero-trust access architecture to replace vulnerable legacy VPNs?',
      'How much security vendor sprawl do you currently have between your connectivity, firewall, and endpoint security providers?',
      'How do you ensure rapid incident response to meet strict regulatory enforcement mandates?',
    """
        content = content[:secure_internet_match.start(2)] + new_qs + content[secure_internet_match.end(2):]

    with open('lib/features/airtel_iq/knowledge/product_intelligence.dart', 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == '__main__':
    fix_industry_intelligence()
    fix_product_intelligence()
    print("Fixes applied successfully.")
