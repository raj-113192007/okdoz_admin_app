import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart'; // For TopHeader
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  String _selectedStatus = 'All';
  final List<String> _statuses = ['All', 'New', 'Preparing', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('orders');
    if (_selectedStatus != 'All') {
      query = query.where('status', isEqualTo: _selectedStatus);
    }

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
                    padding: const EdgeInsets.all(20.0),
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _statuses.map((status) {
                              final isSelected = _selectedStatus == status;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(status),
                                  selected: isSelected,
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedStatus = status;
                                      });
                                    }
                                  },
                                  selectedColor: const Color(0xFFFF6D00).withValues(alpha: 0.15),
                                  checkmarkColor: const Color(0xFFFF6D00),
                                  labelStyle: TextStyle(
                                    color: isSelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
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
                                    stream: query.snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                                      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                                      
                                      final docs = snapshot.data?.docs ?? [];
                                      if (docs.isEmpty) return const Center(child: Text('No orders found under this status.'));

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
                                          } else if (status == 'On the way') {
                                            statusColor = Colors.amber.shade700;
                                          } else if (status == 'Delivered') {
                                            statusColor = Colors.green;
                                          } else if (status == 'Cancelled') {
                                            statusColor = Colors.red;
                                          }

                                          final amount = (data['totalAmount'] ?? data['amount'] ?? 0).toDouble();

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text('#${doc.id.substring(0, doc.id.length > 8 ? 8 : doc.id.length)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        data['orderType'] == 'Courier' ? Icons.local_shipping : Icons.restaurant,
                                                        size: 16,
                                                        color: const Color(0xFFFF6D00),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(data['orderType'] ?? 'Food Delivery', style: const TextStyle(color: Color(0xFF1E293B))),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(data['customerName'] ?? 'John Doe', style: const TextStyle(color: Color(0xFF64748B))),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(data['merchantName'] ?? 'Burger King', style: const TextStyle(color: Color(0xFF64748B))),
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
                                                        border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                                                      ),
                                                      child: Text(
                                                        status,
                                                        style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
                                                    onPressed: () {
                                                      _showOrderDetailsDialog(context, doc.id, data, status, amount);
                                                    },
                                                  ),
                                                ),
                                              ],
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

  void _showOrderDetailsDialog(BuildContext context, String orderId, Map<String, dynamic> data, String currentStatus, double amount) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Order Details (#${orderId.substring(0, orderId.length > 8 ? 8 : orderId.length)})'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${data['customerName'] ?? 'John Doe'}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Merchant: ${data['merchantName'] ?? 'Burger King'}'),
              const SizedBox(height: 8),
              Text('Type: ${data['orderType'] ?? 'Food Delivery'}'),
              const SizedBox(height: 8),
              Text('Amount: ₹${amount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Current Status: $currentStatus', style: const TextStyle(color: Color(0xFFFF6D00), fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
