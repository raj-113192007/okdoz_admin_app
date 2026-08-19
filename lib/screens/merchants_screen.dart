import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/dashboard_widgets.dart'; // For TopHeader
import 'merchant_detail_screen.dart';

class MerchantsScreen extends StatefulWidget {
  final String? initialCategory;
  const MerchantsScreen({super.key, this.initialCategory});

  @override
  State<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
  late Stream<QuerySnapshot> _merchantsStream;

  late String _selectedFilter;
  final List<String> _filters = [
    'All',
    'Restaurant',
    'Grocery',
    'Pharmacy',
    'Courier',
    'Electronics Service',
    'RO Service',
    'Delivery Partners',
    'Technicians',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialCategory ?? 'All';
    _updateStream();
  }

  @override
  void didUpdateWidget(covariant MerchantsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory && widget.initialCategory != null) {
      _selectedFilter = widget.initialCategory!;
      _updateStream();
    }
  }

  void _updateStream() {
    Query query;
    if (_selectedFilter == 'Delivery Partners') {
      query = FirebaseFirestore.instance
          .collection('delivery_partners')
          .where('status', isEqualTo: 'pending_approval');
    } else if (_selectedFilter == 'Technicians') {
      query = FirebaseFirestore.instance
          .collection('technicians')
          .where('status', isEqualTo: 'pending_approval');
    } else {
      query = FirebaseFirestore.instance
          .collection('vendors')
          .where('status', isEqualTo: 'pending_approval');

      if (_selectedFilter != 'All') {
        query = query.where('category', isEqualTo: _selectedFilter);
      }
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
      case 'Delivery Partners': return Colors.purple;
      case 'Technicians': return Colors.teal;
      default: return const Color(0xFFFF6D00); // All or any other
    }
  }

  Future<void> _approveItem(BuildContext context, String docId, String itemName, String category) async {
    try {
      String collection = 'vendors';
      if (category == 'Delivery Partners') {
        collection = 'delivery_partners';
      } else if (category == 'Technicians') {
        collection = 'technicians';
      }

      await FirebaseFirestore.instance.collection(collection).doc(docId).update({
        'status': 'active',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$itemName is now approved!'),
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

  void _showQuickPreviewDrawer(
    BuildContext context,
    String docId,
    Map<String, dynamic> data,
    String category,
    Color rowColor,
  ) {
    final name = data['name'] ?? 'Unknown Name';
    final email = data['email'] ?? 'N/A';
    final phone = data['phone'] ?? data['phoneNumber'] ?? 'N/A';
    final address = data['address'] ?? 'Address not specified';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'QuickPreview',
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
                width: 400,
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
                        const Text(
                          'Merchant Preview',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: rowColor.withValues(alpha: 0.1),
                          child: Icon(Icons.storefront, color: rowColor, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: rowColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(category, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: rowColor)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _detailItem('Email Address', email, Icons.email_outlined),
                    const SizedBox(height: 14),
                    _detailItem('Phone Number', phone, Icons.phone_outlined),
                    const SizedBox(height: 14),
                    _detailItem('Location', address, Icons.location_on_outlined),
                    const SizedBox(height: 14),
                    _detailItem('Status', 'Pending Approval', Icons.hourglass_top_outlined),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
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
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Full Profile'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _approveItem(context, docId, name, category);
                            },
                            icon: const Icon(Icons.check_circle, size: 18),
                            label: const Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
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

  Widget _detailItem(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
            ],
          ),
        ),
      ],
    );
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

                                          final rowColor = _getColorForCategory(category);

                                          return InkWell(
                                            onTap: () {
                                              _showQuickPreviewDrawer(context, docId, data, category, rowColor);
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
                                                      onPressed: () => _approveItem(context, docId, name, category),
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
