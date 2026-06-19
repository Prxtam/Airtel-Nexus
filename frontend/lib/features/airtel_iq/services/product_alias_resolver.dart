import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';

/// Centralized product name alias resolver for Airtel IQ.
///
/// All modules (Industry Playbooks, Meeting Prep, Opportunity Insights,
/// Objection Coach, etc.) should use [ProductAliasResolver.resolve] whenever
/// they need to look up a product by name from an external source
/// (e.g. industry_intelligence.dart references).
///
/// This prevents UI navigation failures caused by mismatched product names
/// across the app's knowledge repositories.
class ProductAliasResolver {
  ProductAliasResolver._();

  /// Alias map: non-canonical name → canonical productName in repository.
  ///
  /// Keys are the variant names found across repositories/screens.
  /// Values are the exact [EnrichedProduct.productName] strings.
  static const Map<String, String> _aliases = {
    // IoT variants
    'Airtel IoT': 'Airtel IoT Connectivity',
    'Airtel IoT Solutions': 'Airtel IoT Connectivity',
    'Airtel IoT Platform': 'Airtel IoT Connectivity',

    // Leased Line / ILL variants
    'Airtel Leased Line': 'Airtel Dedicated Internet (ILL)',
    'Airtel ILL': 'Airtel Dedicated Internet (ILL)',
    'Airtel Internet Leased Line': 'Airtel Dedicated Internet (ILL)',

    // Colocation / Data Center variants
    'Airtel Data Center Services (Nxtra)': 'Airtel Colocation (Nxtra)',
    'Airtel Data Center Services': 'Airtel Colocation (Nxtra)',
    'Airtel Nxtra': 'Airtel Colocation (Nxtra)',
    'Nxtra Data Centers': 'Airtel Colocation (Nxtra)',
    'Nxtra': 'Airtel Colocation (Nxtra)',

    // CCaaS variants
    'Airtel CCaaS': 'Airtel Contact Center as a Service',
    'Airtel Contact Center': 'Airtel Contact Center as a Service',

    // CPaaS / WhatsApp variants
    'Airtel WhatsApp Business API': 'Airtel WhatsApp Business',
    'Airtel WhatsApp': 'Airtel WhatsApp Business',
    'WhatsApp Business API': 'Airtel WhatsApp Business',

    // SD-WAN variants
    'Airtel Managed SD-WAN': 'Airtel SD-WAN',

    // Work From Anywhere variants
    'Airtel WFA': 'Airtel Work From Anywhere Solutions',
    'Airtel Work From Anywhere': 'Airtel Work From Anywhere Solutions',

    // Corporate Postpaid variants
    'Airtel Corporate SIM': 'Airtel Corporate Postpaid',
    'Corporate Postpaid': 'Airtel Corporate Postpaid',

    // Office Internet variants
    'Airtel Broadband': 'Airtel Office Internet',
    'Airtel Office Broadband': 'Airtel Office Internet',

    // Global Voice variants
    'Airtel International Voice': 'Airtel Global Voice',
  };

  /// Resolves [name] to its canonical product name.
  ///
  /// Resolution order:
  /// 1. Exact match against the repository (already canonical).
  /// 2. Alias lookup.
  /// 3. Returns null if no match found.
  static String? resolve(String name) {
    // 1. Exact match — name is already canonical
    if (productEnrichmentData.values.any((p) => p.productName == name)) {
      return name;
    }
    // 2. Alias lookup
    return _aliases[name];
  }

  /// Resolves [name] to the product's map key (ID) for direct navigation.
  ///
  /// Returns null if neither an exact match nor an alias is found.
  static String? resolveToId(String name) {
    final canonicalName = resolve(name);
    if (canonicalName == null) return null;
    for (final entry in productEnrichmentData.entries) {
      if (entry.value.productName == canonicalName) return entry.key;
    }
    return null;
  }

  /// Returns the [EnrichedProduct] for [name], resolving aliases automatically.
  static EnrichedProduct? resolveToProduct(String name) {
    final canonicalName = resolve(name);
    if (canonicalName == null) return null;
    try {
      return productEnrichmentData.values.firstWhere(
        (p) => p.productName == canonicalName,
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns true if [name] maps to a known product (exact or via alias).
  static bool isResolvable(String name) => resolve(name) != null;
}
