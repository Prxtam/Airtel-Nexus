# Product Enrichment Plan

This plan addresses the massive content enrichment of 19 Airtel Business products without touching the core intelligence engine.

## Task 1: Product Enrichment Audit

The `PRODUCTS.docx` document provides rich marketing copy for several products:
- **Corporate Postpaid**: Features dynamic pooling, TraceMate, BND.
- **Dedicated Internet / IPLC / NLD**: Symmetry, SLAs, 400k+ RKM fiber.
- **Secure Internet**: Zscaler SSE integration, Zero Trust Architecture.
- **IoT Connectivity**: IoTHub, NB-IoT, real-time insights.
- **WhatsApp API**: Rich media, intelligent fallback.
- **Public Cloud**: RBI/IRDAI compliance, automated provisioning.
- **Managed Wi-Fi & SD-WAN**: Centralized dashboard, security, fast rollout.

*Gap Analysis*: Products like *Airtel 5G for Enterprise*, *Precise Positioning*, *CCaaS*, and *SIP Trunking* are missing from the document. I will use standard enterprise B2B sales knowledge to enrich these products, matching the tone and quality of the provided document. All buzzwords ("world-class", "best-in-class") will be stripped in favor of concrete capabilities.

## Task 5: Reusable Repository Structure

I will create `frontend/lib/features/airtel_iq/knowledge/product_enrichment_repository.dart`.
This will define an `EnrichedProduct` model and a Map mapping the existing `id` of each of the 19 products to its enriched data.

```dart
class EnrichedProduct {
  final String id;
  final String whatItIs;
  final List<String> keyCapabilities;
  final List<String> idealIndustries;
  final String whenToPitchIt;
  final List<String> businessOutcomes;
  final List<ObjectionHandling> objections;
  final List<String> crossSellOpportunities;
  // ... constructor ...
}

class ObjectionHandling {
  final String objection;
  final String response;
  // ... constructor ...
}

final Map<String, EnrichedProduct> productEnrichmentData = { ... };
```

## Task 2 & 3: Content Generation (Pitching & Objections)

For each of the 19 products, I will rewrite:
1. **Positioning / What it is**: Executive-friendly, specific descriptions.
2. **When to Pitch It**: Triggers for Account Managers.
3. **Business Outcomes**: Concrete results (e.g., "Reduce multi-vendor management overhead", not "super fast speed").
4. **Objection Handling**: 3 real-world objections per product (Cost, Migration Complexity, Security/Compliance, Adoption) with consultative responses.

## Task 4: UI Integration

I will update `frontend/lib/features/airtel_iq/views/products/product_detail_screen.dart` to consume `productEnrichmentData`.
- I will replace the current mocked `AirtelIqMockData` usage with a lookup into the new `product_enrichment_repository.dart`.
- The screen will be redesigned to show the new fields: *What it is, Key Capabilities, Ideal Industries, When to Pitch It, Business Outcomes, Common Objections, and Cross-Sell Opportunities*.

## Verification Plan
1. The engine files (`meeting_prep_intelligence_engine.dart` and `product_intelligence.dart`) will remain completely untouched.
2. I will run a Dart build to ensure the new repository and UI screens compile correctly.
3. I will provide a before/after snippet of the data structure.

> [!IMPORTANT]
> Since this is a massive text generation task for 19 products, the new repository file will be quite large. I will ensure strict adherence to avoiding generic buzzwords and focus entirely on consultative B2B sales language.

Please approve this implementation plan so I can begin generating the repository and updating the UI.
