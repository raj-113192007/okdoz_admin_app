import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/dashboard_widgets.dart';

class PartnerCredentialsScreen extends StatefulWidget {
  const PartnerCredentialsScreen({super.key});

  @override
  State<PartnerCredentialsScreen> createState() => _PartnerCredentialsScreenState();
}

class _PartnerCredentialsScreenState extends State<PartnerCredentialsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _visiblePasswords = {};

  // Master Restaurant Partner Directory (Real Bhabua Affiliated Partners)
  final List<Map<String, dynamic>> _restaurantPartners = [
    {
      'id': 'five-star-restaurant',
      'name': 'Five Star Restaurant',
      'contact': '9661440600',
      'email': 'fivestar@partner.okdoz.in',
      'password': 'FiveStar@123',
      'address': 'Akhlaspur Road, Devi Mandir ke Samne, Ward No. 3, Bhabua',
      'landmark': 'Devi Mandir',
      'category': 'Family Restaurant (Mughlai, North Indian)',
      'status': 'APPROVED & LIVE',
      'rating': 4.6,
      'color': const Color(0xFFFF6D00),
    },
    {
      'id': 'cfc-restaurant',
      'name': 'CFC & Restaurant',
      'contact': '9470123456',
      'email': 'cfc@partner.okdoz.in',
      'password': 'CFC@123',
      'address': 'Bhabua-Mohaniya Main Road, Near Bus Stand, Bhabua',
      'landmark': 'Bus Stand',
      'category': 'Crispy Fried Chicken & Restaurant',
      'status': 'APPROVED & LIVE',
      'rating': 4.7,
      'color': const Color(0xFFE53935),
    },
    {
      'id': 'sweet-tooth-cafe',
      'name': 'Sweet Tooth Cafe & Restaurant',
      'contact': '9122334455',
      'email': 'sweettooth@partner.okdoz.in',
      'password': 'SweetTooth@123',
      'address': 'Court Road, Near Ekta Chowk, Bhabua',
      'landmark': 'Ekta Chowk',
      'category': 'Cafe, Beverages & Fast Food',
      'status': 'APPROVED & LIVE',
      'rating': 4.8,
      'color': const Color(0xFF8E24AA),
    },
    {
      'id': 'zorko-food',
      'name': 'Zorko - Brand of Food Lovers',
      'contact': '9835123456',
      'email': 'zorko@partner.okdoz.in',
      'password': 'Zorko@123',
      'address': 'Opposite Town High School, Mohania Road, Bhabua',
      'landmark': 'Town High School',
      'category': 'Fast Food, Burgers & Shakes',
      'status': 'APPROVED & LIVE',
      'rating': 4.6,
      'color': const Color(0xFFFFB300),
    },
    {
      'id': 'rajdarbar-family-restaurant',
      'name': 'Rajdarbar Family Restaurant',
      'contact': '9771245800',
      'email': 'rajdarbar@partner.okdoz.in',
      'password': 'Rajdarbar@123',
      'address': 'Patel Chowk, Kudra Road, Bhabua',
      'landmark': 'Patel Chowk',
      'category': 'Royal Mughlai & Handi Special',
      'status': 'APPROVED & LIVE',
      'rating': 4.6,
      'color': const Color(0xFF1E88E5),
    },
    {
      'id': 'onebite-cafe',
      'name': 'OneBite Cafe',
      'contact': '7004488123',
      'email': 'onebite@partner.okdoz.in',
      'password': 'OneBite@123',
      'address': 'Near Collectorate Gate, Bhabua',
      'landmark': 'Collectorate Gate',
      'category': 'Burgers, Wraps & Garlic Breads',
      'status': 'APPROVED & LIVE',
      'rating': 4.5,
      'color': const Color(0xFF00ACC1),
    },
    {
      'id': 'zaika-restaurant',
      'name': 'Zaika Restaurant',
      'contact': '8051233445',
      'email': 'zaika@partner.okdoz.in',
      'password': 'Zaika@123',
      'address': 'Chawni Mohalla, Main Market, Bhabua',
      'landmark': 'Chawni Mohalla',
      'category': 'Mughlai Korma & Tandoori',
      'status': 'APPROVED & LIVE',
      'rating': 4.4,
      'color': const Color(0xFF43A047),
    },
  ];

  // Master Delivery Partner Directory (Bhabua Delivery Boys)
  final List<Map<String, dynamic>> _deliveryPartners = [
    {
      'id': 'dp_ankit_kumar',
      'name': 'Ankit Kumar',
      'contact': '7488087395',
      'email': 'ankit@delivery.okdoz.in',
      'password': 'Ankit@123',
      'vehicle': 'Hero Splendor (Bike)',
      'vehicleNumber': 'BR-45-7890',
      'serviceArea': 'Bhabua Town & Akhlaspur',
      'rating': 4.9,
      'deliveries': 215,
      'status': 'ACTIVE / AVAILABLE',
    },
    {
      'id': 'dp_priyanshu_kumar',
      'name': 'Priyanshu Kumar',
      'contact': '9142070937',
      'email': 'priyanshu@delivery.okdoz.in',
      'password': 'Priyanshu@123',
      'vehicle': 'Honda Shine (Bike)',
      'vehicleNumber': 'BR-45-3412',
      'serviceArea': 'Bhabua Town, Mohanpur & Ekta Chowk',
      'rating': 4.8,
      'deliveries': 184,
      'status': 'ACTIVE / AVAILABLE',
    },
    {
      'id': 'dp_rakesh_kumar',
      'name': 'Rakesh Kumar',
      'contact': '8210031549',
      'email': 'rakesh@delivery.okdoz.in',
      'password': 'Rakesh@123',
      'vehicle': 'Bajaj Pulsar (Bike)',
      'vehicleNumber': 'BR-45-9011',
      'serviceArea': 'Bhabua Town, Bus Stand & College Road',
      'rating': 4.9,
      'deliveries': 240,
      'status': 'ACTIVE / AVAILABLE',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('$label copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyFormattedCredentials(Map<String, dynamic> partner, bool isRestaurant) {
    String msg;
    if (isRestaurant) {
      msg = '''*OK DOZ RESTAURANT PARTNER LOGIN*
━━━━━━━━━━━━━━━━━━━━━━
🏪 *Restaurant:* ${partner['name']}
📞 *Phone / ID:* ${partner['contact']}
📧 *Email Login:* ${partner['email']}
🔑 *Password:* ${partner['password']}
📍 *Address:* ${partner['address']}
━━━━━━━━━━━━━━━━━━━━━━
📲 *Download Partner App:* OK DOZ Partner
_Login karke live orders aur menu manage karein!_''';
    } else {
      msg = '''*OK DOZ DELIVERY PARTNER LOGIN*
━━━━━━━━━━━━━━━━━━━━━━
🛵 *Rider Name:* ${partner['name']}
📞 *Phone / ID:* ${partner['contact']}
📧 *Email Login:* ${partner['email']}
🔑 *Password:* ${partner['password']}
🏍️ *Vehicle:* ${partner['vehicle']} (${partner['vehicleNumber']})
📍 *Area:* ${partner['serviceArea']}
━━━━━━━━━━━━━━━━━━━━━━
📲 *Download Delivery App:* OK DOZ Delivery
_Login karke live delivery duty start karein!_''';
    }

    Clipboard.setData(ClipboardData(text: msg));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('📋 WhatsApp-ready credentials copied! Paste to send to partner.'),
        backgroundColor: const Color(0xFF1E88E5),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Summary Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6D00).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.key, color: Color(0xFFFF6D00), size: 30),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Partner & Rider Credentials Directory',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Instant lookup for Restaurant IDs, Passwords, Addresses & Delivery Boy Accounts',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade400),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.verified, color: Colors.greenAccent, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Firebase Auth Active',
                              style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Controls: Tabs & Search Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 380,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFFFF6D00),
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: const Color(0xFFFF6D00),
                        indicatorWeight: 3,
                        tabs: [
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.restaurant, size: 18),
                                SizedBox(width: 8),
                                Text('Restaurants (7)', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.two_wheeler, size: 18),
                                SizedBox(width: 8),
                                Text('Delivery Boys (3)', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      height: 42,
                      child: TextField(
                        controller: _searchController,
                        maxLength: 80,
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                        onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                        decoration: InputDecoration(
                          hintText: 'Search name, phone or email...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRestaurantTab(),
                      _buildDeliveryTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantTab() {
    final filteredList = _restaurantPartners.where((p) {
      final name = p['name'].toString().toLowerCase();
      final contact = p['contact'].toString().toLowerCase();
      final email = p['email'].toString().toLowerCase();
      return name.contains(_searchQuery) || contact.contains(_searchQuery) || email.contains(_searchQuery);
    }).toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final p = filteredList[index];
        final isPassVisible = _visiblePasswords.contains(p['id']);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo/Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (p['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(Icons.restaurant, color: p['color'] as Color, size: 26),
                ),
              ),
              const SizedBox(width: 16),

              // Restaurant & Address Info
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          p['name'],
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Text(
                            p['status'],
                            style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p['category'],
                      style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            p['address'],
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Credentials Column
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Phone / Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.phone_android, size: 15, color: Colors.black54),
                              const SizedBox(width: 6),
                              const Text('Phone Login: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              SelectableText(
                                p['contact'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _copyToClipboard(p['contact'], 'Phone number'),
                            child: const Icon(Icons.copy, size: 16, color: Color(0xFFFF6D00)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Email Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 15, color: Colors.black54),
                              const SizedBox(width: 6),
                              const Text('Email: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              SelectableText(
                                p['email'],
                                style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _copyToClipboard(p['email'], 'Email'),
                            child: const Icon(Icons.copy, size: 16, color: Color(0xFFFF6D00)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 15, color: Colors.black54),
                              const SizedBox(width: 6),
                              const Text('Password: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              SelectableText(
                                isPassVisible ? p['password'] : '••••••••••••',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFD97706)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isPassVisible) {
                                      _visiblePasswords.remove(p['id']);
                                    } else {
                                      _visiblePasswords.add(p['id']);
                                    }
                                  });
                                },
                                child: Icon(
                                  isPassVisible ? Icons.visibility_off : Icons.visibility,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => _copyToClipboard(p['password'], 'Password'),
                                child: const Icon(Icons.copy, size: 16, color: Color(0xFFFF6D00)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Action button to send / share
              ElevatedButton.icon(
                onPressed: () => _copyFormattedCredentials(p, true),
                icon: const Icon(Icons.share, size: 16),
                label: const Text('Share / Copy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliveryTab() {
    final filteredList = _deliveryPartners.where((p) {
      final name = p['name'].toString().toLowerCase();
      final contact = p['contact'].toString().toLowerCase();
      return name.contains(_searchQuery) || contact.contains(_searchQuery);
    }).toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final p = filteredList[index];
        final isPassVisible = _visiblePasswords.contains(p['id']);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(Icons.two_wheeler, color: Colors.purple.shade700, size: 28),
                ),
              ),
              const SizedBox(width: 16),

              // Rider info & Vehicle
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          p['name'],
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.blue.shade300),
                          ),
                          child: Text(
                            p['status'],
                            style: TextStyle(color: Colors.blue.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🏍️ ${p['vehicle']} (${p['vehicleNumber']})',
                      style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.map_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Area: ${p['serviceArea']}',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${p['rating']} (${p['deliveries']} trips)',
                          style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Credentials Column
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Phone / Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.phone_android, size: 15, color: Colors.black54),
                              const SizedBox(width: 6),
                              const Text('Phone Login: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              SelectableText(
                                p['contact'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _copyToClipboard(p['contact'], 'Rider Phone'),
                            child: const Icon(Icons.copy, size: 16, color: Color(0xFFFF6D00)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Email
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 15, color: Colors.black54),
                              const SizedBox(width: 6),
                              const Text('Email: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              SelectableText(
                                p['email'],
                                style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _copyToClipboard(p['email'], 'Email'),
                            child: const Icon(Icons.copy, size: 16, color: Color(0xFFFF6D00)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 15, color: Colors.black54),
                              const SizedBox(width: 6),
                              const Text('Password: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              SelectableText(
                                isPassVisible ? p['password'] : '••••••••••••',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFD97706)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isPassVisible) {
                                      _visiblePasswords.remove(p['id']);
                                    } else {
                                      _visiblePasswords.add(p['id']);
                                    }
                                  });
                                },
                                child: Icon(
                                  isPassVisible ? Icons.visibility_off : Icons.visibility,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => _copyToClipboard(p['password'], 'Password'),
                                child: const Icon(Icons.copy, size: 16, color: Color(0xFFFF6D00)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Action button
              ElevatedButton.icon(
                onPressed: () => _copyFormattedCredentials(p, false),
                icon: const Icon(Icons.share, size: 16),
                label: const Text('Share / Copy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
