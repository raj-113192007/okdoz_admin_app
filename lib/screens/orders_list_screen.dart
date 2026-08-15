import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart'; // For TopHeader
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

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
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        const Text(
                          'Order Management',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildFilterBtn('Status: All'),
                            _buildFilterBtn('Type: All'),
                            _buildFilterBtn('Date: Today'),
                          ],
                        )
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
                            width: constraints.maxWidth > 1000 ? constraints.maxWidth : 1000,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  child: Row(
                                    children: const [
                                      Expanded(flex: 2, child: Text('Order ID', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text('Type', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text('Customer', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text('Merchant', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text('Status', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 1, child: Text('Amount', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 1, child: Text('Action', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('orders').orderBy('created_at', descending: true).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                                      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                                      
                                      final docs = snapshot.data?.docs ?? [];
                                      if (docs.isEmpty) return const Center(child: Text('No orders found.'));

                                      return ListView.separated(
                                        itemCount: docs.length,
                                        separatorBuilder: (context, index) => const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final doc = docs[index];
                                          final data = doc.data() as Map<String, dynamic>;
                                          
                                          // Determine status color
                                          Color statusColor = Colors.grey;
                                          String status = data['status'] ?? 'New';
                                          if (status == 'New') {
                                            statusColor = Colors.blue;
                                          } else if (status == 'Preparing') {
                                            statusColor = Colors.orange;
                                          } else if (status == 'Ready') {
                                            statusColor = Colors.amber;
                                          } else if (status == 'picked_up') {
                                            statusColor = Colors.purple;
                                          } else if (status == 'Delivered') {
                                            statusColor = Colors.green;
                                          }

                                          // Calculate amount safely
                                          double amount = 0;
                                          if (data['total_amount'] != null) {
                                            amount = (data['total_amount'] is int) ? (data['total_amount'] as int).toDouble() : data['total_amount'];
                                          }

                                          return _AnimatedOrderRow(
                                            id: doc.id.substring(0, 8).toUpperCase(),
                                            type: 'Restaurant', // Hardcoded type for now based on items
                                            icon: Icons.restaurant,
                                            iconColor: Colors.orange,
                                            customer: data['user_id'] ?? 'Unknown',
                                            merchant: data['vendor_id'] ?? 'Unknown',
                                            status: status.toUpperCase(),
                                            statusColor: statusColor,
                                            amount: '₹ ${amount.toStringAsFixed(2)}',
                                            onTapDetails: () => _showOrderDetailsDialog(context, doc),
                                          );
                                        },
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
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

  Widget _buildFilterBtn(String title) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B), size: 18),
          ],
        ),
      ),
    );
  }
}

void _showOrderDetailsDialog(BuildContext context, DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  final items = data['items'] as List<dynamic>? ?? [];
  
  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    return DateFormat('dd MMM, yyyy - hh:mm a').format(timestamp.toDate());
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Order Details #${doc.id.substring(0, 8).toUpperCase()}'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Store/Vendor: ${data['vendor_id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Customer User ID: ${data['user_id']}'),
                const Divider(),
                const Text('Timings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Placed At: ${formatDate(data['created_at'])}'),
                Text('Picked Up At: ${formatDate(data['picked_up_at'])}'),
                Text('Delivered At: ${formatDate(data['delivered_at'])}'),
                const Divider(),
                const Text('Items Ordered', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                ...items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item['qty'] ?? 1}x ${item['name'] ?? 'Unknown Item'}'),
                        Text('₹${item['price'] ?? 0}'),
                      ],
                    ),
                  );
                }),
                const Divider(),
                const Text('Feedback & Complaints', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text('Product/Vendor Rating: ${data['product_rating'] != null ? '${data['product_rating']} ⭐' : 'Not Rated'}'),
                Text('Delivery Rating: ${data['delivery_rating'] != null ? '${data['delivery_rating']} ⭐' : 'Not Rated'}'),
                const SizedBox(height: 4),
                Text(
                  'Complaints: ${data['complaint'] ?? 'No complaints'}',
                  style: TextStyle(color: data['complaint'] != null ? Colors.red : Colors.green, fontWeight: FontWeight.w500),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Total: ₹${data['total_amount'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
        ],
      );
    },
  );
}

class _AnimatedOrderRow extends StatefulWidget {
  final String id, type, customer, merchant, status, amount;
  final IconData icon;
  final Color iconColor, statusColor;
  final VoidCallback onTapDetails;

  const _AnimatedOrderRow({
    required this.id, required this.type, required this.icon, required this.iconColor,
    required this.customer, required this.merchant, required this.status, 
    required this.statusColor, required this.amount, required this.onTapDetails
  });

  @override
  State<_AnimatedOrderRow> createState() => _AnimatedOrderRowState();
}

class _AnimatedOrderRowState extends State<_AnimatedOrderRow> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        color: _isHovering ? const Color(0xFFF8FAFC) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(widget.id, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(widget.icon, size: 16, color: widget.iconColor),
                  const SizedBox(width: 8),
                  Text(widget.type, style: const TextStyle(color: Color(0xFF1E293B))),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text(widget.customer, style: const TextStyle(color: Color(0xFF1E293B)))),
            Expanded(flex: 2, child: Text(widget.merchant, style: const TextStyle(color: Color(0xFF1E293B)))),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(color: widget.statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Expanded(flex: 1, child: Text(widget.amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.receipt_long, color: Color(0xFF94A3B8)),
                onPressed: widget.onTapDetails,
                splashRadius: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
