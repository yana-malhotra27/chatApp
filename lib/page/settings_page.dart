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
                        icon: Icon(_isSearching ? Icons.close : Icons.search,color: Theme.of(context).colorScheme.onErrorContainer,),
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
                        icon: Icon(Icons.more_vert,color: Theme.of(context).colorScheme.onErrorContainer,),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                // Bottom-left title
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 26,
                      color: Theme.of(context).colorScheme.onErrorContainer,
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search settings...",
                  fillColor: Theme.of(context).colorScheme.outline,
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
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Daniel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '9876543210',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onErrorContainer,
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
                title: Text("Notifications",style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
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
                title: Text("Appearance",style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
                onTap: () => themeProvider.toggleTheme(),
              ),
            if (_searchQuery.isEmpty ||
                "privacy".contains(_searchQuery.toLowerCase()))
              ListTile(
                leading: Icon(Icons.lock_outline, color: colorScheme.primary),
                title: Text("Privacy",style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
                onTap: () {},
              ),
            if (_searchQuery.isEmpty ||
                "storage".contains(_searchQuery.toLowerCase()))
              ListTile(
                leading: Icon(Icons.cloud_outlined, color: colorScheme.primary),
                title: Text("Storage & Data",style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
                onTap: () {},
              ),
            if (_searchQuery.isEmpty ||
                "about".contains(_searchQuery.toLowerCase()))
              ListTile(
                leading: Icon(Icons.help_outline, color: colorScheme.primary),
                title: Text("About",style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
                onTap: () {},
              ),
            if (_searchQuery.isEmpty ||
                "log out".contains(_searchQuery.toLowerCase()))
              ListTile(
                leading: Icon(Icons.logout, color: colorScheme.primary),
                title: Text("Log Out",style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
                onTap: () => authService.signOut(),
              ),
          ],
        ),
      ),
    );
  }
}
