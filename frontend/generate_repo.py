import re

dart_file_path = "lib/features/airtel_iq/knowledge/product_enrichment_repository.dart"

with open(dart_file_path, "r", encoding="utf-8") as f:
    content = f.read()

# We need to add the 4 fields to EnrichedProduct class
new_class_fields = """
  // Phase 8.6.2 Official Product Knowledge
  final Map<String, List<String>> officialFeaturesAndBenefits;
  final List<String> technicalCapabilities;
  final List<String> deploymentModels;
  final List<String> integrations;
"""

content = content.replace("final List<String> keyDifferentiators;", "final List<String> keyDifferentiators;\n" + new_class_fields)

new_constructor_fields = """
    required this.officialFeaturesAndBenefits,
    required this.technicalCapabilities,
    required this.deploymentModels,
    required this.integrations,
"""

content = content.replace("required this.keyDifferentiators,", "required this.keyDifferentiators,\n" + new_constructor_fields)

# Now we define the mappings
mappings = {
  'prod_corporate_postpaid': {
    'officialFeaturesAndBenefits': "{'Superfast Speed': ['Fast Lane Tech for a smoother experience.'], 'Data Rollover': ['Dynamic data pooling allows access to aggregated data by individuals irrespective of their limits.'], 'International Roaming': ['Cost-effective and diverse international roaming plans spanning across 180 countries.'], 'Workforce Tracking': ['Easily track on-field team with TraceMate to enhance productivity & accountability.'], 'Contact Number Retention': ['Maintain valuable contact numbers even when employees leave the company.'], 'Easy Accounts Management': ['Pay bills, raise and track service requests, upgrade plans & update employee details.']}",
    'technicalCapabilities': "['5G Ready', 'Dynamic Data Pooling', 'TraceMate integration']",
    'deploymentModels': "['eSIM', 'Physical SIM']",
    'integrations': "['Airtel Business Portal']"
  },
  'prod_iq_business_connect': {
    'officialFeaturesAndBenefits': "{'No Third-Party Dependence': ['Directly integrates with Airtel services, eliminating the need for additional apps or platforms.'], 'Easy Activation': ['No complex integrations—activate Business Name Display on existing Airtel numbers.'], 'Fraud Prevention': ['Helps distinguish your legitimate calls from spam or fraudulent ones, improving customer trust.'], 'Real-Time Business Identification': ['Your business name is displayed instantly as the call rings.'], 'Scalable Solution': ['Supports businesses of all sizes, from single numbers to large-scale operations with multiple lines.'], 'Improved Customer Insights': ['Gain analytics on call engagement, such as answer rates and interaction patterns.']}",
    'technicalCapabilities': "['Network-level caller ID verification', 'Analytics Dashboard']",
    'deploymentModels': "['Cloud-based activation on existing numbers']",
    'integrations': "['Airtel Network', 'CRM via API (optional)']"
  },
  'prod_sd_wan': {
    'officialFeaturesAndBenefits': "{'All-in-one branch solution': ['Reduce complex multi-vendor interoperability to ensure quick deployment of branch networks within days.'], 'Streamlined operations': ['End to end managed services from network design and implementation to maintenance and 24*7 support.'], 'Network expertise': ['Achieve faster roll out using media agnostic connectivity paired with software-defined networking solutions.'], 'Powerful insights': ['Single dashboard for real-time analytics into performance, network, devices, and location data.'], 'Enhanced security': ['Safeguard branch networks with malware protection, content filtering, identity based firewall and intrusion prevention.'], 'Cost optimization': ['OPEX-based pricing and a shared resources NOC resulting in reduced costs compared to multiple vendor offerings.']}",
    'technicalCapabilities': "['Media agnostic connectivity', 'Identity-based firewall', 'Intrusion prevention', 'Real-time analytics']",
    'deploymentModels': "['Managed Service (OPEX-based)']",
    'integrations': "['Wireless LAN', 'Security appliances']"
  },
  'prod_wfas': {
    'officialFeaturesAndBenefits': "{'Multiple Hybrid Connectivity': ['2 WAN ports', '2 SIM slots'], 'Stable High-speed Connectivity': ['Bandwidth aggregation', 'Automatic failover'], 'Plug & Play Solution': ['Zero-touch provisioning', 'Service provider agnostic'], 'Managed Solution': ['Analytics & Alerts', 'Customer Portal & Dashboards']}",
    'technicalCapabilities': "['Zero-touch provisioning', 'Bandwidth aggregation', 'Automatic failover']",
    'deploymentModels': "['Plug & Play Router']",
    'integrations': "['Customer Portal']"
  },
  'prod_ill': {
    'officialFeaturesAndBenefits': "{'Superfast speed & top-notch security': ['Scale your speed as per requirement ranging from 10Mbps to 100Gbps.', 'Get world-class DDoS protection and built-in firewall security.'], 'Dedicated bandwidth': ['Get symmetric upload and download bandwidth of 200TB for data-intensive tasks and digital communications.'], 'Reliable internet': ['Ensure 99.5% uptime and near-zero latency on FTTH or fiber, regardless of user volume or bandwidth-intensive applications.'], 'Burstable bandwidth': ['Get flexible and scalable connectivity with burstable bandwidth up to five times the base bandwidth, at minimal added cost.'], 'Unmatched network reach': ['4,00,000+ RKM of fiber network across 50 countries & 5 continents, 34+ international cables, 65+ global and 121 domestic PoPs.'], '24*7 support': ['World-class SLA with 100% troubleshooting. 24*7 support via Airtel Thanks for Business.']}",
    'technicalCapabilities': "['10Mbps to 100Gbps speeds', 'Symmetric upload/download', 'DDoS protection built-in', 'Burstable bandwidth up to 5x']",
    'deploymentModels': "['FTTH', 'Fiber Leased Line']",
    'integrations': "['Airtel Thanks for Business Portal']"
  },
  'prod_iot': {
    'officialFeaturesAndBenefits': "{'IoTHub': ['One platform to easily manage all your connected devices with flexible billings, network feasibility map and flexible APN which is secure by design.'], '5G, NBIoT ready': ['Powered by range of connectivity services and vast network to ensure connectivity for all your devices.'], 'Leverage telco capabilities': ['Option to send/receive bulk SMS, support for emergency calling and location services (SIM based) without using GPS.'], 'Real-time insights': ['Monitor real-time SIM wise data usage and diagnose issues with automated tests. Deep-dive into core network performance.']}",
    'technicalCapabilities': "['5G ready', 'NB-IoT ready', 'SIM-based location services', 'Secure APN']",
    'deploymentModels': "['IoT SIM Cards']",
    'integrations': "['IoTHub Platform']"
  },
  'prod_secure_internet': {
    'officialFeaturesAndBenefits': "{'Extensive network': ['Enterprise-grade Pan-India Internet for secure, consistent connectivity across all office locations.'], 'Managed services': ['End-to-end managed security services with 24/7 monitoring, support and a robust reporting portal.'], 'Proactive monitoring': ['Dedicated Security Operations Center (SOC) with a workforce of 350+ certified professionals, including ZCDS and ZCSS.'], 'Multi-ISP links protection': ['Protection for all your internet links across offices, regardless of the service provider.'], 'User-centric access': ['Zscaler’s ZTA prioritizes identity verification, ensuring all users—office or remote—are authenticated before accessing applications.'], 'Micro-segmentation': ['By segmenting the network into zones, Zscaler reduces lateral movement risks, enabling effective isolation of sensitive data and applications.']}",
    'technicalCapabilities': "['Zero Trust Architecture (ZTA)', 'Micro-segmentation', 'Multi-ISP link protection', 'Zscaler Security Service Edge (SSE)']",
    'deploymentModels': "['Managed Service via SOC']",
    'integrations': "['Zscaler ZTA', 'Airtel Internet Leased Line (ILL)']"
  },
  'prod_whatsapp_business': {
    'officialFeaturesAndBenefits': "{'Create customized campaigns': ['Boost your ROI with curated campaigns designed for better impact.', 'Deliver personalized ad creatives that resonate with millions of customers in no time.'], 'Automated conversational marketing': ['Create customized campaigns that speak directly to your audience.'], 'Secure messaging experiences': ['Immediate and secure messaging experiences that effortlessly cater to your customers needs.']}",
    'technicalCapabilities': "['WhatsApp Business API integration']",
    'deploymentModels': "['Cloud API']",
    'integrations': "['Airtel IQ']"
  }
}

# For the rest of the products, we add empty maps and arrays
all_products = ['prod_corporate_postpaid', 'prod_iq_business_connect', 'prod_sd_wan', 'prod_sip_trunking', 'prod_ccaas', 'prod_managed_wifi', 'prod_mpls', 'prod_wfas', 'prod_5g_enterprise', 'prod_cpaas', 'prod_ill', 'prod_colocation', 'prod_global_voice', 'prod_iot', 'prod_office_internet', 'prod_precise_positioning', 'prod_public_cloud', 'prod_secure_internet', 'prod_whatsapp_business']

for prod in all_products:
    if prod in mappings:
        data = mappings[prod]
    else:
        data = {
            'officialFeaturesAndBenefits': "{}",
            'technicalCapabilities': "[]",
            'deploymentModels': "[]",
            'integrations': "[]"
        }
    
    insertion_string = f"""
    keyDifferentiators: [
"""
    replace_string = f"""
    officialFeaturesAndBenefits: {data['officialFeaturesAndBenefits']},
    technicalCapabilities: {data['technicalCapabilities']},
    deploymentModels: {data['deploymentModels']},
    integrations: {data['integrations']},
    keyDifferentiators: [
"""
    
    # We find the start of keyDifferentiators for this product to insert right before it
    # We can use regex to target the specific block if needed, but since keys are unique to each block,
    # wait, keyDifferentiators is just a property.
    
    # Let's do a split by product keys
    pattern = f"'{prod}': const EnrichedProduct\\("
    if pattern.replace("\\", "") in content:
        parts = content.split(pattern.replace("\\", ""))
        # parts[1] contains the product details
        subparts = parts[1].split("keyDifferentiators: [", 1)
        if len(subparts) == 2:
            parts[1] = subparts[0] + replace_string.strip() + " [" + subparts[1]
            content = pattern.replace("\\", "").join(parts)

with open(dart_file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Dart file updated successfully.")
