import os
import re

directories = [
    "frontend/lib/features/airtel_iq/views",
]

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    # Standardize language (professional, enterprise-focused)
    content = content.replace("Awesome, your notes are ready", "Notes generated successfully")
    content = content.replace("Generate an amazing follow up!", "Generate follow-up")
    content = content.replace("Discover how", "View details")
    content = content.replace("Hey there!", "Hello.")
    content = content.replace("Let's learn", "Review materials")
    content = content.replace("Report copied to clipboard!", "Copied to clipboard")
    content = content.replace("Meeting brief copied to clipboard", "Copied to clipboard")
    content = content.replace("Follow-up copied to clipboard!", "Copied to clipboard")
    content = content.replace("All output copied to clipboard", "Copied to clipboard")
    
    # Fix DropdownButtonFormField deprecated 'value' -> 'initialValue'
    content = re.sub(
        r'(DropdownButtonFormField(?:<[^>]+>)?\s*\(\s*)value(\s*:)', 
        r'\1initialValue\2', 
        content
    )
    
    # Ensure any curly braces issues around 'for' are fixed?
    # This might be tricky via regex, so I'll just let the user fix if it's too hard, or I can try:
    # `for (final p in r.supportingRecs) sb.writeln(p);`
    # Let's see if dart analyzer gives specific line numbers.
    # We'll fix curly braces manually if needed since there's only a few.
    
    if content != original:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)

for d in directories:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f.endswith('.dart'):
                process_file(os.path.join(root, f))

print("Language and deprecations fixed.")
