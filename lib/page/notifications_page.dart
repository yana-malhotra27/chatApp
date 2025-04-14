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
          icon: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.onErrorContainer,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
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
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            title: Text("Private chats", style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.onErrorContainer,)),
            value: privateChats,
            onChanged: (val) => setState(() => privateChats = val),
            activeColor: colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            title: Text("Group chats", style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.onErrorContainer,)),
            value: groupChats,
            onChanged: (val) => setState(() => groupChats = val),
            activeColor: colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            title: Text("Do not disturb", style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.onErrorContainer,)),
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
