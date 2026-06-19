import re

# Also check other files that reference product names  
files_to_check = [
    r'lib\features\airtel_iq\views\ai_coach\meeting_prep_screen.dart',
    r'lib\features\airtel_iq\views\ai_coach\opportunity_insights_screen.dart',
    r'lib\features\airtel_iq\views\ai_coach\ask_airtel_iq_screen.dart',
    r'lib\features\airtel_iq\views\ai_coach\follow_up_generator_screen.dart',
    r'lib\features\airtel_iq\services\objection_coach_engine.dart',
    r'lib\features\airtel_iq\services\industry_playbook_adapter.dart',
    r'lib\features\airtel_iq\views\playbooks\playbook_detail_screen.dart',
]

canonical_path = r'lib\features\airtel_iq\knowledge\product_enrichment_repository.dart'
with open(canonical_path, encoding='utf-8') as f:
    repo_content = f.read()
canonical_names = set(re.findall(r"productName:\s*'([^']+)'", repo_content))

print("=== Cross-module product reference audit ===\n")
for fpath in files_to_check:
    try:
        with open(fpath, encoding='utf-8') as f:
            content = f.read()
        # Find strings that look like Airtel product names
        found = set(re.findall(r"'(Airtel [^']+)'", content))
        mismatches = [n for n in found if n not in canonical_names]
        if mismatches:
            print(f"FILE: {fpath.split(chr(92))[-1]}")
            for m in sorted(mismatches):
                print(f"  MISMATCH: {m}")
            print()
    except FileNotFoundError:
        print(f"FILE NOT FOUND: {fpath}")
        print()

print("Audit complete.")
