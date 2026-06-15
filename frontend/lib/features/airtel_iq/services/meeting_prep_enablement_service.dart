import 'package:frontend/features/airtel_iq/models/product_enablement_model.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_enablement_repository.dart';

class MeetingPrepEnablementService {
  /// Returns the enablement data for a given product name, if it exists in Phase 6.
  ProductEnablement? getEnablementForProduct(String productName) {
    for (final enablement in ProductEnablementRepository.enablements) {
      if (enablement.productName == productName) {
        return enablement;
      }
    }
    return null; // Return null if Phase 6 data isn't mapped for this product yet
  }
}
