import 'package:flutter/material.dart';
import '../widgets/sidebar_widget.dart';
import 'dashboard_content.dart';
import 'merchants_screen.dart'; // Existing Pending Approval screen
import 'ecommerce_merchants_screen.dart';
import 'admin_courier_orders_screen.dart';
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

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0: return const DashboardContent(key: ValueKey(0));
      case 1: return const MerchantsScreen(key: ValueKey(1)); // Restaurant Approvals
      case 2: return const EcommerceMerchantsScreen(key: ValueKey(2), title: 'Grocery', icon: Icons.local_grocery_store, color: Colors.green);
      case 3: return const EcommerceMerchantsScreen(key: ValueKey(3), title: 'Pharmacy', icon: Icons.local_pharmacy, color: Colors.blue);
      case 4: return const AdminCourierOrdersScreen(key: ValueKey(4));
      case 5: return const EcommerceMerchantsScreen(key: ValueKey(5), title: 'Electronics Service', icon: Icons.electrical_services, color: Colors.grey);
      case 6: return const EcommerceMerchantsScreen(key: ValueKey(6), title: 'RO Service', icon: Icons.water_drop, color: Colors.lightBlue);
      case 7: return const OrdersListScreen(key: ValueKey(7));
      case 8: return const UsersListScreen(key: ValueKey(8), title: 'Delivery Partners', icon: Icons.two_wheeler, collectionName: 'delivery_partners');
      case 9: return const UsersListScreen(key: ValueKey(9), title: 'Customers', icon: Icons.people, collectionName: 'users');
      case 10: return const EcommerceMerchantsScreen(key: ValueKey(10), title: 'All Merchants', icon: Icons.store_mall_directory, color: Colors.orange);
      case 11: return const UsersListScreen(key: ValueKey(11), title: 'Technicians', icon: Icons.build, collectionName: 'technicians');
      case 12: return const FinanceScreen(key: ValueKey(12));
      case 13: return const FinanceScreen(key: ValueKey(13)); // Coupons mapping to finance layout for now
      case 14: return const FinanceScreen(key: ValueKey(14)); // Promotions
      case 15: return const FinanceScreen(key: ValueKey(15)); // Reports
      case 16: return const UsersListScreen(key: ValueKey(16), title: 'Reviews & Feedback', icon: Icons.star, collectionName: 'feedback'); // Feedback mapped to users list for now
      case 17: return const SettingsScreen(key: ValueKey(17)); // Support mapped to settings
      case 18: return const SettingsScreen(key: ValueKey(18)); // Settings
      default: return PlaceholderScreen(title: 'Screen $index', key: ValueKey(index));
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
                19, // Total number of screens (0 to 18)
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
