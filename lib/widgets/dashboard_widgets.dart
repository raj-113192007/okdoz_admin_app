import 'package:flutter/material.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  void _showCommandPalette(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const CommandPaletteDialog(),
    );
  }

  void _showNotificationsDrawer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Notifications',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) => const SizedBox(),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 380,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.notifications_active_outlined, color: Color(0xFFFF6D00)),
                            SizedBox(width: 10),
                            Text(
                              'System Notifications',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          _notificationTile(
                            'New Restaurant Registered',
                            'Royal Sweets & Restaurant applied for approval.',
                            '10 mins ago',
                            Icons.storefront,
                            const Color(0xFFFF6D00),
                          ),
                          _notificationTile(
                            'Delivery Partner Signup',
                            'Rahul Sharma uploaded DL & RC documents.',
                            '45 mins ago',
                            Icons.two_wheeler,
                            Colors.purple,
                          ),
                          _notificationTile(
                            'High Value Order Placed',
                            'Order #1092 value ₹2,450 (Grocery sector).',
                            '2 hours ago',
                            Icons.shopping_bag_outlined,
                            Colors.green,
                          ),
                          _notificationTile(
                            'Technician Verification Request',
                            'Anil Kumar (RO Service Expert) updated profile.',
                            '5 hours ago',
                            Icons.build_outlined,
                            Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _notificationTile(String title, String subtitle, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 6),
                Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
            
            // Search Bar Trigger
            InkWell(
              onTap: () => _showCommandPalette(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 320,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF94A3B8), size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Search anything... (Ctrl + K)',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Ctrl K', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            
            // Date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Text('19 Aug 2026', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  SizedBox(width: 8),
                  Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B), size: 15),
                ],
              ),
            ),
            const SizedBox(width: 20),
            
            // Notifications Icon Trigger
            InkWell(
              onTap: () => _showNotificationsDrawer(context),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_none, color: Color(0xFF64748B), size: 24),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text('4', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.message_outlined, color: Color(0xFF64748B), size: 22),
            const SizedBox(width: 20),
            
            // Profile
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(Icons.person, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                    Text('Super Admin', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
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

class CommandPaletteDialog extends StatefulWidget {
  const CommandPaletteDialog({super.key});

  @override
  State<CommandPaletteDialog> createState() => _CommandPaletteDialogState();
}

class _CommandPaletteDialogState extends State<CommandPaletteDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> _allNavItems = const [
    {'title': 'Dashboard Overview', 'category': 'Page', 'icon': Icons.dashboard_outlined},
    {'title': 'Pending Merchant Approvals', 'category': 'Approvals', 'icon': Icons.verified_user_outlined},
    {'title': 'Restaurant Approvals', 'category': 'Approvals', 'icon': Icons.storefront_outlined},
    {'title': 'Grocery Approvals', 'category': 'Approvals', 'icon': Icons.local_grocery_store_outlined},
    {'title': 'Pharmacy Approvals', 'category': 'Approvals', 'icon': Icons.local_pharmacy_outlined},
    {'title': 'Pickup & Courier Approvals', 'category': 'Approvals', 'icon': Icons.local_shipping_outlined},
    {'title': 'Delivery Partner Approvals', 'category': 'Approvals', 'icon': Icons.two_wheeler_outlined},
    {'title': 'Technician Approvals', 'category': 'Approvals', 'icon': Icons.build_circle_outlined},
    {'title': 'Order Management', 'category': 'Management', 'icon': Icons.receipt_long_outlined},
    {'title': 'All Merchants List', 'category': 'Management', 'icon': Icons.store_mall_directory_outlined},
    {'title': 'Customer Database', 'category': 'Management', 'icon': Icons.people_outline},
    {'title': 'Delivery Partners List', 'category': 'Management', 'icon': Icons.badge_outlined},
    {'title': 'Technicians List', 'category': 'Management', 'icon': Icons.engineering_outlined},
    {'title': 'Finance Overview', 'category': 'Finance', 'icon': Icons.account_balance_wallet_outlined},
    {'title': 'Coupons & Discounts', 'category': 'Finance', 'icon': Icons.local_offer_outlined},
    {'title': 'Promotions & Banners', 'category': 'Marketing', 'icon': Icons.campaign_outlined},
    {'title': 'Reports & Analytics', 'category': 'Analytics', 'icon': Icons.bar_chart_outlined},
    {'title': 'Settings & Configurations', 'category': 'System', 'icon': Icons.settings_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _allNavItems.where((item) {
      final title = item['title'].toString().toLowerCase();
      final category = item['category'].toString().toLowerCase();
      return title.contains(_query.toLowerCase()) || category.contains(_query.toLowerCase());
    }).toList();

    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.only(top: 80, left: 16, right: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 460),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.search, color: Color(0xFFFF6D00), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (val) => setState(() => _query = val),
                    decoration: const InputDecoration(
                      hintText: 'Type to search pages, orders, or merchants...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('ESC to close', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text('No results matching "$_query"', style: const TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, index) {
                        final item = filtered[index];
                        return ListTile(
                          leading: Icon(item['icon'] as IconData, color: const Color(0xFFFF6D00)),
                          title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(item['category'] as String, style: const TextStyle(fontSize: 11)),
                          trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                          onTap: () {
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 190,
            child: _buildCategoryCard('Restaurant', '0', '₹ 0', Icons.restaurant, Colors.orange),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 190,
            child: _buildCategoryCard('Grocery', '0', '₹ 0', Icons.local_grocery_store, Colors.green),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 190,
            child: _buildCategoryCard('Pharmacy', '0', '₹ 0', Icons.local_pharmacy, Colors.blue),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 190,
            child: _buildCategoryCard('Pickup & Courier', '0', '₹ 0', Icons.local_shipping, Colors.amber),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 190,
            child: _buildCategoryCard('Electronics', '0', '₹ 0', Icons.electrical_services, Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String orders, String revenue, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(orders, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    ),
                    const Text('Orders', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(revenue, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    ),
                    const Text('Revenue', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'View Details →',
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
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
                Expanded(
                  child: Text(type, style: const TextStyle(color: Color(0xFF1E293B)), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(customer, style: const TextStyle(color: Color(0xFF1E293B)), overflow: TextOverflow.ellipsis)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const CircleAvatar(radius: 12, backgroundColor: Color(0xFFE2E8F0), child: Icon(Icons.person, size: 16, color: Colors.grey)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(partner, style: const TextStyle(color: Color(0xFF1E293B)), overflow: TextOverflow.ellipsis),
                ),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                Text('Restaurants', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFFF6D00))),
                SizedBox(width: 12),
                Text('Grocery Stores', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                SizedBox(width: 12),
                Text('Pharmacies', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
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
