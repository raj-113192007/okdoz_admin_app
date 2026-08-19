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
        // Welcome Text & Filter Dropdowns in Single Inline Header Row
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Welcome back, Admin 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Here's what's happening with Okdoz today.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            
            // Compact Inline Filter Pills
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterDropdown('All Cities', Icons.location_on_outlined),
                _buildFilterDropdown('All Sectors', Icons.business_outlined),
                _buildFilterDropdown('Today', Icons.calendar_today_outlined),
              ],
            ),
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

  Widget _buildFilterDropdown(String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Prevents expanding full width!
        children: [
          Icon(icon, color: const Color(0xFFFF6D00), size: 15),
          const SizedBox(width: 6),
          Text(
            hint,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 16),
        ],
      ),
    );
  }
}
