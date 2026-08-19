import 'package:flutter/material.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(width: 48), // Replaces Spacer for horizontal scroll
            
            // Search Bar
            Container(
              width: 300,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search anything...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            
            // Date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Text('24 May 2025', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                  SizedBox(width: 8),
                  Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B), size: 16),
                ],
              ),
            ),
            const SizedBox(width: 24),
            
            // Icons
            Stack(
              children: [
                const Icon(Icons.notifications_none, color: Color(0xFF64748B)),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 8)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            const Icon(Icons.message_outlined, color: Color(0xFF64748B)),
            const SizedBox(width: 16),
            const Icon(Icons.dark_mode_outlined, color: Color(0xFF64748B)),
            const SizedBox(width: 24),
            
            // Profile
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(Icons.person, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                    Text('Super Admin', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KpiRow extends StatelessWidget {
  const KpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: _buildKpiCard('Total Revenue', '₹ 0', '0.0%', true, Icons.account_balance_wallet, Colors.orange),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: _buildKpiCard('Total Orders', '0', '0.0%', true, Icons.receipt_long, Colors.purple),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: _buildKpiCard('Completed Orders', '0', '0.0%', true, Icons.check_circle_outline, Colors.green),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: _buildKpiCard('Total Customers', '0', '0.0%', true, Icons.people_alt_outlined, Colors.amber),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 170,
            child: _buildKpiCard('Active Delivery', '0', '0.0%', true, Icons.two_wheeler, Colors.blue),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: _buildKpiCard('Cancelled Orders', '0', '0.0%', false, Icons.cancel_outlined, Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String percentage, bool isPositive, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  percentage,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('vs yesterday', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCardsRow extends StatelessWidget {
  const CategoryCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1100;
    
    if (isMobile) {
      return Column(
        children: [
          Row(children: [Expanded(child: _buildCategoryCard('Restaurant', '0', '₹ 0', Icons.restaurant, Colors.orange)), const SizedBox(width: 16), Expanded(child: _buildCategoryCard('Grocery', '0', '₹ 0', Icons.local_grocery_store, Colors.green))]),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: _buildCategoryCard('Pharmacy', '0', '₹ 0', Icons.local_pharmacy, Colors.blue)), const SizedBox(width: 16), Expanded(child: _buildCategoryCard('Pickup', '0', '₹ 0', Icons.local_shipping, Colors.amber))]),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: _buildCategoryCard('Electronics', '0', '₹ 0', Icons.electrical_services, Colors.grey.shade700)), const SizedBox(width: 16), const Expanded(child: SizedBox())]),
        ],
      );
    }
    
    return Row(
      children: [
        Expanded(child: _buildCategoryCard('Restaurant', '0', '₹ 0', Icons.restaurant, Colors.orange)),
        const SizedBox(width: 16),
        Expanded(child: _buildCategoryCard('Grocery', '0', '₹ 0', Icons.local_grocery_store, Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _buildCategoryCard('Pharmacy', '0', '₹ 0', Icons.local_pharmacy, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildCategoryCard('Pickup & Courier', '0', '₹ 0', Icons.local_shipping, Colors.amber)),
        const SizedBox(width: 16),
        Expanded(child: _buildCategoryCard('Electronics', '0', '₹ 0', Icons.electrical_services, Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String orders, String revenue, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(orders, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
                    const Text('Orders', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text(revenue, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
                    const Text('Revenue', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'View Details →',
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveOrdersTable extends StatelessWidget {
  const LiveOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All Orders →', style: TextStyle(color: Color(0xFFFF6D00))),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
                  child: Column(
                    children: [
                      // Table Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: const [
                            Expanded(flex: 2, child: Text('Order ID', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                            Expanded(flex: 2, child: Text('Type', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                            Expanded(flex: 2, child: Text('Customer', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                            Expanded(flex: 2, child: Text('Partner', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                            Expanded(flex: 2, child: Text('Status', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                            Expanded(flex: 1, child: Text('Time', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                            Expanded(flex: 1, child: Text('Amount', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                  const Divider(height: 1),
                  // Empty state for now
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                      child: Text('No live orders at the moment.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    ],
  ),
);
}

  Widget _buildOrderRow(String id, String type, IconData icon, Color iconColor, String customer, String partner, String status, Color statusColor, String time, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(id, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E293B)))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 8),
                Text(type, style: const TextStyle(color: Color(0xFF1E293B))),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(customer, style: const TextStyle(color: Color(0xFF1E293B)))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const CircleAvatar(radius: 12, backgroundColor: Color(0xFFE2E8F0), child: Icon(Icons.person, size: 16, color: Colors.grey)),
                const SizedBox(width: 8),
                Text(partner, style: const TextStyle(color: Color(0xFF1E293B))),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Expanded(flex: 1, child: Text(time, style: const TextStyle(color: Color(0xFF64748B)))),
          Expanded(flex: 1, child: Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
        ],
      ),
    );
  }
}

// Sidebar Widgets (Right)

class LiveActivityWidget extends StatelessWidget {
  const LiveActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Live Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              TextButton(onPressed: () {}, child: const Text('View all', style: TextStyle(fontSize: 12))),
            ],
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text('No recent activity.', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, Color color, String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        ],
      ),
    );
  }
}

class TopPerformingWidget extends StatelessWidget {
  const TopPerformingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Performing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Restaurants', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFFF6D00))),
              Text('Grocery Stores', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              Text('Pharmacies', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            ],
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text('Not enough data.', style: TextStyle(color: Colors.grey)),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('View All Restaurants →', style: TextStyle(color: Color(0xFFFF6D00))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformingItem(String rank, String name, String revenue, String orders, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(rank, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(revenue, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
              Text(orders, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }
}

class RecentFeedbackWidget extends StatelessWidget {
  const RecentFeedbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(fontSize: 12))),
            ],
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text('No recent feedback.', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(String name, String comment, int rating, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, backgroundColor: Color(0xFFE2E8F0), child: Icon(Icons.person, size: 16, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 12,
                        color: Colors.amber,
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
