import os
import re

directories = [
    "frontend/lib/features/airtel_iq/views",
    "frontend/lib/features/airtel_iq/widgets",
]

def replace_tokens(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Padding / Spacing
    content = re.sub(r'EdgeInsets\.all\(\s*8\.0?\s*\)', 'EdgeInsets.all(AppSpacing.sm)', content)
    content = re.sub(r'EdgeInsets\.all\(\s*12\.0?\s*\)', 'EdgeInsets.all(AppSpacing.md)', content)
    content = re.sub(r'EdgeInsets\.all\(\s*16\.0?\s*\)', 'EdgeInsets.all(AppSpacing.lg)', content)
    content = re.sub(r'EdgeInsets\.all\(\s*20\.0?\s*\)', 'EdgeInsets.all(AppSpacing.lg)', content)
    content = re.sub(r'EdgeInsets\.all\(\s*24\.0?\s*\)', 'EdgeInsets.all(AppSpacing.xl)', content)
    content = re.sub(r'EdgeInsets\.all\(\s*32\.0?\s*\)', 'EdgeInsets.all(AppSpacing.xxl)', content)
    
    content = re.sub(r'Gap\(\s*8\.0?\s*\)', 'Gap(AppSpacing.sm)', content)
    content = re.sub(r'Gap\(\s*12\.0?\s*\)', 'Gap(AppSpacing.md)', content)
    content = re.sub(r'Gap\(\s*16\.0?\s*\)', 'Gap(AppSpacing.lg)', content)
    content = re.sub(r'Gap\(\s*20\.0?\s*\)', 'Gap(AppSpacing.lg)', content)
    content = re.sub(r'Gap\(\s*24\.0?\s*\)', 'Gap(AppSpacing.xl)', content)
    content = re.sub(r'Gap\(\s*32\.0?\s*\)', 'Gap(AppSpacing.xxl)', content)

    content = re.sub(r'SizedBox\(\s*height:\s*8\.0?\s*\)', 'Gap(AppSpacing.sm)', content)
    content = re.sub(r'SizedBox\(\s*height:\s*12\.0?\s*\)', 'Gap(AppSpacing.md)', content)
    content = re.sub(r'SizedBox\(\s*height:\s*16\.0?\s*\)', 'Gap(AppSpacing.lg)', content)
    content = re.sub(r'SizedBox\(\s*height:\s*20\.0?\s*\)', 'Gap(AppSpacing.lg)', content)
    content = re.sub(r'SizedBox\(\s*height:\s*24\.0?\s*\)', 'Gap(AppSpacing.xl)', content)
    content = re.sub(r'SizedBox\(\s*height:\s*32\.0?\s*\)', 'Gap(AppSpacing.xxl)', content)
    
    content = re.sub(r'SizedBox\(\s*width:\s*8\.0?\s*\)', 'Gap(AppSpacing.sm)', content)
    content = re.sub(r'SizedBox\(\s*width:\s*12\.0?\s*\)', 'Gap(AppSpacing.md)', content)
    content = re.sub(r'SizedBox\(\s*width:\s*16\.0?\s*\)', 'Gap(AppSpacing.lg)', content)
    content = re.sub(r'SizedBox\(\s*width:\s*24\.0?\s*\)', 'Gap(AppSpacing.xl)', content)

    # Border Radius
    content = re.sub(r'BorderRadius\.circular\(\s*8\.0?\s*\)', 'BorderRadius.circular(AppRadius.sm)', content)
    content = re.sub(r'BorderRadius\.circular\(\s*12\.0?\s*\)', 'BorderRadius.circular(AppRadius.sm)', content)
    content = re.sub(r'BorderRadius\.circular\(\s*16\.0?\s*\)', 'BorderRadius.circular(AppRadius.md)', content)
    content = re.sub(r'BorderRadius\.circular\(\s*20\.0?\s*\)', 'BorderRadius.circular(AppRadius.lg)', content)
    content = re.sub(r'BorderRadius\.circular\(\s*24\.0?\s*\)', 'BorderRadius.circular(AppRadius.lg)', content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

for d in directories:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f.endswith('.dart'):
                replace_tokens(os.path.join(root, f))
print("Tokens replaced for Airtel IQ v2.")
