import 'package:flutter/material.dart';
import 'notifications_page.dart'; // Make sure this file exists

class UserProfile extends StatelessWidget {
  final String name;
  final String imagePath;

  const UserProfile({
    super.key,
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onErrorContainer),
          onPressed: () => Navigator.pop(context),
        ),
        
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // Profile Picture
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Colors.transparent,
          ),

          const SizedBox(height: 12),

          // Username
          Text(
            name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onErrorContainer),
          ),

          const SizedBox(height: 4),

          // Constant 10-digit number
          Text(
            '9876543210',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onErrorContainer
            ),
          ),

          const SizedBox(height: 24),

          // Row with icons (Message, Call, Mute)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionIcon(
                  icon: Icons.message_outlined,
                  label: 'Message',
                  colorScheme: colorScheme,
                ),
                _ActionIcon(
                  icon: Icons.call_outlined,
                  label: 'Call',
                  colorScheme: colorScheme,
                ),
                _ActionIcon(
                  icon: Icons.notifications_outlined,
                  label: 'Mute',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // More Actions Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'More actions',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ListTiles
          ListTile(
            leading: Icon(Icons.image_outlined, color: colorScheme.primary),
            title: Text('View media',style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.search_outlined, color: colorScheme.primary),
            title: Text('Search in conversation',style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
            onTap: () {},
          ),
          ListTile(
            leading:
                Icon(Icons.notifications_outlined, color: colorScheme.primary),
            title: Text('Notifications',style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: colorScheme.primary,
          child: Icon(icon, color: colorScheme.surface),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
