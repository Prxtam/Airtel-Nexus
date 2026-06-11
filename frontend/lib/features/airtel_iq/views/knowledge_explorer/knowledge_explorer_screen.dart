import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_intelligence.dart';
import 'package:frontend/features/airtel_iq/knowledge/industry_intelligence.dart';
import 'package:frontend/features/airtel_iq/knowledge/sales_methodology.dart';

class KnowledgeExplorerScreen extends StatefulWidget {
  const KnowledgeExplorerScreen({super.key});

  @override
  State<KnowledgeExplorerScreen> createState() => _KnowledgeExplorerScreenState();
}

class _KnowledgeExplorerScreenState extends State<KnowledgeExplorerScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  List<ProductIntelligence> _filteredProducts = [];
  List<IndustryIntelligence> _filteredIndustries = [];
  List<MeetingMethodology> _filteredMethodologies = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredProducts = productIntelligenceRepo;
    _filteredIndustries = industryIntelligenceRepo;
    _filteredMethodologies = salesMethodologyRepo;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = productIntelligenceRepo
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
      _filteredIndustries = industryIntelligenceRepo
          .where((i) => i.industryName.toLowerCase().contains(query))
          .toList();
      _filteredMethodologies = salesMethodologyRepo
          .where((m) => m.meetingType.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _appendList(StringBuffer sb, String title, List<String> items) {
    sb.writeln(title.toUpperCase());
    if (items.isEmpty) {
      sb.writeln('None');
    } else {
      for (var item in items) {
        sb.writeln('• $item');
      }
    }
    sb.writeln();
  }

  String _buildProductExport(ProductIntelligence product) {
    final sb = StringBuffer();
    sb.writeln(product.name);
    sb.writeln();
    sb.writeln('OVERVIEW');
    sb.writeln(product.overview);
    sb.writeln();
    _appendList(sb, 'Ideal Customers', product.idealCustomers);
    _appendList(sb, 'Industries', product.industries);
    _appendList(sb, 'Pain Points Solved', product.painPointsSolved);
    _appendList(sb, 'Business Outcomes', product.businessOutcomes);
    _appendList(sb, 'Discovery Questions', product.discoveryQuestions);
    _appendList(sb, 'Objections', product.objections);
    _appendList(sb, 'Objection Responses', product.objectionResponses);
    _appendList(sb, 'Cross Sell Opportunities', product.crossSellOpportunities);
    sb.writeln('ELEVATOR PITCH');
    sb.writeln(product.elevatorPitch);
    sb.writeln();
    sb.writeln('EXECUTIVE PITCH');
    sb.writeln(product.executivePitch);
    sb.writeln();
    _appendList(sb, 'Meeting Talking Points', product.meetingTalkingPoints);
    return sb.toString().trimRight();
  }

  String _buildIndustryExport(IndustryIntelligence ind) {
    final sb = StringBuffer();
    sb.writeln(ind.industryName);
    sb.writeln();
    _appendList(sb, 'Business Challenges', ind.businessChallenges);
    _appendList(sb, 'Technology Challenges', ind.technologyChallenges);
    _appendList(sb, 'Recommended Products', ind.recommendedProducts);
    _appendList(sb, 'Discovery Questions', ind.discoveryQuestions);
    _appendList(sb, 'Objections', ind.objections);
    _appendList(sb, 'Sales Opportunities', ind.salesOpportunities);
    return sb.toString().trimRight();
  }

  String _buildMethodologyExport(MeetingMethodology meth) {
    final sb = StringBuffer();
    sb.writeln(meth.meetingType);
    sb.writeln();
    sb.writeln('PURPOSE');
    sb.writeln(meth.purpose);
    sb.writeln();
    sb.writeln('PRIMARY GOAL');
    sb.writeln(meth.primaryGoal);
    sb.writeln();
    _appendList(sb, 'Key Questions', meth.keyQuestions);
    _appendList(sb, 'Focus Areas', meth.focusAreas);
    _appendList(sb, 'Risks', meth.risks);
    _appendList(sb, 'Success Indicators', meth.successIndicators);
    _appendList(sb, 'Next Best Actions', meth.nextBestActions);
    return sb.toString().trimRight();
  }

  Widget _buildCopyButton(BuildContext context, String textToCopy, String successMessage) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        icon: const Icon(Icons.copy, size: 16),
        label: const Text('Copy Entire Entry'),
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: textToCopy));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(successMessage)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Knowledge Explorer'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Industries'),
            Tab(text: 'Methodologies'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSummaryAndSearch(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsTab(),
                _buildIndustriesTab(),
                _buildMethodologiesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryAndSearch() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Browse Airtel IQ products, industries, and sales methodologies.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryStat('Products', productIntelligenceRepo.length.toString(), Colors.purple),
              _buildSummaryStat('Industries', industryIntelligenceRepo.length.toString(), Colors.blue),
              _buildSummaryStat('Methodologies', salesMethodologyRepo.length.toString(), Colors.teal),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search repository...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String count, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
      ],
    );
  }

  Widget _buildProductsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              product.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            childrenPadding: const EdgeInsets.all(16.0),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCopyButton(context, _buildProductExport(product), 'Product copied to clipboard'),
              const SizedBox(height: 8),
              SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Overview'),
                    Text(product.overview),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Ideal Customers'),
                    _buildBulletList(product.idealCustomers),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Industries'),
                    _buildBulletList(product.industries),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Pain Points Solved'),
                    _buildBulletList(product.painPointsSolved),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Business Outcomes'),
                    _buildBulletList(product.businessOutcomes),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Discovery Questions'),
                    _buildBulletList(product.discoveryQuestions),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Likely Objections'),
                    _buildBulletList(product.objections),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Suggested Responses'),
                    _buildBulletList(product.objectionResponses),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Cross-Sell Opportunities'),
                    _buildBulletList(product.crossSellOpportunities),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Elevator Pitch'),
                    Text(product.elevatorPitch),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Executive Pitch'),
                    Text(product.executivePitch),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIndustriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredIndustries.length,
      itemBuilder: (context, index) {
        final industry = _filteredIndustries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(industry.industryName, style: const TextStyle(fontWeight: FontWeight.bold)),
            childrenPadding: const EdgeInsets.all(16.0),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCopyButton(context, _buildIndustryExport(industry), 'Industry copied to clipboard'),
              const SizedBox(height: 8),
              SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Business Challenges'),
                    _buildBulletList(industry.businessChallenges),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Technology Challenges'),
                    _buildBulletList(industry.technologyChallenges),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Recommended Products'),
                    _buildBulletList(industry.recommendedProducts),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Discovery Questions'),
                    _buildBulletList(industry.discoveryQuestions),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Objections'),
                    _buildBulletList(industry.objections),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Sales Opportunities'),
                    _buildBulletList(industry.salesOpportunities),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMethodologiesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredMethodologies.length,
      itemBuilder: (context, index) {
        final meth = _filteredMethodologies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(meth.meetingType, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(meth.purpose, maxLines: 1, overflow: TextOverflow.ellipsis),
            childrenPadding: const EdgeInsets.all(16.0),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCopyButton(context, _buildMethodologyExport(meth), 'Methodology copied to clipboard'),
              const SizedBox(height: 8),
              SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Purpose'),
                    Text(meth.purpose),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Primary Goal'),
                    Text(meth.primaryGoal),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Key Questions'),
                    _buildBulletList(meth.keyQuestions),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Focus Areas'),
                    _buildBulletList(meth.focusAreas),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Risks'),
                    _buildBulletList(meth.risks),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Success Indicators'),
                    _buildBulletList(meth.successIndicators),
                    const SizedBox(height: 12),
                    _buildSectionTitle('Next Best Actions'),
                    _buildBulletList(meth.nextBestActions),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryColor, fontSize: 14),
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    if (items.isEmpty) return const Text('None', style: TextStyle(fontStyle: FontStyle.italic));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(item, style: const TextStyle(height: 1.3))),
            ],
          ),
        );
      }).toList(),
    );
  }
}
