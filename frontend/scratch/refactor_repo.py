import re

def update_repo():
    path = r'c:\Users\prita\OneDrive\Documents\Airtel Employee App 2\frontend\lib\features\airtel_iq\knowledge\product_enrichment_repository.dart'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Insert ObjectionGuidance class before EnrichedProduct
    obj_class = """
class ObjectionGuidance {
  final String reframe;
  final String recommendedResponse;
  final List<String> avoidSaying;

  const ObjectionGuidance({
    required this.reframe,
    required this.recommendedResponse,
    required this.avoidSaying,
  });
}

class EnrichedProduct {"""
    if 'class ObjectionGuidance' not in content:
        content = content.replace('class EnrichedProduct {', obj_class)

    # 2. Add objectionGuidance field to EnrichedProduct
    field_decl = """  final List<String> officialSourceUrls;
  final String verificationStatus;
  final Map<String, ObjectionGuidance>? objectionGuidance;"""
    if 'Map<String, ObjectionGuidance>? objectionGuidance;' not in content:
        content = content.replace('  final List<String> officialSourceUrls;\n  final String verificationStatus;', field_decl)

    # 3. Add to constructor
    constructor_decl = """    required this.crossSellProducts,
    required this.idealIndustries,
    required this.officialSourceUrls,
    required this.verificationStatus,
    this.objectionGuidance,
  });"""
    if 'this.objectionGuidance,' not in content:
        content = content.replace('    required this.crossSellProducts,\n    required this.idealIndustries,\n    required this.officialSourceUrls,\n    required this.verificationStatus,\n  });', constructor_decl)

    # 4. Product intelligence definitions
    injections = {
        'Airtel Public Cloud': """    verificationStatus: 'Verified by Product Team',
    objectionGuidance: {
      'Existing Vendor': const ObjectionGuidance(
        reframe: 'Shift focus from wholesale replacement to identifying specific workloads that benefit from localized, sovereign infrastructure.',
        recommendedResponse: 'Acknowledge their current cloud platform strength. Highlight that for sensitive data, sovereign cloud ensures local compliance and eliminates egress fees.',
        avoidSaying: [
          "Don't claim we can replace AWS/Azure entirely.",
          "Don't criticize their current cloud architecture.",
          "Don't ignore their existing cloud investments.",
        ],
      ),
    },""",
        'Airtel Secure Internet': """    verificationStatus: 'Verified by Product Team',
    objectionGuidance: {
      'Existing Vendor': const ObjectionGuidance(
        reframe: 'Shift focus from edge hardware replacement to securing the network layer itself before threats reach the perimeter.',
        recommendedResponse: 'Acknowledge their edge devices. Explain Clean Pipe security stopping volumetric DDoS within the core network before hitting firewalls.',
        avoidSaying: [
          "Don't suggest they remove their firewall.",
          "Don't claim we offer better edge hardware than specialized vendors.",
          "Don't position this as a rip-and-replace.",
        ],
      ),
    },""",
        'Airtel SD-WAN': """    verificationStatus: 'Verified by Product Team',
    objectionGuidance: {
      'Existing Vendor': const ObjectionGuidance(
        reframe: 'Shift focus from breaking existing contracts to overlaying intelligent routing for a hybrid architecture.',
        recommendedResponse: 'Explain that SD-WAN can overlay existing links. This immediately provides centralized visibility without terminating current contracts.',
        avoidSaying: [
          "Don't suggest they cancel their MPLS immediately.",
          "Don't claim broadband is just as reliable as MPLS for all traffic.",
          "Don't ignore the cancellation penalties they might face.",
        ],
      ),
    },""",
        'Airtel IoT Connectivity': """    verificationStatus: 'Verified by Product Team',
    objectionGuidance: {
      'Security': const ObjectionGuidance(
        reframe: 'Position this not as just a SIM card, but as a private, encrypted tunnel isolated from the public internet.',
        recommendedResponse: 'Highlight Private APNs and a dedicated management platform. Sensor data travels through a secure, encrypted tunnel entirely isolated from the public internet.',
        avoidSaying: [
          "Don't ignore endpoint security vulnerabilities.",
          "Don't claim cellular is immune to hacking.",
          "Don't overpromise on complex sensor integrations.",
        ],
      ),
    },""",
        'Airtel WhatsApp Business': """    verificationStatus: 'Verified by Product Team',
    objectionGuidance: {
      'Vendor Trust': const ObjectionGuidance(
        reframe: 'Reframe from one-way broadcast spam to secure, two-way conversational commerce with customer opt-ins.',
        recommendedResponse: 'Explain that Meta strictly enforces spam prevention via template approvals and opt-ins. This enables high-value notifications from a Verified Green Tick account.',
        avoidSaying: [
          "Don't promise zero customer complaints.",
          "Don't say they can send messages to anyone they want.",
          "Don't ignore strict opt-in regulations.",
        ],
      ),
    },"""
    }

    # Replace for each product
    for prod_name, inj in injections.items():
        # Find the block for the product
        pattern = r"(productName:\s*'" + re.escape(prod_name) + r"'.*?verificationStatus:\s*'Verified by Product Team',)?"
        
        # We need a more robust way. Let's find the product block and replace the end of it
        # Actually, split the content by 'EnrichedProduct('
        parts = content.split('EnrichedProduct(')
        new_parts = [parts[0]]
        for part in parts[1:]:
            if f"productName: '{prod_name}'" in part and 'objectionGuidance:' not in part:
                part = part.replace("verificationStatus: 'Verified by Product Team',", inj)
            new_parts.append(part)
        content = 'EnrichedProduct('.join(new_parts)

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Done")

update_repo()
