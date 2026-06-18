import re

dart_file_path = "lib/features/airtel_iq/views/products/product_detail_screen.dart"

with open(dart_file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace the children array inside the Column in build()
new_children = """children: [
              _buildQuickGlanceHero(product),
              const SizedBox(height: 24),
              
              _buildSectionTitle('What is this product?'),
              _buildTextContent(product.whatItIs),
              const SizedBox(height: 24),

              if (product.officialFeaturesAndBenefits.isNotEmpty) ...[
                _buildSectionTitle('🚀 Official Features & Benefits'),
                _buildOfficialFeatures(product),
                const SizedBox(height: 24),
              ],

              if (product.businessOutcomes.isNotEmpty) ...[
                _buildSectionTitle('🎯 Business Value'),
                ...product.businessOutcomes.map((b) => _buildBulletPoint(b, Colors.black87)),
                const SizedBox(height: 24),
              ],

              _buildSectionTitle('💡 When should I pitch this?'),
              _buildTextContent(product.whenToPitch),
              const SizedBox(height: 24),

              _buildCollapsibleSection(
                '🧠 How to position it',
                _buildTextContent(product.positioningStatement),
              ),

              if (product.customerSignals.isNotEmpty)
                _buildCollapsibleSection(
                  '📡 Customer Signals',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: product.customerSignals.map((s) => _buildBulletPoint(s, Colors.black87)).toList(),
                  ),
                ),

              if (product.discoveryHooks.isNotEmpty)
                _buildCollapsibleSection(
                  '❓ Discovery Questions',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: product.discoveryHooks.map((q) => _buildBulletPoint(q, Colors.black87)).toList(),
                  ),
                ),

              if (product.commonObjections.isNotEmpty)
                _buildCollapsibleSection(
                  '🛡️ Common Objections',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: product.commonObjections.map((obj) => _buildObjectionAccordion(obj)).toList(),
                  ),
                ),

              const SizedBox(height: 12),

              if (product.crossSellProducts.isNotEmpty) ...[
                _buildSectionTitle('🤝 Cross-Sell Opportunities'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.crossSellProducts.map((c) {
                    final targetId = _getProductIdByName(c);
                    return ActionChip(
                      label: Text(c, style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.blue.shade50,
                      side: BorderSide(color: Colors.blue.shade200),
                      onPressed: targetId.isNotEmpty ? () {
                        context.push('/airtel-iq/products/$targetId');
                      } : null,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              if (product.fiveThingsToRemember.isNotEmpty) ...[
                _buildSectionTitle('🧠 5 Things To Remember'),
                ...product.fiveThingsToRemember.map((item) => _buildBulletPoint(item, Colors.purple.shade700)),
                const SizedBox(height: 24),
              ],

              if (product.whenNotToPitch.isNotEmpty) ...[
                _buildSectionTitle('⚠️ When NOT To Pitch This', color: Colors.red.shade700),
                ...product.whenNotToPitch.map((q) => _buildBulletPoint(q, Colors.red.shade700, icon: Icons.close)),
                const SizedBox(height: 32),
              ],
            ],"""

# We need to replace everything from "children: [" to "            ]," right before "          )," in the build method.
# Since it's tricky, we'll use regex.
pattern_children = r"children:\s*\[\s*_buildQuickGlanceHero\(product\),[\s\S]*?if\s*\(product\.whenNotToPitch\.isNotEmpty\)[\s\S]*?\]\s*,\s*\]\s*,"
content = re.sub(pattern_children, new_children, content)

# Now we need to add the helper method _buildCollapsibleSection before _buildObjectionAccordion
new_helper = """
  Widget _buildCollapsibleSection(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
        ),
        iconColor: AppConstants.primaryColor,
        collapsedIconColor: Colors.grey.shade600,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          content,
        ],
      ),
    );
  }

  Widget _buildObjectionAccordion"""

content = content.replace("  Widget _buildObjectionAccordion", new_helper)

# Also update _buildOfficialFeatures to remove the empty state container
pattern_official = r"    if \(product\.officialFeaturesAndBenefits\.isEmpty\) \{[\s\S]*?return Container\([\s\S]*?\}\n\n    return Column\("
content = re.sub(pattern_official, "    return Column(", content)

# Remove the title inside _buildOfficialFeatures since we moved it outside?
# Wait, the title inside _buildOfficialFeatures is for each *group* (e.g. 🚀 Multiple Hybrid Connectivity).
# I should just make sure it stays. 
# Wait! I removed the placeholder logic, but if product.officialFeaturesAndBenefits.isEmpty it will now just return an empty Column.
# But we added `if (product.officialFeaturesAndBenefits.isNotEmpty) ...[` in the build method, so it won't even be called! That's perfect.

# One more thing: I need to update the 5G for Enterprise features in product_enrichment_repository.dart to match the user's specific wording.
# "Private 5G deployments, Smart factory enablement, Industrial automation, Real-time robotics support, AI/video analytics support"
# I already wrote this exactly in my inject_11.py! So that's already handled.

with open(dart_file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("UI Refinements applied successfully.")
