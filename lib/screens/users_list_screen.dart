import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UsersListScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final String collectionName;

  const UsersListScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.collectionName,
  });

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  String _selectedStatus = 'All';
  final List<String> _statuses = ['All', 'Active', 'Pending', 'Blocked'];

  void _showAddUserDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add New ${widget.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 8),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number')),
            const SizedBox(height: 8),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              try {
                await FirebaseFirestore.instance.collection(widget.collectionName).add({
                  'name': nameCtrl.text.trim(),
                  'displayName': nameCtrl.text.trim(),
                  'phone': phoneCtrl.text.trim(),
                  'phoneNumber': phoneCtrl.text.trim(),
                  'email': emailCtrl.text.trim(),
                  'status': 'Active',
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${widget.title} added successfully!'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (ctx.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6D00), foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection(widget.collectionName).orderBy('createdAt', descending: true);
    if (_selectedStatus != 'All') {
      query = FirebaseFirestore.instance.collection(widget.collectionName).where('status', isEqualTo: _selectedStatus);
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6D00).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(widget.icon, color: const Color(0xFFFF6D00)),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              widget.title,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () => _showAddUserDialog(context),
                              icon: const Icon(Icons.add, size: 18),
                              label: Text('Add ${widget.title}'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6D00),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                          ],
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
                            width: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  child: Row(
                                    children: const [
                                      Expanded(flex: 3, child: Text('User details', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text('Contact', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text('Joined', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 1, child: Text('Status', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                      Expanded(flex: 1, child: Text('Action', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: query.snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Center(child: Text('Something went wrong'));
                                      }
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }

                                      final users = snapshot.data?.docs ?? [];
                                      if (users.isEmpty) {
                                        return const Center(child: Text('No users found under this status.'));
                                      }

                                      return ListView.separated(
                                        itemCount: users.length,
                                        separatorBuilder: (context, index) => const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final userData = users[index].data() as Map<String, dynamic>;
                                          final name = userData['displayName'] ?? userData['name'] ?? 'Unknown User';
                                          final email = userData['deviceInfo'] ?? userData['email'] ?? 'No Device Info';
                                          final phone = userData['phoneNumber'] ?? userData['phone'] ?? 'No Phone';
                                          final status = userData['status'] ?? 'Active';
                                          
                                          String joinDate = 'Unknown';
                                          if (userData['createdAt'] != null) {
                                            final timestamp = userData['createdAt'] as Timestamp;
                                            joinDate = DateFormat('dd MMM, yyyy').format(timestamp.toDate());
                                          }

                                          return _AnimatedUserRow(
                                            name: name,
                                            email: email,
                                            phone: phone,
                                            date: joinDate,
                                            status: status,
                                            onTapDetails: () => _showUserDetailsDialog(context, users[index], widget.collectionName),
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
}

class _AnimatedUserRow extends StatefulWidget {
  final String name, email, phone, date, status;
  final VoidCallback onTapDetails;
  const _AnimatedUserRow({required this.name, required this.email, required this.phone, required this.date, required this.status, required this.onTapDetails});

  @override
  State<_AnimatedUserRow> createState() => _AnimatedUserRowState();
}

class _AnimatedUserRowState extends State<_AnimatedUserRow> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.status == 'Active' ? Colors.green : Colors.red;
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
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: Text(widget.name.substring(0, widget.name.isNotEmpty ? 1 : 1), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                      Text(widget.email, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text(widget.phone, style: const TextStyle(color: Color(0xFF1E293B)))),
            Expanded(flex: 2, child: Text(widget.date, style: const TextStyle(color: Color(0xFF64748B)))),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF94A3B8)),
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

void _showUserDetailsDialog(BuildContext context, DocumentSnapshot userDoc, String collectionName) {
  final userData = userDoc.data() as Map<String, dynamic>;
  final name = userData['displayName'] ?? userData['name'] ?? 'Unknown User';
  
  String? orderFilterField;
  if (collectionName == 'users') orderFilterField = 'user_id';
  else if (collectionName == 'delivery_partners') orderFilterField = 'delivery_partner_id';
  else if (collectionName == 'merchants' || collectionName == 'restaurants') orderFilterField = 'vendor_id';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Activity & Details - $name'),
        content: SizedBox(
          width: 600,
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${userDoc.id}', style: const TextStyle(color: Colors.grey)),
              Text('Phone: ${userData['phoneNumber'] ?? userData['phone'] ?? 'N/A'}'),
              Text('Email: ${userData['email'] ?? 'N/A'}'),
              const Divider(),
              const Text('Recent Activity / Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              if (orderFilterField != null)
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('orders').where(orderFilterField, isEqualTo: userDoc.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                      if (snapshot.hasError) return Text('Error loading orders: ${snapshot.error}');
                      
                      final orders = snapshot.data?.docs ?? [];
                      if (orders.isEmpty) return const Text('No orders found for this user.');

                      orders.sort((a, b) {
                        final aData = a.data() as Map<String, dynamic>;
                        final bData = b.data() as Map<String, dynamic>;
                        final aTime = aData['created_at'] as Timestamp?;
                        final bTime = bData['created_at'] as Timestamp?;
                        if (aTime == null || bTime == null) return 0;
                        return bTime.compareTo(aTime);
                      });

                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index].data() as Map<String, dynamic>;
                          final items = order['items'] as List<dynamic>? ?? [];
                          final itemNames = items.map((e) => '${e['qty'] ?? 1}x ${e['name']}').join(', ');
                          
                          String dateStr = 'Unknown';
                          if (order['created_at'] != null) {
                            dateStr = DateFormat('dd MMM, yyyy - hh:mm a').format((order['created_at'] as Timestamp).toDate());
                          }
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text('Order #${orders[index].id.substring(0,8).toUpperCase()} - ₹${order['total_amount'] ?? 0}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date: $dateStr'),
                                  Text('Service/Vendor: ${order['vendor_id'] ?? 'N/A'}'),
                                  Text('Items: $itemNames'),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(order['status'] ?? 'New', style: const TextStyle(color: Colors.blue, fontSize: 12)),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              else
                const Expanded(child: Center(child: Text('Activity tracking not available for this role.'))),
            ],
          ),
        ),
        actions: [
          if (orderFilterField != null && (userData['status'] == 'pending' || userData['status'] == 'Pending'))
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection(collectionName).doc(userDoc.id).update({'status': 'approved'});
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Approved successfully!'), backgroundColor: Colors.green));
                    Navigator.pop(context);
                  }
                } catch(e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Approve Partner'),
            ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
        ],
      );
    },
  );
}
