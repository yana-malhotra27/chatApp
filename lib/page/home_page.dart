import 'package:chatapp/page/chat_page.dart';
import 'package:chatapp/page/contacts_page.dart';
import 'package:chatapp/page/newcontactpage.dart';
import 'package:chatapp/page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_selectedIndex == 0)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
              ),
            )
          : null,
      body: _getPage(_selectedIndex),
     bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  selectedItemColor: Theme.of(context).colorScheme.onErrorContainer,
  unselectedItemColor: Theme.of(context).colorScheme.onErrorContainer,
  backgroundColor: Theme.of(context).colorScheme.surface,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: "Chats",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: "Contacts",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      label: "Settings",
    ),
  ],
),

      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NewContactPage(),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                _selectedIndex == 0 ? Icons.edit_outlined : Icons.add,
                color: Theme.of(context).colorScheme.onErrorContainer
              ),
            )
          : null,
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildUserList();
      case 1:
        return ContactsPage();
      case 2:
        return const SettingsPage();
      default:
        return _buildUserList();
    }
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error!'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Map<String, dynamic>> users =
            snapshot.data as List<Map<String, dynamic>>;

        final currentUserEmail = _authService.currentUser?.email ?? '';

        List<Map<String, dynamic>> filteredUsers = users.where((user) {
  final username = user['username']?.toString().toLowerCase() ?? '';
  final email = user['email']?.toString().toLowerCase() ?? '';
  return username.contains(_searchQuery) && email != currentUserEmail;
}).toList();

        filteredUsers = filteredUsers.reversed.toList();

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(filteredUsers[index], context, index < 2);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context,
      bool showUnreadBadge) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData["email"],
                recieverID: userData["uid"],
                recieverUsername: userData["username"] ?? 'Unknown',
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                icon: Icon(Icons.delete_outline,
                    color: Theme.of(context).colorScheme.primary),
                title: Text("Delete conversation?",style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),),
                content: Text(
                  "This conversation will be removed from all your synced devices. This action cannot be undone."
                , style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Handle deletion here
                      Navigator.pop(context);
                      await _chatService.deleteConversation(userData["uid"]);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('lib/images/person.jpg'),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData['username'] ?? 'Unknown',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hey there! How are you?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '4:30 PM',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (showUnreadBadge)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
