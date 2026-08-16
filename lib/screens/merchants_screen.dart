import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/dashboard_widgets.dart'; // For TopHeader
import 'merchant_detail_screen.dart';

class MerchantsScreen extends StatefulWidget {
  const MerchantsScreen({super.key});

  @override
  State<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
  late Stream<QuerySnapshot> _merchantsStream;

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Restaurant', 'Grocery', 'Pharmacy', 'Courier', 'Electronics Service', 'RO Service'];

  @override
  void initState() {
    super.initState();
    _updateStream();
  }

  void _updateStream() {
    var query = FirebaseFirestore.instance
        .collection('vendors')
        .where('status', isEqualTo: 'pending_approval');

    if (_selectedFilter != 'All') {
      query = query.where('category', isEqualTo: _selectedFilter);
    }

    setState(() {
      _merchantsStream = query.snapshots();
    });
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Grocery': return Colors.green;
      case 'Pharmacy': return Colors.blue;
      case 'Courier': 
      case 'Pickup & Courier': return Colors.amber;
      case 'Electronics Service': return Colors.grey;
      case 'RO Service': return Colors.lightBlue;
      case 'Restaurant': return const Color(0xFFFF6D00);
      default: return const Color(0xFFFF6D00); // All or any other
    }
  }

  Future<void> _approveRestaurant(BuildContext context, String docId, String restaurantName) async {
    try {
      await FirebaseFirestore.instance.collection('vendors').doc(docId).update({
        'status': 'active',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$restaurantName is now approved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error approving: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pending Merchant Approvals',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _filters.map((filter) {
                              final isSelected = _selectedFilter == filter;
                              final filterColor = _getColorForCategory(filter);

                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(filter),
                                  selected: isSelected,
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      _selectedFilter = filter;
                                      _updateStream();
                                    }
                                  },
                                  selectedColor: filterColor.withValues(alpha: 0.2),
                                  checkmarkColor: filterColor,
                                  labelStyle: TextStyle(
                                    color: isSelected ? filterColor : const Color(0xFF64748B),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: constraints.maxWidth > 900 ? constraints.maxWidth : 900,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  child: Row(
                                    children: const [
                                      Expanded(flex: 2, child: Text('Merchant Name', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                                      Expanded(flex: 2, child: Text('Sector', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                                      Expanded(flex: 2, child: Text('Email', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                                      Expanded(flex: 1, child: Text('Status', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                                      Expanded(flex: 1, child: Text('Action', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: _merchantsStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      }
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6D00)));
                                      }

                                      final docs = snapshot.data?.docs ?? [];
                                      if (docs.isEmpty) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                                              SizedBox(height: 16),
                                              Text(
                                                'All Caught Up!',
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'No pending merchant approvals at this time.',
                                                style: TextStyle(color: Color(0xFF64748B)),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return ListView.separated(
                                        itemCount: docs.length,
                                        separatorBuilder: (context, index) => const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final data = docs[index].data() as Map<String, dynamic>;
                                          final docId = docs[index].id;
                                          final name = data['name'] ?? 'Unknown Name';
                                          final category = data['category'] ?? 'Unknown';
                                          final email = data['email'] ?? 'N/A';
                                          final status = data['status'] ?? 'pending_approval';

                                          final rowColor = _getColorForCategory(category);

                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MerchantDetailScreen(
                                                    docId: docId,
                                                    merchantData: data,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                              child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 16,
                                                        backgroundColor: rowColor.withValues(alpha: 0.1),
                                                        child: Icon(Icons.storefront, size: 16, color: rowColor),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(category, style: const TextStyle(color: Color(0xFF1E293B))),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(email, style: const TextStyle(color: Color(0xFF64748B))),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: rowColor.withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(color: rowColor.withValues(alpha: 0.5)),
                                                      ),
                                                      child: Text(
                                                        'Pending',
                                                        style: TextStyle(color: rowColor, fontSize: 12, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: ElevatedButton(
                                                      onPressed: () => _approveRestaurant(context, docId, name),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.green,
                                                        foregroundColor: Colors.white,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      ),
                                                      child: const Text('Approve'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                        );
                      },
                    ),
                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
