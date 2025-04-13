import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool privateChats = true;
  bool groupChats = false;
  bool doNotDisturb = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16), // space after appbar

          Text(
            "Message notifications",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text("Private chats", style: TextStyle(fontSize: 16)),
            value: privateChats,
            onChanged: (val) => setState(() => privateChats = val),
            activeColor: colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            title: const Text("Group chats", style: TextStyle(fontSize: 16)),
            value: groupChats,
            onChanged: (val) => setState(() => groupChats = val),
            activeColor: colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            title: const Text("Do not disturb", style: TextStyle(fontSize: 16)),
            value: doNotDisturb,
            onChanged: (val) => setState(() => doNotDisturb = val),
            activeColor: colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
