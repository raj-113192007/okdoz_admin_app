import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart'; // For TopHeader
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  String _orderType = 'Courier Parcels'; // 'Courier Parcels' or 'Store Orders'
  String _selectedStatus = 'All';

  final List<String> _courierStatuses = [
    'All',
    'pending_price',
    'pending_payment',
    'assigned',
    'picked_up',
    'delivered',
    'cancelled',
  ];

  final List<String> _storeStatuses = [
    'All',
    'New',
    'Preparing',
    'Delivered',
    'Cancelled',
  ];

  DateTime? _parseDate(dynamic val) {
    if (val == null) return null;
    if (val is Timestamp) return val.toDate();
    if (val is int) {
      if (val > 1000000000000) {
        return DateTime.fromMillisecondsSinceEpoch(val);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(val * 1000);
      }
    }
    if (val is String) {
      try {
        return DateTime.parse(val);
      } catch (_) {}
    }
    return null;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'pending_price':
        return Colors.orange;
      case 'preparing':
      case 'pending_payment':
        return Colors.amber.shade800;
      case 'assigned':
      case 'on the way':
      case 'picked_up':
        return Colors.blue;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending_price':
        return 'Pending Price';
      case 'pending_payment':
        return 'Payment Pending';
      case 'assigned':
        return 'Agent Assigned';
      case 'picked_up':
        return 'Picked Up';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCourier = _orderType == 'Courier Parcels';
    final currentStatuses = isCourier ? _courierStatuses : _storeStatuses;

    Query query = FirebaseFirestore.instance.collection(isCourier ? 'courier_orders' : 'orders');
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Orders',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Courier Parcels'),
                                    selected: isCourier,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _orderType = 'Courier Parcels';
                                          _selectedStatus = 'All';
                                        });
                                      }
                                    },
                                    selectedColor: const Color(0xFFFF6D00),
                                    labelStyle: TextStyle(
                                      color: isCourier ? Colors.white : const Color(0xFF64748B),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    showCheckmark: false,
                                  ),
                                  const SizedBox(width: 4),
                                  ChoiceChip(
                                    label: const Text('Store Orders'),
                                    selected: !isCourier,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _orderType = 'Store Orders';
                                          _selectedStatus = 'All';
                                        });
                                      }
                                    },
                                    selectedColor: const Color(0xFFFF6D00),
                                    labelStyle: TextStyle(
                                      color: !isCourier ? Colors.white : const Color(0xFF64748B),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    showCheckmark: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: currentStatuses.map((status) {
                              final isSelected = _selectedStatus == status;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(_formatStatusLabel(status)),
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
                                    children: [
                                      const Expanded(flex: 2, child: Text('Order ID', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      const Expanded(flex: 2, child: Text('Type', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text(isCourier ? 'Sender / User' : 'Customer', style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text(isCourier ? 'Recipient' : 'Merchant', style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      const Expanded(flex: 2, child: Text('Status', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      const Expanded(flex: 1, child: Text('Amount', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      const Expanded(flex: 1, child: Text('Action', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: query.snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                                        );
                                      }
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      
                                      final rawDocs = snapshot.data?.docs ?? [];
                                      if (rawDocs.isEmpty) {
                                        return Center(
                                          child: Text(
                                            isCourier ? 'No courier parcels found.' : 'No store orders found.',
                                            style: const TextStyle(color: Colors.grey, fontSize: 15),
                                          ),
                                        );
                                      }

                                      final docs = List<DocumentSnapshot>.from(rawDocs);
                                      docs.sort((a, b) {
                                        final aData = a.data() as Map<String, dynamic>? ?? {};
                                        final bData = b.data() as Map<String, dynamic>? ?? {};
                                        final aDate = _parseDate(aData['created_at'] ?? aData['createdAt'] ?? aData['timestamp']);
                                        final bDate = _parseDate(bData['created_at'] ?? bData['createdAt'] ?? bData['timestamp']);
                                        if (aDate == null && bDate == null) return 0;
                                        if (aDate == null) return 1;
                                        if (bDate == null) return -1;
                                        return bDate.compareTo(aDate);
                                      });

                                      return ListView.separated(
                                        itemCount: docs.length,
                                        separatorBuilder: (context, index) => const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final doc = docs[index];
                                          final data = doc.data() as Map<String, dynamic>;
                                          
                                          final status = (data['status'] ?? (isCourier ? 'pending_price' : 'New')).toString();
                                          final statusColor = _getStatusColor(status);

                                          final amount = isCourier
                                              ? (num.tryParse(data['delivery_price']?.toString() ?? '0')?.toDouble() ?? 0.0)
                                              : (num.tryParse(data['totalAmount']?.toString() ?? data['amount']?.toString() ?? '0')?.toDouble() ?? 0.0);

                                          String typeLabel = isCourier
                                              ? (data['parcel_category'] ?? data['parcel_type'] ?? 'Parcel')
                                              : (data['orderType'] ?? 'Food Delivery');

                                          String customerLabel = isCourier
                                              ? (data['sender_address']?['name'] ?? data['user_name'] ?? data['sender_name'] ?? 'Sender')
                                              : (data['customerName'] ?? 'Customer');

                                          String secondaryLabel = isCourier
                                              ? (data['recipient_address']?['name'] ?? data['recipient_name'] ?? 'Recipient')
                                              : (data['merchantName'] ?? 'Merchant');

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '#${doc.id.substring(0, doc.id.length > 8 ? 8 : doc.id.length).toUpperCase()}',
                                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        isCourier ? Icons.local_shipping : Icons.restaurant,
                                                        size: 16,
                                                        color: const Color(0xFFFF6D00),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Flexible(
                                                        child: Text(
                                                          typeLabel,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(color: Color(0xFF1E293B)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    customerLabel,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(color: Color(0xFF64748B)),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    secondaryLabel,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(color: Color(0xFF64748B)),
                                                  ),
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
                                                        _formatStatusLabel(status),
                                                        style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    '₹${amount.toStringAsFixed(0)}',
                                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.remove_red_eye_outlined, color: Color(0xFFFF6D00)),
                                                    tooltip: 'View Details',
                                                    onPressed: () {
                                                      _showOrderDetailsDialog(context, doc.id, data, status, amount, isCourier);
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

  void _showOrderDetailsDialog(BuildContext context, String orderId, Map<String, dynamic> data, String currentStatus, double amount, bool isCourier) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Order Details (#${orderId.substring(0, orderId.length > 8 ? 8 : orderId.length).toUpperCase()})'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isCourier) ...[
                    Text('Parcel Category: ${data['parcel_category'] ?? data['parcel_type'] ?? 'Parcel'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Weight: ${data['weight'] ?? 'Standard'}'),
                    const SizedBox(height: 8),
                    Text('Sender: ${data['sender_address']?['name'] ?? data['sender_name'] ?? 'N/A'} (${data['sender_address']?['phone'] ?? data['sender_phone'] ?? 'N/A'})'),
                    Text('Pickup: ${data['sender_address']?['address'] ?? 'N/A'}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    const SizedBox(height: 8),
                    Text('Recipient: ${data['recipient_address']?['name'] ?? data['recipient_name'] ?? 'N/A'} (${data['recipient_address']?['phone'] ?? data['recipient_phone'] ?? 'N/A'})'),
                    Text('Drop: ${data['recipient_address']?['address'] ?? 'N/A'}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    const SizedBox(height: 8),
                    if (data['instructions'] != null && data['instructions'].toString().isNotEmpty)
                      Text('Note: ${data['instructions']}', style: const TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(height: 8),
                    Text('Delivery Price: ₹${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ] else ...[
                    Text('Customer: ${data['customerName'] ?? 'John Doe'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Merchant: ${data['merchantName'] ?? 'Store'}'),
                    const SizedBox(height: 8),
                    Text('Type: ${data['orderType'] ?? 'Food Delivery'}'),
                    const SizedBox(height: 8),
                    Text('Amount: ₹${amount.toStringAsFixed(2)}'),
                  ],
                  const SizedBox(height: 8),
                  Text('Current Status: ${_formatStatusLabel(currentStatus)}', style: TextStyle(color: _getStatusColor(currentStatus), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
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
