import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/dashboard_widgets.dart'; // For TopHeader

class EcommerceMerchantsScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const EcommerceMerchantsScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  State<EcommerceMerchantsScreen> createState() => _EcommerceMerchantsScreenState();
}

class _EcommerceMerchantsScreenState extends State<EcommerceMerchantsScreen> {
  late Stream<QuerySnapshot> _activeMerchantsStream;

  @override
  void initState() {
    super.initState();
    String queryCategory = widget.title;
    if (widget.title == 'All Merchants') {
      _activeMerchantsStream = FirebaseFirestore.instance
          .collection('vendors')
          .where('status', isEqualTo: 'active')
          .snapshots();
    } else {
      _activeMerchantsStream = FirebaseFirestore.instance
          .collection('vendors')
          .where('status', isEqualTo: 'active')
          .where('category', isEqualTo: queryCategory)
          .snapshots();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(widget.icon, color: widget.color, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title.endsWith('Merchants') ? widget.title : '${widget.title} Merchants',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            Text(
                              'Manage all ${widget.title.toLowerCase().replaceAll(' merchants', '')} partners and their performance.',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Add Merchant'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Grid View of Merchants
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final width = MediaQuery.of(context).size.width;
                      int columns = 3;
                      if (width < 600) {
                        columns = 1;
                      } else if (width < 1100) {
                        columns = 2;
                      }
                      
                      return StreamBuilder<QuerySnapshot>(
                        stream: _activeMerchantsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          final docs = snapshot.data?.docs ?? [];
                          
                          if (docs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(widget.icon, size: 64, color: Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No active ${widget.title.toLowerCase().replaceAll(' merchants', '')} merchants found.',
                                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }

                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              mainAxisExtent: 220,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              // Format data mapping to match UI requirements
                              final merchantData = {
                                'name': data['name'] ?? 'Unknown',
                                'status': data['status'] == 'active' ? 'Active' : 'Inactive',
                                'orders': '0', // Placeholder
                                'revenue': '₹ 0', // Placeholder
                                'rating': 5.0, // Placeholder
                              };
                              return _MerchantCard(
                                merchant: merchantData,
                                color: widget.color,
                                icon: widget.icon,
                              );
                            },
                          );
                        }
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MerchantCard extends StatefulWidget {
  final Map<String, dynamic> merchant;
  final Color color;
  final IconData icon;

  const _MerchantCard({required this.merchant, required this.color, required this.icon});

  @override
  State<_MerchantCard> createState() => _MerchantCardState();
}

class _MerchantCardState extends State<_MerchantCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.merchant['status'] == 'Active' ? Colors.green : (widget.merchant['status'] == 'Inactive' ? Colors.red : Colors.orange);
    
    return MouseRegion(
      opaque: false, // Don't block underneath
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isHovering ? widget.color.withValues(alpha: 0.3) : Colors.grey.shade200),
          boxShadow: _isHovering 
            ? [BoxShadow(color: widget.color.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))] 
            : [],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: widget.color.withValues(alpha: 0.1),
                  child: Icon(widget.icon, color: widget.color, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.merchant['status'],
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.merchant['name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${widget.merchant['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              ],
            ),
            const Spacer(),
            const Divider(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Orders', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    Text(widget.merchant['orders'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Revenue', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    Text(widget.merchant['revenue'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.color)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
