import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopHeader(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;
              
              if (isMobile) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSettingsSidebar(isMobile: true),
                      const SizedBox(height: 24),
                      _buildSettingsContent(isMobile: true),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSettingsSidebar(isMobile: false),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildSettingsContent(isMobile: false),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSidebar({required bool isMobile}) {
    return Container(
      width: isMobile ? null : 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          ),
          const Divider(height: 1),
          _SettingsTab(icon: Icons.person_outline, title: 'Profile Settings', isSelected: true),
          _SettingsTab(icon: Icons.notifications_outlined, title: 'Notifications', isSelected: false),
          _SettingsTab(icon: Icons.security_outlined, title: 'Security', isSelected: false),
          _SettingsTab(icon: Icons.payment_outlined, title: 'Payment Gateways', isSelected: false),
          _SettingsTab(icon: Icons.language_outlined, title: 'Localization', isSelected: false),
          _SettingsTab(icon: Icons.admin_panel_settings_outlined, title: 'Admin Roles', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildSettingsContent({required bool isMobile}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Profile Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 8),
          const Text('Update your admin account details and preferences.', style: TextStyle(color: Color(0xFF64748B))),
          const SizedBox(height: 32),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Change Avatar'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Remove', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          isMobile
              ? Column(
                  children: [
                    _buildTextField('First Name', 'John'),
                    const SizedBox(height: 24),
                    _buildTextField('Last Name', 'Doe'),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildTextField('First Name', 'John')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField('Last Name', 'Doe')),
                  ],
                ),
          const SizedBox(height: 24),
          isMobile
              ? Column(
                  children: [
                    _buildTextField('Email Address', 'admin@okdoz.com'),
                    const SizedBox(height: 24),
                    _buildTextField('Phone Number', '+91 98765 43210'),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildTextField('Email Address', 'admin@okdoz.com')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField('Phone Number', '+91 98765 43210')),
                  ],
                ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 16,
            runSpacing: 16,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF6D00)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  const _SettingsTab({required this.icon, required this.title, required this.isSelected});

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.isSelected 
            ? const Color(0xFFFFF0E6) 
            : (_isHovering ? Colors.grey.shade50 : Colors.transparent),
          border: Border(
            left: BorderSide(
              color: widget.isSelected ? const Color(0xFFFF6D00) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(widget.icon, color: widget.isSelected ? const Color(0xFFFF6D00) : const Color(0xFF64748B)),
          title: Text(
            widget.title,
            style: TextStyle(
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
              color: widget.isSelected ? const Color(0xFFFF6D00) : const Color(0xFF1E293B),
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
