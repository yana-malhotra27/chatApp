import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/page/notifications_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search settings...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text(
                "Settings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          const Icon(Icons.more_vert),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // General Section
          Text(
            "General",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (_searchQuery.isEmpty ||
                    "notifications".contains(_searchQuery.toLowerCase()))
                  ListTile(
                    leading: Icon(Icons.notifications_none,
                        color: colorScheme.primary),
                    title: const Text("Notifications"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationsPage()),
                      );
                    },
                  ),
                if (_searchQuery.isEmpty ||
                    "appearance".contains(_searchQuery.toLowerCase()))
                  ListTile(
                    leading: Icon(Icons.dark_mode_outlined,
                        color: colorScheme.primary),
                    title: const Text("Appearance"),
                    onTap: () => themeProvider.toggleTheme(),
                  ),
                if (_searchQuery.isEmpty ||
                    "privacy".contains(_searchQuery.toLowerCase()))
                  ListTile(
                    leading:
                        Icon(Icons.lock_outline, color: colorScheme.primary),
                    title: const Text("Privacy"),
                    onTap: () {},
                  ),
                if (_searchQuery.isEmpty ||
                    "storage".contains(_searchQuery.toLowerCase()))
                  ListTile(
                    leading:
                        Icon(Icons.cloud_outlined, color: colorScheme.primary),
                    title: const Text("Storage & Data"),
                    onTap: () {},
                  ),
                if (_searchQuery.isEmpty ||
                    "about".contains(_searchQuery.toLowerCase()))
                  ListTile(
                    leading:
                        Icon(Icons.help_outline, color: colorScheme.primary),
                    title: const Text("About"),
                    onTap: () {},
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Account Section
          Text(
            "Account",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (_searchQuery.isEmpty ||
                    "log out".contains(_searchQuery.toLowerCase()))
                  ListTile(
                    leading: Icon(Icons.logout, color: colorScheme.primary),
                    title: const Text("Log Out"),
                    onTap: () => authService.signOut(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
