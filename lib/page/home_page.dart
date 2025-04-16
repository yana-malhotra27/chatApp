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
  final SearchController _searchController = SearchController();

  List<Map<String, dynamic>> _allUsers = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _loadUsers() {
    _chatService.getUserStream().listen((data) {
      final currentUserEmail = _authService.currentUser?.email ?? '';
      final users =
          data.where((user) => user['email'] != currentUserEmail).toList();
      setState(() {
        _allUsers = users.reversed.toList(); // latest on top
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? _buildSearchAppBar() : null,
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.onErrorContainer,
        unselectedItemColor: Theme.of(context).colorScheme.onErrorContainer,
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Contacts"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewContactPage()),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                _selectedIndex == 0 ? Icons.edit_outlined : Icons.add,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: SearchAnchor.bar(
        searchController: _searchController,
        barHintText: "Search",
        viewHintText: "Search",
        barBackgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.outline.withOpacity(0.08),
        ),
        barElevation: const WidgetStatePropertyAll(0),
        dividerColor: Theme.of(context).colorScheme.surface,
        suggestionsBuilder: (context, controller) {
          final query = controller.text.toLowerCase();
          final filtered = _allUsers.where((user) {
            final username = (user['username'] ?? '').toString().toLowerCase();
            return username.contains(query);
          }).toList();

          return [
            // Horizontally scrollable filtered avatars with names
            Material(
              type: MaterialType.transparency,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: filtered.map((user) {
                    return GestureDetector(
                      onTap: () {
                        controller.closeView(null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              recieverEmail: user['email'],
                              recieverID: user['uid'],
                              recieverUsername: user['username'] ?? 'Unknown',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  const AssetImage('lib/images/person.jpg'),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user['username'] ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Category ListTiles
            ListTile(
              leading: Icon(Icons.image,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Photos',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.video_collection,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Videos',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.headphones,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Music',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.language,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Links',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer),
              ),
              onTap: () {},
            ),
          ];
        },
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildUserList();
      case 1:
        return const ContactsPage();
      case 2:
        return const SettingsPage();
      default:
        return _buildUserList();
    }
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: _allUsers.length,
      itemBuilder: (context, index) {
        return _buildUserListItem(_allUsers[index], index < 2);
      },
    );
  }

  Widget _buildCategoryTile(IconData icon, String label) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, bool showUnreadBadge) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatPage(
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
            builder: (_) => AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              icon:
                  Icon(Icons.delete_outline, color: theme.colorScheme.primary),
              title: Text("Delete conversation?",
                  style: TextStyle(color: theme.colorScheme.onErrorContainer)),
              content: Text(
                "This conversation will be removed from all your synced devices. This action cannot be undone.",
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel",
                      style: TextStyle(color: theme.colorScheme.primary)),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _chatService.deleteConversation(userData["uid"]);
                  },
                  child: Text("Delete",
                      style: TextStyle(color: theme.colorScheme.primary)),
                ),
              ],
            ),
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
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hey there! How are you?',
                      style: TextStyle(
                        color: theme.colorScheme.outline,
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
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (showUnreadBadge)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: theme.colorScheme.onError,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
