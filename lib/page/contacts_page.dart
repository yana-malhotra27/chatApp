// contacts_page.dart
import 'package:chatapp/components/user_tile.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.inversePrimary),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Contact List
        Expanded(
          child: StreamBuilder(
            stream: _chatService.getUserStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Error!'));
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Map<String, dynamic>> users =
                  snapshot.data as List<Map<String, dynamic>>;

              // Remove current user
              users.removeWhere((user) =>
                  user['email'] == _authService.getCurrentUser()!.email);

              // Filter by search
              if (_searchQuery.isNotEmpty) {
                users = users
                    .where((user) =>
                        user['email'].toLowerCase().contains(_searchQuery))
                    .toList();
              }

              // Sort alphabetically
              users.sort((a, b) => a['email'].compareTo(b['email']));

              // Group by first letter
              Map<String, List<Map<String, dynamic>>> groupedUsers = {};
              for (var user in users) {
                String letter = user['email'][0].toUpperCase();
                groupedUsers.putIfAbsent(letter, () => []).add(user);
              }

              return ListView(
                children: groupedUsers.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Text(
                          entry.key,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      ...entry.value.map((userData) {
                        return UserTile(
                          text: userData['email'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  recieverEmail: userData['email'],
                                  recieverID: userData['uid'],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
