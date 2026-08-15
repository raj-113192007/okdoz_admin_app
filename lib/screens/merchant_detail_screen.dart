import 'package:flutter/material.dart';

class MerchantDetailScreen extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> merchantData;

  const MerchantDetailScreen({
    super.key,
    required this.docId,
    required this.merchantData,
  });

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Grocery': return Colors.green;
      case 'Pharmacy': return Colors.blue;
      case 'Courier': return Colors.amber;
      case 'Electronics Service': return Colors.grey;
      case 'RO Service': return Colors.lightBlue;
      case 'Restaurant': return const Color(0xFFFF6D00);
      default: return const Color(0xFFFF6D00);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = merchantData['name'] ?? 'Unknown Name';
    final category = merchantData['category'] ?? 'Unknown Sector';
    final email = merchantData['email'] ?? 'Not provided';
    final phone = merchantData['phone'] ?? 'Not provided';
    final shopAddress = merchantData['shopAddress'] ?? 'Not provided';
    final landmark = merchantData['landmark'] ?? 'Not provided';
    final city = merchantData['city'] ?? 'Not provided';
    final pincode = merchantData['pincode'] ?? 'Not provided';
    final state = merchantData['state'] ?? 'Not provided';
    final district = merchantData['district'] ?? 'Not provided';
    final status = merchantData['status'] ?? 'pending_approval';

    final rating = merchantData['rating']?.toString() ?? '0.0';
    final totalOrders = merchantData['totalOrders']?.toString() ?? '0';
    final paymentDue = merchantData['paymentDue']?.toString() ?? '0.00';

    final themeColor = _getColorForCategory(category);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Merchant Details',
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: themeColor.withValues(alpha: 0.1),
                    child: Icon(Icons.storefront, size: 40, color: themeColor),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(color: themeColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: status == 'active' ? Colors.green.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: status == 'active' ? Colors.green.withValues(alpha: 0.5) : Colors.amber.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: status == 'active' ? Colors.green : Colors.amber.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Statistics Grid
            Row(
              children: [
                _buildStatCard('Rating', rating, Icons.star_rounded, Colors.amber),
                const SizedBox(width: 16),
                _buildStatCard('Delivered Orders', totalOrders, Icons.check_circle_outline, Colors.green),
                const SizedBox(width: 16),
                _buildStatCard('Payment Due', '₹$paymentDue', Icons.account_balance_wallet_outlined, const Color(0xFF3B82F6)),
              ],
            ),
            const SizedBox(height: 24),

            // Details Sections
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Contact Information',
                    Icons.contact_mail_outlined,
                    [
                      _buildInfoRow('Email Address', email, Icons.email_outlined),
                      const Divider(height: 32),
                      _buildInfoRow('Phone Number', phone, Icons.phone_outlined),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildInfoCard(
                    'Location Details',
                    Icons.location_on_outlined,
                    [
                      _buildInfoRow('Shop Address', shopAddress, Icons.store_outlined),
                      const Divider(height: 24),
                      _buildInfoRow('Landmark', landmark, Icons.flag_outlined),
                      const Divider(height: 24),
                      _buildInfoRow('City & Pincode', '$city, $pincode', Icons.location_city_outlined),
                      const Divider(height: 24),
                      _buildInfoRow('State & District', '$district, $state', Icons.map_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData headerIcon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(headerIcon, color: const Color(0xFF1E293B), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
