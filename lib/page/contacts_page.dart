import 'package:chatapp/page/user_profile.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<Map<String, String>> allContacts = [
    {'name': 'Alicia', 'image': 'lib/images/person.jpg'},
    {'name': 'Anthony', 'image': 'lib/images/person.jpg'},
    {'name': 'Ben', 'image': 'lib/images/person.jpg'},
    {'name': 'Bryan', 'image': 'lib/images/person.jpg'},
    {'name': 'Brianna', 'image': 'lib/images/person.jpg'},
    {'name': 'Cindy', 'image': 'lib/images/person.jpg'},
    {'name': 'Daisy', 'image': 'lib/images/person.jpg'},
    {'name': 'Diana', 'image': 'lib/images/person.jpg'},
    {'name': 'Ethan', 'image': 'lib/images/person.jpg'},
    {'name': 'Ella', 'image': 'lib/images/person.jpg'},
    {'name': 'Frank', 'image': 'lib/images/person.jpg'},
    {'name': 'Fiona', 'image': 'lib/images/person.jpg'},
    {'name': 'George', 'image': 'lib/images/person.jpg'},
    {'name': 'Hannah', 'image': 'lib/images/person.jpg'},
    {'name': 'Irene', 'image': 'lib/images/person.jpg'},
    {'name': 'Jack', 'image': 'lib/images/person.jpg'},
    {'name': 'Karen', 'image': 'lib/images/person.jpg'},
    {'name': 'Liam', 'image': 'lib/images/person.jpg'},
    {'name': 'Monica', 'image': 'lib/images/person.jpg'},
    {'name': 'Nathan', 'image': 'lib/images/person.jpg'},
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredContacts = allContacts
        .where((contact) =>
            contact['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
      ..sort((a, b) => a['name']!.compareTo(b['name']!));

    List<Widget> contactTiles = [];
    String? lastLetter;

    for (int i = 0; i < filteredContacts.length; i++) {
      final contact = filteredContacts[i];
      final String name = contact['name']!;
      final String imagePath = contact['image']!;
      final String firstLetter = name[0].toUpperCase();

      if (firstLetter != lastLetter) {
        // New section with letter + contact
        contactTiles.add(
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfile(
                    name: name,
                    imagePath: imagePath,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      firstLetter,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(imagePath),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        contactTiles.add(
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfile(
                    name: name,
                    imagePath: imagePath,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 64, top: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(imagePath),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      lastLetter = firstLetter;
    }

    return Column(
      children: [
        const SizedBox(height: 20),

        // AppBar Action
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Title aligned left
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 4, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Contacts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        ),

        // Search Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
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

        // Contacts list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: contactTiles,
          ),
        ),
      ],
    );
  }
}
