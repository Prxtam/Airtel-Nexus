class ActionItemService {
  /// Analyzes notes to deterministically extract Action Items
  /// separated into Customer and Airtel actions based on context.
  Map<String, List<String>> extractActionItems(String notes) {
    if (notes.isEmpty) return {'Customer': [], 'Airtel': []};

    final List<String> customerActions = [];
    final List<String> airtelActions = [];

    // Simple deterministic extraction: split by newlines, look for action keywords
    final lines = notes.split('\n');

    for (final line in lines) {
      final lowerLine = line.toLowerCase().trim();
      
      if (lowerLine.isEmpty) continue;

      bool isAction = lowerLine.startsWith('to do:') || 
                      lowerLine.startsWith('action:') || 
                      lowerLine.startsWith('- ') ||
                      lowerLine.contains('will provide') ||
                      lowerLine.contains('need to');

      if (isAction) {
        // Clean the prefix
        String cleanAction = line
            .replaceAll(RegExp(r'^(To do:|Action:|- )', caseSensitive: false), '')
            .trim();

        if (cleanAction.isEmpty) continue;

        // Determine ownership based on keywords
        if (lowerLine.contains('client') || lowerLine.contains('customer') || lowerLine.contains('they will')) {
          customerActions.add(cleanAction);
        } else {
          airtelActions.add(cleanAction);
        }
      }
    }

    // Fallback if no specific action lines found but notes contain general action keywords
    if (customerActions.isEmpty && airtelActions.isEmpty) {
      if (notes.toLowerCase().contains('proposal')) {
        airtelActions.add('Generate and send pricing proposal to the customer.');
      }
      if (notes.toLowerCase().contains('inventory') || notes.toLowerCase().contains('list')) {
        customerActions.add('Provide infrastructure inventory list for assessment.');
      }
      if (notes.toLowerCase().contains('follow up') || notes.toLowerCase().contains('next week')) {
        airtelActions.add('Schedule follow-up meeting for next week.');
      }
    }

    return {
      'Customer': customerActions,
      'Airtel': airtelActions,
    };
  }
}
