import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Icon(Icons.delivery_dining, color: Color(0xFFFF6D00), size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'okdoz',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6D00),
                      ),
                    ),
                    Text(
                      'Super Admin Panel',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Scrollable Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _NavItem(index: 0, icon: Icons.dashboard_outlined, title: 'Dashboard', selectedIndex: selectedIndex, onTap: () => onItemSelected(0)),
                _NavItem(index: 1, icon: Icons.storefront_outlined, title: 'Restaurant', selectedIndex: selectedIndex, onTap: () => onItemSelected(1)),
                _NavItem(index: 2, icon: Icons.local_grocery_store_outlined, title: 'Grocery', selectedIndex: selectedIndex, onTap: () => onItemSelected(2)),
                _NavItem(index: 3, icon: Icons.local_pharmacy_outlined, title: 'Pharmacy', selectedIndex: selectedIndex, onTap: () => onItemSelected(3)),
                _NavItem(index: 4, icon: Icons.local_shipping_outlined, title: 'Pickup & Courier', selectedIndex: selectedIndex, onTap: () => onItemSelected(4)),
                _NavItem(index: 5, icon: Icons.electrical_services_outlined, title: 'Electronics Service', selectedIndex: selectedIndex, onTap: () => onItemSelected(5)),
                _NavItem(index: 6, icon: Icons.water_drop_outlined, title: 'RO Service', selectedIndex: selectedIndex, onTap: () => onItemSelected(6)),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Divider(),
                ),
                
                _NavItem(index: 7, icon: Icons.receipt_long_outlined, title: 'Orders', selectedIndex: selectedIndex, onTap: () => onItemSelected(7)),
                _NavItem(index: 8, icon: Icons.two_wheeler_outlined, title: 'Delivery Partners', selectedIndex: selectedIndex, onTap: () => onItemSelected(8)),
                _NavItem(index: 9, icon: Icons.people_outline, title: 'Customers', selectedIndex: selectedIndex, onTap: () => onItemSelected(9)),
                _NavItem(index: 10, icon: Icons.store_mall_directory_outlined, title: 'Merchants (All)', selectedIndex: selectedIndex, onTap: () => onItemSelected(10)),
                _NavItem(index: 11, icon: Icons.build_circle_outlined, title: 'Technicians', selectedIndex: selectedIndex, onTap: () => onItemSelected(11)),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Divider(),
                ),

                _NavItem(index: 12, icon: Icons.account_balance_wallet_outlined, title: 'Finance', selectedIndex: selectedIndex, onTap: () => onItemSelected(12)),
                _NavItem(index: 13, icon: Icons.local_offer_outlined, title: 'Coupons', selectedIndex: selectedIndex, onTap: () => onItemSelected(13)),
                _NavItem(index: 14, icon: Icons.campaign_outlined, title: 'Promotions', selectedIndex: selectedIndex, onTap: () => onItemSelected(14)),
                _NavItem(index: 15, icon: Icons.bar_chart_outlined, title: 'Reports & Analytics', selectedIndex: selectedIndex, onTap: () => onItemSelected(15)),
                _NavItem(index: 16, icon: Icons.star_border_outlined, title: 'Reviews & Feedback', selectedIndex: selectedIndex, onTap: () => onItemSelected(16)),
                _NavItem(index: 17, icon: Icons.support_agent_outlined, title: 'Support Tickets', selectedIndex: selectedIndex, onTap: () => onItemSelected(17)),
                _NavItem(index: 18, icon: Icons.settings_outlined, title: 'Settings', selectedIndex: selectedIndex, onTap: () => onItemSelected(18)),
              ],
            ),
          ),

          // Logout Button
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {},
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.grey),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final int index;
  final IconData icon;
  final String title;
  final int selectedIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.title,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedIndex == widget.index;
    
    return MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFFFFF0E6) 
                : _isHovering 
                    ? Colors.grey.shade50 
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF6D00).withValues(alpha: 0.3) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Icon(
                  widget.icon,
                  key: ValueKey<bool>(isSelected),
                  size: 20,
                  color: isSelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 16),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B),
                ),
                child: Text(widget.title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
