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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Custom stacked header
            Stack(
              children: [
                // Top-right actions
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                // Bottom-left title
                const Positioned(
                  bottom: 0,
                  left: 0,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Optional search field
            if (_isSearching)
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search settings...",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

            const SizedBox(height: 24),

            // User info
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('lib/images/person.jpg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daniel',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '9876543210',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section title
            Text(
              "General",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),

            // Settings list with search filter
            if (_searchQuery.isEmpty ||
                "notifications".contains(_searchQuery.toLowerCase()))
              ListTile(
                leading:
                    Icon(Icons.notifications_none, color: colorScheme.primary),
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
                leading:
                    Icon(Icons.dark_mode_outlined, color: colorScheme.primary),
                title: const Text("Appearance"),
                onTap: () => themeProvider.toggleTheme(),
              ),
            if (_searchQuery.isEmpty ||
                "privacy".contains(_searchQuery.toLowerCase()))
              ListTile(
                leading: Icon(Icons.lock_outline, color: colorScheme.primary),
                title: const Text("Privacy"),
                onTap: () {},
              ),
            if (_searchQuery.isEmpty ||
                "storage".contains(_searchQuery.toLowerCase()))
              ListTile(
                leading: Icon(Icons.cloud_outlined, color: colorScheme.primary),
                title: const Text("Storage & Data"),
                onTap: () {},
              ),
            if (_searchQuery.isEmpty ||
                "about".contains(_searchQuery.toLowerCase()))
              ListTile(
                leading: Icon(Icons.help_outline, color: colorScheme.primary),
                title: const Text("About"),
                onTap: () {},
              ),
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
    );
  }
}
