import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/page/notifications_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // General Section
          Text(
            "General",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications_none,
                      color: Theme.of(context).colorScheme.primary),
                  title: const Text("Notifications"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.dark_mode_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  title: const Text("Appearance"),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline,
                      color: Theme.of(context).colorScheme.primary),
                  title: const Text("Privacy"),
                  onTap: () {}, // No action
                ),
                ListTile(
                  leading: Icon(Icons.cloud_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  title: const Text("Storage & Data"),
                  onTap: () {}, // No action
                ),
                ListTile(
                  leading: Icon(Icons.help_outline,
                      color: Theme.of(context).colorScheme.primary),
                  title: const Text("About"),
                  onTap: () {}, // No action
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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.logout,
                      color: Theme.of(context).colorScheme.primary),
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
