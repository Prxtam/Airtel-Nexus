const Map<String, String> canonicalProductAliases = {
  'Airtel Cloud': 'Airtel Public Cloud',
  'Airtel Cloud (Edge Compute)': 'Airtel Public Cloud',
  'Airtel Colocation': 'Airtel Colocation (Nxtra)',
  'Airtel Data Center Services': 'Airtel Colocation (Nxtra)',
  'Airtel Data Center Services (Nxtra)': 'Airtel Colocation (Nxtra)',
  'Airtel Dedicated Internet (ILL)': 'Airtel Leased Line (ILL)',
  'Airtel Leased Line': 'Airtel Leased Line (ILL)',
  'Airtel IoT': 'Airtel IoT Connectivity',
  'Airtel MPLS': 'Airtel VPN/MPLS',
  'Airtel Secure SOC': 'Airtel Secure Internet',
};

String canonicalizeProductName(String name) {
  return canonicalProductAliases[name] ?? name;
}

List<String> canonicalizeProductNames(Iterable<String> names) {
  return names.map(canonicalizeProductName).toList();
}
