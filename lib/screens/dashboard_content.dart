import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/charts_widget.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1100;
    
    return Column(
      children: [
        // Top Header
        const TopHeader(),
        
        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainArea(context),
                      const SizedBox(height: 24),
                      _buildRightSidebar(context),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left/Main Area (Takes up most space)
                      Expanded(
                        flex: 3,
                        child: _buildMainArea(context),
                      ),
                      
                      const SizedBox(width: 24),
                      
                      // Right Sidebar Area
                      Expanded(
                        flex: 1,
                        child: _buildRightSidebar(context),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainArea(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 850;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Text
        const Text(
          'Welcome back, Admin 👋',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Here's what's happening with Okdoz today.",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 24),

        // Filter Row (Dummy)
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.end,
          children: [
            _buildFilterDropdown('All Cities'),
            _buildFilterDropdown('All Sectors'),
            _buildFilterDropdown('Today'),
          ],
        ),
        const SizedBox(height: 24),

        // Top KPI Row
        const KpiRow(),
        const SizedBox(height: 24),

        // Category Cards Row
        const CategoryCardsRow(),
        const SizedBox(height: 24),

        // Charts Row
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  SalesChartCard(),
                  SizedBox(height: 24),
                  SectorChartCard(),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 3, child: SalesChartCard()),
                  SizedBox(width: 24),
                  Expanded(flex: 2, child: SectorChartCard()),
                ],
              ),
        const SizedBox(height: 24),

        // Live Orders Table
        const LiveOrdersTable(),
      ],
    );
  }

  Widget _buildRightSidebar(BuildContext context) {
    return Column(
      children: const [
        LiveActivityWidget(),
        SizedBox(height: 24),
        TopPerformingWidget(),
        SizedBox(height: 24),
        RecentFeedbackWidget(),
      ],
    );
  }

  Widget _buildFilterDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(hint, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 16),
        ],
      ),
    );
  }
}
