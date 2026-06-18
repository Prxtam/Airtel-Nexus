import re

dart_file_path = "lib/features/airtel_iq/knowledge/product_enrichment_repository.dart"

with open(dart_file_path, "r", encoding="utf-8") as f:
    content = f.read()

def inject_features(prod_key, features_dict):
    global content
    
    # Format the dictionary into a Dart map string
    dart_map_str = "{\n"
    for k, v in features_dict.items():
        # Handle single quotes in strings
        k_safe = k.replace("'", "\\'")
        dart_map_str += f"      '{k_safe}': [\n"
        for item in v:
            item_safe = item.replace("'", "\\'")
            dart_map_str += f"        '{item_safe}',\n"
        dart_map_str += "      ],\n"
    dart_map_str += "    }"
    
    # We find the product block
    # We look for officialFeaturesAndBenefits: {}, after the prod_key
    pattern = rf"('{prod_key}'[\s\S]*?officialFeaturesAndBenefits:\s*){{\}}"
    
    content = re.sub(pattern, rf"\1{dart_map_str}", content, count=1)

# Office Internet (brochure)
inject_features('prod_office_internet', {
    'High-speed up to 1Gbps': ['Lightning-fast speeds optimal for all enterprise devices and workflows.'],
    'In-built DNS Security by Cisco': ['Network-level protection against malicious domains and cyber threats.'],
    'End Point Device Security by Kaspersky': ['Device-level protection ensuring secure browsing and data safety.'],
    'Unlimited voice call': ['Seamless voice connectivity bundled directly with the broadband service.'],
    'Parallel Ringing': ['Ensure no business call is missed by ringing multiple designated numbers simultaneously.'],
    'Free Static IP': ['Included for advanced networking requirements and secure remote access.']
})

# SIP Trunking
inject_features('prod_sip_trunking', {
    'High-Capacity Connectivity': ['Supports a high volume of concurrent calls over a single, unified digital connection.'],
    'Direct Inward Dialing (DID)': ['Assign specific numbers to different departments or individuals without auto-attendants.'],
    'Advanced Call Routing': ['Intelligent call distribution mapping inbound traffic effectively.'],
    'Consolidated Billing': ['Simplifies administration with a single, unified bill for all extensions and lines.'],
    'Carrier-Grade Reliability': ['Backed by nationwide telecom infrastructure and enterprise-level SLAs.'],
    'Transparent Analytics': ['Visibility into call metrics to monitor performance, volume, and quality.']
})

# CCaaS
inject_features('prod_ccaas', {
    'Omnichannel Integration': ['A unified platform managing voice, email, chat, and social interactions.'],
    'Comprehensive Call Handling': ['Advanced inbound and outbound management, routing, queuing, and conferencing.'],
    'Software Partnerships': ['Natively integrated with top-tier contact center software providers like Genesys.'],
    'Web-Based Management': ['100% web-based interface allowing agents and supervisors to operate from anywhere.'],
    'Real-Time Analytics & Dashboards': ['Unified view of KPIs and conversational insights for real-time decisions.'],
    'Intelligent IVR': ['Interactive Voice Response system to automate repetitive inquiries and reduce agent load.']
})

# Managed Wi-Fi
inject_features('prod_managed_wifi', {
    'Universal Access': ['Enterprise-grade indoor and outdoor Access Points ensuring comprehensive coverage.'],
    'Unified Network Management': ['Centralized dashboard for proactive monitoring of APs, policies, and infrastructure.'],
    'Advanced Security': ['Multi-layered protocols including MAC binding, OTP, and Active Directory authentication.'],
    'Detailed Analytics & Reporting': ['Standardized reporting categorized by users, sites, access points, and SSIDs.'],
    'Network Monetization': ['Customizable login landing pages for marketing promotions and engagement.'],
    'High-Density Support': ['Engineered for consistent performance in high-traffic, multi-device environments.']
})

# VPN/MPLS
inject_features('prod_mpls', {
    'Scalable Bandwidth': ['Flexible bandwidth options ranging from 1 Mbps up to 100 Gbps.'],
    'Class of Service (CoS)': ['Traffic prioritization ensuring mission-critical data receives consistent performance.'],
    'Comprehensive Coverage': ['Backed by 400,000+ route kilometers of domestic fiber and 190+ countries globally.'],
    'Managed Services': ['Fully managed CPE with proactive 24/7 remote monitoring from the Airtel NOC.'],
    'Versatile Architectures': ['Supports multiple configurations including hub-and-spoke and fully meshed topologies.'],
    'Diverse Connectivity Options': ['Compatible with fiber, radio, 5G, 4G, and VSAT last-mile connections.']
})

# 5G for Enterprise
inject_features('prod_5g_enterprise', {
    'Private 5G Deployments': ['Dedicated, localized connectivity ensuring ultra-low latency for critical operations.'],
    'Smart Factory Enablement': ['Provides the high-speed wireless backbone required for Industry 4.0 transformation.'],
    'Industrial Automation': ['Replaces rigid wired networks with agile 5G, enabling reconfigurable manufacturing lines.'],
    'Real-Time Robotics Support': ['Ultra-reliable low-latency communication (URLLC) guarantees millisecond response times for AMRs/AGVs.'],
    'AI & Video Analytics Support': ['Massive uplink capacity to stream high-definition video feeds for real-time AI quality inspection.']
})

# CPaaS
inject_features('prod_cpaas', {
    'Voice APIs': ['Click-to-call, intelligent agent routing, call masking, and inbound/outbound IVR.'],
    'Messaging': ['Intelligent message automation for scalable SMS campaigns and critical alerts.'],
    'WhatsApp & Chatbots': ['Integrated WhatsApp Business API and chatbot support for interactive engagement.'],
    'Video': ['Scalable video conferencing and real-time calling experiences.'],
    'Authentication': ['Security tools like Silent Auth and implied OTP for seamless user verification.'],
    'Advanced Modules': ['Specialized logic flows for fintech E-KYC, retail, and healthcare engagement.']
})

# Colocation (Nxtra)
inject_features('prod_colocation', {
    'Flexible Deployment Options': ['Shared cages, private suites, and purpose-built dedicated data center facilities.'],
    'Advanced AI-Led Operations': ['Predictive maintenance and automated workflows using AI fault detection.'],
    'High-Performance Connectivity': ['Carrier-neutral infrastructure with low-latency access to cloud providers and IXs.'],
    'Robust Security': ['7-layer security with 24x7 surveillance and multi-factor biometric/OTP access controls.'],
    'Sustainability': ['Green infrastructure leveraging LEED/IGBC-certified buildings and renewable energy.'],
    'Infrastructure for Next-Gen Workloads': ['Supports high-density racks (up to 130 kW) and liquid cooling for AI/cloud-native workloads.']
})

# Global Voice
inject_features('prod_global_voice', {
    'Global Reach & Connectivity': ['Voice termination across 140+ countries supported by 1,200+ global carrier partnerships.'],
    'Numbering Solutions': ['Toll-Free Numbers and DID numbers to establish a local presence internationally.'],
    'Airtel Advantage Platform': ['Unified digital platform for paperless onboarding, SIP interconnects, and traffic analytics.'],
    'Traffic Assurance': ['Network optimized for low latency, high redundancy, and maximum uptime.'],
    'Security & Fraud Protection': ['Best-in-class systems to detect and block fraudulent international traffic.']
})

# Precise Positioning
inject_features('prod_precise_positioning', {
    'Centimeter-Level Accuracy': ['Improves location precision by up to 100x compared to standard GNSS systems.'],
    'AI/ML-Powered Cloud Correction': ['Uses cloud algorithms and a nationwide reference network to model errors in real-time.'],
    'Seamless Network Integration': ['Leverages Airtel pan-India 4G/5G network for continuous, reliable coverage.'],
    'Scalable Architecture': ['Built to support mission-critical deployments for autonomous vehicles, drones, and precision agriculture.']
})

# Public Cloud
inject_features('prod_public_cloud', {
    'Rapid Deployment': ['Instances provisioned in less than 60 seconds, eliminating hardware procurement delays.'],
    'Sovereign Cloud Capabilities': ['Combines global cloud functionality with strict domestic data residency and compliance.'],
    'Integrated Connectivity': ['Directly integrates cloud services with Airtel robust B2B connectivity network.'],
    'High Security Standards': ['Features 24x7 monitoring by certified professionals with network isolation and encryption.'],
    'Managed Services': ['Professional management allowing businesses to focus on core applications rather than infrastructure.']
})


with open(dart_file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Dart file updated with remaining 11 products successfully.")
