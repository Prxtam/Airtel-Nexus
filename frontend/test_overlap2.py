import re

def overlap(a, b):
    stop_words = {'data', 'management', 'system', 'network', 'business', 'risk', 'cost', 'time', 'high', 'low', 'poor', 'lack'}
    a_words = [w.lower() for w in re.findall(r'\w+', a) if len(w) > 3 and w.lower() not in stop_words]
    b_lower = b.lower()
    return any(w in b_lower for w in a_words)

challenges = [
    'Regulatory compliance (RBI, SEBI)',
    'Customer service expectations and hyper-personalization',
    'Distributed branch operations and unified communications',
    'Workforce coordination for field agents and collections',
    'Data sovereignty and privacy mandates',
    'Rising operational costs due to legacy systems',
    'Fraud detection and real-time transaction monitoring',
    'Secure communication across distributed networks',
    'Branch connectivity reliability and uptime (SD-WAN needs)',
    'Workforce Mobility',
    'Centralized management of distributed IT infrastructure',
    'Cloud migration risks regarding data residency',
    'Integrating legacy core banking systems with modern APIs',
]

pps = {
    'Secure Internet': [
      'Distributed Network Security',
      'Security & Compliance',
      'Fraud and Breach Prevention',
      'DDoS Attacks',
      'Legacy System Vulnerabilities',
    ],
    'SD-WAN': [
      'Branch WAN Complexity',
      'Application Performance',
      'Network Visibility',
      'Rising Telecom Costs',
      'Zero-Touch Provisioning',
    ]
}

for prod, pp_list in pps.items():
    print(f"\\n--- {prod} ---")
    score = 0
    matched = []
    for pp in pp_list:
        for c in challenges:
            if c not in matched and overlap(pp, c):
                print(f"Match: '{pp}' overlaps '{c}'")
                score += 5
                matched.append(c)
                break
    print(f"Total Challenge Score: {min(score, 20)}")
