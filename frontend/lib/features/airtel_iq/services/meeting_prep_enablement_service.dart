import 'package:frontend/features/airtel_iq/models/product_enablement_model.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_enablement_repository.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_aliases.dart';

class MeetingPrepEnablementService {
  /// Returns the enablement data for a given product name, if it exists in Phase 6.
  ProductEnablement? getEnablementForProduct(String productName) {
    final canonicalName = canonicalizeProductName(productName);
    for (final enablement in ProductEnablementRepository.enablements) {
      if (canonicalizeProductName(enablement.productName) == canonicalName) {
        return enablement;
      }
    }
    return null;
  }
}
