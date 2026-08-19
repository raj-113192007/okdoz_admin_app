import 'package:flutter/material.dart';
import '../widgets/sidebar_widget.dart';
import 'dashboard_content.dart';
import 'merchants_screen.dart'; // Approvals Screen
import 'ecommerce_merchants_screen.dart';
import 'orders_list_screen.dart';
import 'users_list_screen.dart';
import 'finance_screen.dart';
import 'settings_screen.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  Widget _getScreenForIndex(int index) {
    switch (index) {
      // OVERVIEW
      case 0:
        return const DashboardContent(key: ValueKey(0));

      // APPROVALS SECTION (Category-wise)
      case 1:
        return const MerchantsScreen(key: ValueKey(1), initialCategory: 'All');
      case 2:
        return const MerchantsScreen(key: ValueKey(2), initialCategory: 'Restaurant');
      case 3:
        return const MerchantsScreen(key: ValueKey(3), initialCategory: 'Grocery');
      case 4:
        return const MerchantsScreen(key: ValueKey(4), initialCategory: 'Pharmacy');
      case 5:
        return const MerchantsScreen(key: ValueKey(5), initialCategory: 'Courier');
      case 6:
        return const MerchantsScreen(key: ValueKey(6), initialCategory: 'Electronics Service');
      case 7:
        return const MerchantsScreen(key: ValueKey(7), initialCategory: 'RO Service');
      case 8:
        return const MerchantsScreen(key: ValueKey(8), initialCategory: 'Delivery Partners');
      case 9:
        return const MerchantsScreen(key: ValueKey(9), initialCategory: 'Technicians');

      // MANAGEMENT SECTION
      case 10:
        return const OrdersListScreen(key: ValueKey(10));
      case 11:
        return const EcommerceMerchantsScreen(
          key: ValueKey(11),
          title: 'All Merchants',
          icon: Icons.store_mall_directory,
          color: Colors.orange,
        );
      case 12:
        return const UsersListScreen(
          key: ValueKey(12),
          title: 'Customers',
          icon: Icons.people,
          collectionName: 'users',
        );
      case 13:
        return const UsersListScreen(
          key: ValueKey(13),
          title: 'Delivery Partners (All)',
          icon: Icons.two_wheeler,
          collectionName: 'delivery_partners',
        );
      case 14:
        return const UsersListScreen(
          key: ValueKey(14),
          title: 'Technicians (All)',
          icon: Icons.build,
          collectionName: 'technicians',
        );

      // FINANCE & MARKETING SECTION
      case 15:
        return const FinanceScreen(key: ValueKey(15));
      case 16:
        return const FinanceScreen(key: ValueKey(16));
      case 17:
        return const FinanceScreen(key: ValueKey(17));
      case 18:
        return const FinanceScreen(key: ValueKey(18));

      // SYSTEM SECTION
      case 19:
        return const UsersListScreen(
          key: ValueKey(19),
          title: 'Reviews & Feedback',
          icon: Icons.star,
          collectionName: 'feedback',
        );
      case 20:
        return const SettingsScreen(key: ValueKey(20));
      case 21:
        return const SettingsScreen(key: ValueKey(21));

      default:
        return PlaceholderScreen(title: 'Screen $index', key: ValueKey(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 850;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: isMobile
          ? AppBar(
              title: const Text('okdoz Admin Panel', style: TextStyle(color: Colors.black, fontSize: 16)),
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 1,
            )
          : null,
      drawer: isMobile
          ? Drawer(
              child: SidebarWidget(
                selectedIndex: _selectedIndex,
                isCollapsed: false,
                onToggleCollapse: () {},
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.pop(context); // close drawer on selection
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Fixed Sidebar (Only on Web/Desktop)
          if (!isMobile)
            SidebarWidget(
              selectedIndex: _selectedIndex,
              isCollapsed: _isSidebarCollapsed,
              onToggleCollapse: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          
          // Main Content Area with IndexedStack for fast, stable switching
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: List.generate(
                22, // Total number of screens (0 to 21)
                (index) => _getScreenForIndex(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '$title under construction',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
