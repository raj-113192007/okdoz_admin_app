import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminCourierOrdersScreen extends StatefulWidget {
  const AdminCourierOrdersScreen({super.key});

  @override
  State<AdminCourierOrdersScreen> createState() => _AdminCourierOrdersScreenState();
}

class _AdminCourierOrdersScreenState extends State<AdminCourierOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Default fallback delivery agents list
  final List<Map<String, String>> _defaultAgents = [
    {'id': 'agent_01', 'name': 'Ramesh Kumar', 'phone': '+91 9876543210'},
    {'id': 'agent_02', 'name': 'Suresh Singh', 'phone': '+91 9876543211'},
    {'id': 'agent_03', 'name': 'Amit Verma', 'phone': '+91 9876543212'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAdminPriceDialog(BuildContext context, String orderId, Map<String, dynamic> data) {
    final priceController = TextEditingController(
      text: ((data['delivery_price'] as num?)?.toDouble() ?? 0.0) > 0 ? (data['delivery_price']).toString() : '',
    );
    Map<String, String>? selectedAgent = _defaultAgents.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 20),
              const Text(
                'Admin Override: Set Price & Assign Rider',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 8),
              Text(
                'Category: ${data['category'] ?? 'General'} • Weight: ${data['weight'] ?? 'Up to 2kg'}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Price Field
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Delivery Fee / Price (₹)',
                  hintText: 'Enter price e.g. 150',
                  prefixIcon: const Icon(Icons.currency_rupee, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Delivery Agent Dropdown
              const Text('Assign Delivery Agent', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: _db.collection('delivery_agents').snapshots(),
                builder: (context, snapshot) {
                  List<Map<String, String>> agentsList = [..._defaultAgents];

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final firestoreAgents = snapshot.data!.docs.map((doc) {
                      final d = doc.data() as Map<String, dynamic>;
                      return {
                        'id': doc.id,
                        'name': (d['name'] ?? 'Delivery Boy').toString(),
                        'phone': (d['phone'] ?? '+91 9000000000').toString(),
                      };
                    }).toList();
                    agentsList = [...firestoreAgents, ..._defaultAgents];
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Map<String, String>>(
                        value: selectedAgent,
                        isExpanded: true,
                        items: agentsList.map((agent) {
                          return DropdownMenuItem<Map<String, String>>(
                            value: agent,
                            child: Row(
                              children: [
                                const Icon(Icons.two_wheeler, color: Colors.amber, size: 20),
                                const SizedBox(width: 10),
                                Text('${agent['name']} (${agent['phone']})', style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedAgent = val);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final priceText = priceController.text.trim();
                    if (priceText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter delivery price')));
                      return;
                    }
                    final double? price = double.tryParse(priceText);
                    if (price == null || price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid price')));
                      return;
                    }

                    await _db.collection('courier_orders').doc(orderId).update({
                      'status': 'price_set',
                      'delivery_price': price,
                      'total_amount': price,
                      'delivery_agent_id': selectedAgent!['id']!,
                      'delivery_agent_name': selectedAgent!['name']!,
                      'delivery_agent_phone': selectedAgent!['phone']!,
                      'updatedAt': FieldValue.serverTimestamp(),
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Admin set price ₹$price & assigned ${selectedAgent!['name']}')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save Changes & Notify User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourierCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final orderId = doc.id;
    final status = data['status'] ?? 'pending_review';
    final category = data['category'] ?? 'Documents';
    final weight = data['weight'] ?? 'Up to 2kg';
    final instruction = data['instruction'] ?? 'No instructions provided';
    final pickupAddress = data['pickup_address'] ?? 'Pickup location';
    final dropAddress = data['drop_address'] ?? 'Drop location';
    final senderName = data['sender_name'] ?? 'Sender';
    final senderPhone = data['sender_phone'] ?? '-';
    final receiverName = data['receiver_name'] ?? 'Receiver';
    final receiverPhone = data['receiver_phone'] ?? '-';
    final price = (data['delivery_price'] as num?)?.toDouble() ?? 0.0;
    final agentName = data['delivery_agent_name'] ?? '';
    final agentPhone = data['delivery_agent_phone'] ?? '';
    final imageUrl = data['image_url'] ?? '';
    final List<dynamic> rawImageUrls = data['image_urls'] is List ? (data['image_urls'] as List) : (imageUrl.isNotEmpty ? [imageUrl] : []);
    final List<String> imageUrls = rawImageUrls.map((e) => e.toString()).toList();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top ID & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_shipping, color: Colors.amber, size: 22),
                    const SizedBox(width: 8),
                    Text('Order #${orderId.length > 8 ? orderId.substring(0, 8) : orderId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                _buildStatusBadge(status),
              ],
            ),
            const Divider(height: 24),

            // Package Photo Gallery (Multiple Images)
            if (imageUrls.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📸 Package Photos (${imageUrls.length}):', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 85,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, idx) {
                        final img = imageUrls[idx];
                        return Container(
                          width: 85,
                          height: 85,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.amber.shade300, width: 1.5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: img.startsWith('http')
                                ? Image.network(img, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.inventory_2, color: Colors.amber))
                                : Image.asset(img, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.inventory_2, color: Colors.amber)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(6)),
                            child: Text(category, style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)),
                            child: Text(weight, style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Instructions:', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(instruction, style: const TextStyle(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Addresses Box (Pickup & Drop + Sender & Receiver Phone Numbers)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.my_location, color: Colors.green, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PICKUP ADDRESS & SENDER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                            Text('$pickupAddress', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text('Sender: $senderName • Phone: $senderPhone', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('DROP ADDRESS & RECEIVER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red)),
                            Text('$dropAddress', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text('Receiver: $receiverName • Phone: $receiverPhone', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Agent & Fee Info / Admin Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(status == 'price_set' || status == 'delivered' ? 'Assigned Rider: $agentName ($agentPhone)' : 'Awaiting Price & Rider', style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(price > 0 ? 'Delivery Fee: ₹${price.toStringAsFixed(0)}' : 'Fee: Pending', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: price > 0 ? Colors.green.shade700 : Colors.orange.shade800)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAdminPriceDialog(context, orderId, data),
                  icon: const Icon(Icons.tune, size: 18),
                  label: Text(status == 'pending_review' ? 'Set Price & Rider' : 'Edit Price / Rider'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = Colors.grey.shade100;
    Color text = Colors.grey.shade800;
    String label = status;

    if (status == 'pending_review') {
      bg = Colors.amber.shade100;
      text = Colors.amber.shade900;
      label = 'Pending Review';
    } else if (status == 'price_set') {
      bg = Colors.green.shade100;
      text = Colors.green.shade800;
      label = 'Price Set & Assigned';
    } else if (status == 'delivered') {
      bg = Colors.blue.shade100;
      text = Colors.blue.shade800;
      label = 'Delivered';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Admin Courier Operations Center'),
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Requests'),
            Tab(text: 'Pending Review'),
            Tab(text: 'Price Set'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('courier_orders').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_outlined, size: 70, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('No Courier Requests Found in Admin Database', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          final allDocs = snapshot.data!.docs;
          final pendingDocs = allDocs.where((d) => (d.data() as Map<String, dynamic>)['status'] == 'pending_review').toList();
          final assignedDocs = allDocs.where((d) => (d.data() as Map<String, dynamic>)['status'] == 'price_set').toList();
          final deliveredDocs = allDocs.where((d) => (d.data() as Map<String, dynamic>)['status'] == 'delivered').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(allDocs),
              _buildList(pendingDocs),
              _buildList(assignedDocs),
              _buildList(deliveredDocs),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(List<DocumentSnapshot> docs) {
    if (docs.isEmpty) {
      return Center(
        child: Text('No orders in this tab.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: docs.length,
      itemBuilder: (context, index) => _buildCourierCard(docs[index]),
    );
  }
}
