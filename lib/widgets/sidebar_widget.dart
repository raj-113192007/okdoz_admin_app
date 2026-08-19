import 'package:flutter/material.dart';

class SidebarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool _isApprovalsExpanded = true;

  bool get _isApprovalSelected =>
      widget.selectedIndex >= 1 && widget.selectedIndex <= 9;

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
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                const _SectionHeader(title: 'Overview'),
                _NavItem(
                  index: 0,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(0),
                ),

                const SizedBox(height: 8),
                // APPROVALS SECTION HEADER / EXPANDABLE GROUP
                _ApprovalSectionHeader(
                  isExpanded: _isApprovalsExpanded,
                  isAnySelected: _isApprovalSelected,
                  onToggle: () {
                    setState(() {
                      _isApprovalsExpanded = !_isApprovalsExpanded;
                    });
                  },
                ),

                if (_isApprovalsExpanded) ...[
                  _NavItem(
                    index: 1,
                    icon: Icons.approval_outlined,
                    title: 'All Approvals',
                    isSubItem: true,
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(1),
                  ),
                  _NavItem(
                    index: 2,
                    icon: Icons.storefront_outlined,
                    title: 'Restaurant',
                    isSubItem: true,
                    badgeColor: const Color(0xFFFF6D00),
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(2),
                  ),
                  _NavItem(
                    index: 3,
                    icon: Icons.local_grocery_store_outlined,
                    title: 'Grocery',
                    isSubItem: true,
                    badgeColor: Colors.green,
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(3),
                  ),
                  _NavItem(
                    index: 4,
                    icon: Icons.local_pharmacy_outlined,
                    title: 'Pharmacy',
                    isSubItem: true,
                    badgeColor: Colors.blue,
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(4),
                  ),
                  _NavItem(
                    index: 5,
                    icon: Icons.local_shipping_outlined,
                    title: 'Pickup & Courier',
                    isSubItem: true,
                    badgeColor: Colors.amber,
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(5),
                  ),
                  _NavItem(
                    index: 6,
                    icon: Icons.electrical_services_outlined,
                    title: 'Electronics Service',
                    isSubItem: true,
                    badgeColor: Colors.grey,
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(6),
                  ),
                  _NavItem(
                    index: 7,
                    icon: Icons.water_drop_outlined,
                    title: 'RO Service',
                    isSubItem: true,
                    badgeColor: Colors.lightBlue,
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(7),
                  ),
                  _NavItem(
                    index: 8,
                    icon: Icons.two_wheeler_outlined,
                    title: 'Delivery Partners',
                    isSubItem: true,
                    badgeColor: Colors.purple,
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(8),
                  ),
                  _NavItem(
                    index: 9,
                    icon: Icons.build_circle_outlined,
                    title: 'Technicians',
                    isSubItem: true,
                    badgeColor: Colors.teal,
                    selectedIndex: widget.selectedIndex,
                    onTap: () => widget.onItemSelected(9),
                  ),
                ],

                const SizedBox(height: 8),
                const _SectionHeader(title: 'Management'),
                _NavItem(
                  index: 10,
                  icon: Icons.receipt_long_outlined,
                  title: 'Orders',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(10),
                ),
                _NavItem(
                  index: 11,
                  icon: Icons.store_mall_directory_outlined,
                  title: 'Merchants (All)',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(11),
                ),
                _NavItem(
                  index: 12,
                  icon: Icons.people_outline,
                  title: 'Customers',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(12),
                ),
                _NavItem(
                  index: 13,
                  icon: Icons.badge_outlined,
                  title: 'Delivery Partners (All)',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(13),
                ),
                _NavItem(
                  index: 14,
                  icon: Icons.engineering_outlined,
                  title: 'Technicians (All)',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(14),
                ),

                const SizedBox(height: 8),
                const _SectionHeader(title: 'Finance & Marketing'),
                _NavItem(
                  index: 15,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Finance',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(15),
                ),
                _NavItem(
                  index: 16,
                  icon: Icons.local_offer_outlined,
                  title: 'Coupons',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(16),
                ),
                _NavItem(
                  index: 17,
                  icon: Icons.campaign_outlined,
                  title: 'Promotions',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(17),
                ),
                _NavItem(
                  index: 18,
                  icon: Icons.bar_chart_outlined,
                  title: 'Reports & Analytics',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(18),
                ),

                const SizedBox(height: 8),
                const _SectionHeader(title: 'System'),
                _NavItem(
                  index: 19,
                  icon: Icons.star_border_outlined,
                  title: 'Reviews & Feedback',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(19),
                ),
                _NavItem(
                  index: 20,
                  icon: Icons.support_agent_outlined,
                  title: 'Support Tickets',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(20),
                ),
                _NavItem(
                  index: 21,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onItemSelected(21),
                ),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class _ApprovalSectionHeader extends StatelessWidget {
  final bool isExpanded;
  final bool isAnySelected;
  final VoidCallback onToggle;

  const _ApprovalSectionHeader({
    required this.isExpanded,
    required this.isAnySelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isAnySelected ? const Color(0xFFFF6D00).withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isAnySelected ? const Color(0xFFFF6D00).withValues(alpha: 0.2) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 20,
                color: isAnySelected ? const Color(0xFFFF6D00) : const Color(0xFF475569),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'APPROVALS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: isAnySelected ? const Color(0xFFFF6D00) : const Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6D00),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Categories',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 18,
                color: isAnySelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final int index;
  final IconData icon;
  final String title;
  final bool isSubItem;
  final Color? badgeColor;
  final int selectedIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.title,
    this.isSubItem = false,
    this.badgeColor,
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
          margin: EdgeInsets.only(
            left: widget.isSubItem ? 28 : 16,
            right: 16,
            top: 2,
            bottom: 2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: widget.isSubItem ? 8 : 10,
          ),
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
              if (widget.badgeColor != null)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: widget.badgeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Icon(
                  widget.icon,
                  key: ValueKey<bool>(isSelected),
                  size: widget.isSubItem ? 18 : 20,
                  color: isSelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: widget.isSubItem ? 13 : 14,
                    fontFamily: 'Inter',
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B),
                  ),
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
