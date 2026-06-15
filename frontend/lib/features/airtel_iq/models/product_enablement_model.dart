class ProductEnablement {
  final String productName;
  final String positionItAs;
  final List<String> questionsToAsk;
  final List<String> businessValue;
  final List<String> crossSellOpportunities;

  const ProductEnablement({
    required this.productName,
    required this.positionItAs,
    required this.questionsToAsk,
    required this.businessValue,
    required this.crossSellOpportunities,
  });
}
