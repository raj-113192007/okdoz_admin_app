import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopHeader(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;
              
              if (isMobile) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFinanceCard('Total Balance', '₹ 0', Icons.account_balance_wallet, Colors.green),
                      const SizedBox(height: 16),
                      _buildFinanceCard('Total Payouts', '₹ 0', Icons.payments, Colors.orange),
                      const SizedBox(height: 16),
                      _buildFinanceCard('Pending Clears', '₹ 0', Icons.pending_actions, Colors.red),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 300,
                        child: _buildChartArea(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 400,
                        child: _buildRecentTransactions(),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildFinanceCard('Total Balance', '₹ 0', Icons.account_balance_wallet, Colors.green)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildFinanceCard('Total Payouts', '₹ 0', Icons.payments, Colors.orange)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildFinanceCard('Pending Clears', '₹ 0', Icons.pending_actions, Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: _buildChartArea(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: _buildRecentTransactions(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChartArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Text(
          'Finance Chart Area\n(Integrate with fl_chart)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text(
                'No recent transactions.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }
}
