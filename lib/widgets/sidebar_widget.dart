import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SidebarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
    required this.onToggleCollapse,
  });

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool _isOverviewExpanded = true;
  bool _isApprovalsExpanded = true;
  bool _isManagementExpanded = true;
  bool _isFinanceExpanded = false;
  bool _isSystemExpanded = false;

  bool get _isApprovalSelected => widget.selectedIndex >= 1 && widget.selectedIndex <= 9;
  bool get _isManagementSelected => widget.selectedIndex >= 10 && widget.selectedIndex <= 14;
  bool get _isFinanceSelected => widget.selectedIndex >= 15 && widget.selectedIndex <= 18;
  bool get _isSystemSelected => widget.selectedIndex >= 19 && widget.selectedIndex <= 21;

  @override
  Widget build(BuildContext context) {
    final width = widget.isCollapsed ? 72.0 : 260.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: width,
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vendors')
            .where('status', isEqualTo: 'pending_approval')
            .snapshots(),
        builder: (context, snapshot) {
          final pendingCount = snapshot.data?.docs.length ?? 0;

          return Column(
            children: [
              // Logo Area + Collapse Toggle Button
              Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: widget.isCollapsed ? 12 : 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: widget.isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!widget.isCollapsed)
                      Row(
                        children: [
                          const Icon(Icons.delivery_dining, color: Color(0xFFFF6D00), size: 28),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'okdoz',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF6D00),
                                ),
                              ),
                              Text(
                                'Super Admin',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      const Icon(Icons.delivery_dining, color: Color(0xFFFF6D00), size: 28),

                    IconButton(
                      icon: Icon(
                        widget.isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                        color: const Color(0xFF64748B),
                        size: 20,
                      ),
                      onPressed: widget.onToggleCollapse,
                      tooltip: widget.isCollapsed ? 'Expand Sidebar' : 'Collapse Sidebar',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Scrollable Menu
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    // --- OVERVIEW SECTION ---
                    if (!widget.isCollapsed)
                      _SectionGroupHeader(
                        title: 'Overview',
                        isExpanded: _isOverviewExpanded,
                        onToggle: () => setState(() => _isOverviewExpanded = !_isOverviewExpanded),
                      ),
                    if (widget.isCollapsed || _isOverviewExpanded)
                      _NavItem(
                        index: 0,
                        icon: Icons.dashboard_outlined,
                        title: 'Dashboard',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(0),
                      ),

                    const SizedBox(height: 6),

                    // --- APPROVALS SECTION ---
                    if (!widget.isCollapsed)
                      _SectionGroupHeader(
                        title: 'Approvals',
                        isExpanded: _isApprovalsExpanded,
                        isAnySelected: _isApprovalSelected,
                        badgeCount: pendingCount,
                        badgeColor: Colors.red,
                        onToggle: () => setState(() => _isApprovalsExpanded = !_isApprovalsExpanded),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Divider(height: 1),
                      ),

                    if (widget.isCollapsed || _isApprovalsExpanded) ...[
                      _NavItem(
                        index: 1,
                        icon: Icons.approval_outlined,
                        title: 'All Approvals',
                        isSubItem: !widget.isCollapsed,
                        badgeCount: pendingCount,
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(1),
                      ),
                      _NavItem(
                        index: 2,
                        icon: Icons.storefront_outlined,
                        title: 'Restaurant',
                        isSubItem: !widget.isCollapsed,
                        badgeColor: const Color(0xFFFF6D00),
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(2),
                      ),
                      _NavItem(
                        index: 3,
                        icon: Icons.local_grocery_store_outlined,
                        title: 'Grocery',
                        isSubItem: !widget.isCollapsed,
                        badgeColor: Colors.green,
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(3),
                      ),
                      _NavItem(
                        index: 4,
                        icon: Icons.local_pharmacy_outlined,
                        title: 'Pharmacy',
                        isSubItem: !widget.isCollapsed,
                        badgeColor: Colors.blue,
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(4),
                      ),
                      _NavItem(
                        index: 5,
                        icon: Icons.local_shipping_outlined,
                        title: 'Pickup & Courier',
                        isSubItem: !widget.isCollapsed,
                        badgeColor: Colors.amber,
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(5),
                      ),
                      _NavItem(
                        index: 6,
                        icon: Icons.electrical_services_outlined,
                        title: 'Electronics Service',
                        isSubItem: !widget.isCollapsed,
                        badgeColor: Colors.grey,
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(6),
                      ),
                      _NavItem(
                        index: 7,
                        icon: Icons.water_drop_outlined,
                        title: 'RO Service',
                        isSubItem: !widget.isCollapsed,
                        badgeColor: Colors.lightBlue,
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(7),
                      ),
                      _NavItem(
                        index: 8,
                        icon: Icons.two_wheeler_outlined,
                        title: 'Delivery Partners',
                        isSubItem: !widget.isCollapsed,
                        badgeColor: Colors.purple,
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(8),
                      ),
                      _NavItem(
                        index: 9,
                        icon: Icons.build_circle_outlined,
                        title: 'Technicians',
                        isSubItem: !widget.isCollapsed,
                        badgeColor: Colors.teal,
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(9),
                      ),
                    ],

                    const SizedBox(height: 6),

                    // --- MANAGEMENT SECTION ---
                    if (!widget.isCollapsed)
                      _SectionGroupHeader(
                        title: 'Management',
                        isExpanded: _isManagementExpanded,
                        isAnySelected: _isManagementSelected,
                        onToggle: () => setState(() => _isManagementExpanded = !_isManagementExpanded),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Divider(height: 1),
                      ),

                    if (widget.isCollapsed || _isManagementExpanded) ...[
                      _NavItem(
                        index: 10,
                        icon: Icons.receipt_long_outlined,
                        title: 'Orders',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(10),
                      ),
                      _NavItem(
                        index: 11,
                        icon: Icons.store_mall_directory_outlined,
                        title: 'Merchants (All)',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(11),
                      ),
                      _NavItem(
                        index: 12,
                        icon: Icons.people_outline,
                        title: 'Customers',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(12),
                      ),
                      _NavItem(
                        index: 13,
                        icon: Icons.badge_outlined,
                        title: 'Delivery Partners (All)',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(13),
                      ),
                      _NavItem(
                        index: 14,
                        icon: Icons.engineering_outlined,
                        title: 'Technicians (All)',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(14),
                      ),
                    ],

                    const SizedBox(height: 6),

                    // --- FINANCE & MARKETING SECTION ---
                    if (!widget.isCollapsed)
                      _SectionGroupHeader(
                        title: 'Finance & Growth',
                        isExpanded: _isFinanceExpanded,
                        isAnySelected: _isFinanceSelected,
                        onToggle: () => setState(() => _isFinanceExpanded = !_isFinanceExpanded),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Divider(height: 1),
                      ),

                    if (widget.isCollapsed || _isFinanceExpanded) ...[
                      _NavItem(
                        index: 15,
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Finance',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(15),
                      ),
                      _NavItem(
                        index: 16,
                        icon: Icons.local_offer_outlined,
                        title: 'Coupons',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(16),
                      ),
                      _NavItem(
                        index: 17,
                        icon: Icons.campaign_outlined,
                        title: 'Promotions',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(17),
                      ),
                      _NavItem(
                        index: 18,
                        icon: Icons.bar_chart_outlined,
                        title: 'Reports & Analytics',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(18),
                      ),
                    ],

                    const SizedBox(height: 6),

                    // --- SYSTEM SECTION ---
                    if (!widget.isCollapsed)
                      _SectionGroupHeader(
                        title: 'System',
                        isExpanded: _isSystemExpanded,
                        isAnySelected: _isSystemSelected,
                        onToggle: () => setState(() => _isSystemExpanded = !_isSystemExpanded),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Divider(height: 1),
                      ),

                    if (widget.isCollapsed || _isSystemExpanded) ...[
                      _NavItem(
                        index: 19,
                        icon: Icons.star_border_outlined,
                        title: 'Reviews & Feedback',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(19),
                      ),
                      _NavItem(
                        index: 20,
                        icon: Icons.support_agent_outlined,
                        title: 'Support Tickets',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(20),
                      ),
                      _NavItem(
                        index: 21,
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        isCollapsed: widget.isCollapsed,
                        selectedIndex: widget.selectedIndex,
                        onTap: () => widget.onItemSelected(21),
                      ),
                    ],
                  ],
                ),
              ),

              // Logout Button
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: widget.isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.logout, color: Colors.grey, size: 20),
                      if (!widget.isCollapsed) ...[
                        const SizedBox(width: 12),
                        const Text(
                          'Logout',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionGroupHeader extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final bool isAnySelected;
  final int badgeCount;
  final Color? badgeColor;
  final VoidCallback onToggle;

  const _SectionGroupHeader({
    required this.title,
    required this.isExpanded,
    this.isAnySelected = false,
    this.badgeCount = 0,
    this.badgeColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isAnySelected ? const Color(0xFFFF6D00).withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isAnySelected ? const Color(0xFFFF6D00).withValues(alpha: 0.2) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: isAnySelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B),
                  ),
                ),
              ),
              if (badgeCount > 0)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor ?? Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 16,
                color: isAnySelected ? const Color(0xFFFF6D00) : const Color(0xFF94A3B8),
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
  final int badgeCount;
  final bool isCollapsed;
  final int selectedIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.title,
    this.isSubItem = false,
    this.badgeColor,
    this.badgeCount = 0,
    required this.isCollapsed,
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
    
    final childWidget = MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(
            left: widget.isCollapsed ? 10 : (widget.isSubItem ? 24 : 14),
            right: widget.isCollapsed ? 10 : 14,
            top: 2,
            bottom: 2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? 0 : 12,
            vertical: widget.isSubItem ? 7 : 9,
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
            mainAxisAlignment: widget.isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              if (!widget.isCollapsed && widget.badgeColor != null)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: widget.badgeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              Icon(
                widget.icon,
                key: ValueKey<bool>(isSelected),
                size: widget.isSubItem ? 18 : 20,
                color: isSelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B),
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: widget.isSubItem ? 13 : 13.5,
                      fontFamily: 'Inter',
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? const Color(0xFFFF6D00) : const Color(0xFF475569),
                    ),
                  ),
                ),
                if (widget.badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.badgeCount}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );

    if (widget.isCollapsed) {
      return Tooltip(
        message: widget.title,
        preferBelow: false,
        child: childWidget,
      );
    }

    return childWidget;
  }
}
