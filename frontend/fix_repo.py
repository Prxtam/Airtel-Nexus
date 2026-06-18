import re

dart_file_path = "lib/features/airtel_iq/knowledge/product_enrichment_repository.dart"

with open(dart_file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Fix the nested brackets issue:
content = re.sub(r'keyDifferentiators:\s*\[\s*\[', 'keyDifferentiators: [', content)

with open(dart_file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Dart file brackets fixed successfully.")
