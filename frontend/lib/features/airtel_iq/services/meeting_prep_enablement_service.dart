import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_aliases.dart';

class MeetingPrepEnablementService {
  /// Returns the enriched enablement data for a given product name.
  EnrichedProduct? getEnablementForProduct(String productName) {
    final canonicalName = canonicalizeProductName(productName);
    for (final enablement in productEnrichmentData.values) {
      if (canonicalizeProductName(enablement.productName) == canonicalName) {
        return enablement;
      }
    }
    return null;
  }
}
