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
  final SearchController searchController = SearchController();

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

      final contactWidget = InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserProfile(name: name, imagePath: imagePath),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(
              left: lastLetter != firstLetter ? 16 : 64, top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (lastLetter != firstLetter)
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
              if (lastLetter != firstLetter) const SizedBox(width: 24),
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(imagePath),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
      );

      contactTiles.add(contactWidget);
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
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Title aligned left
        Padding(
          padding: EdgeInsets.only(left: 16, top: 4, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Contacts',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        ),

        // Search Anchor

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SearchAnchor.bar(
            searchController: searchController,
            barHintText: "Search",
            viewHintText: "Search",
            barBackgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.outline.withOpacity(0.08),
            ),
            dividerColor: Theme.of(context).colorScheme.surface,
            barElevation: const WidgetStatePropertyAll(0),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              final filtered = allContacts
                  .where((contact) => contact['name']!
                      .toLowerCase()
                      .contains(controller.text.toLowerCase()))
                  .toList();

              return [
                // Horizontal scrollable avatars
                Material(
                  type: MaterialType.transparency,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: filtered.map((contact) {
                        return GestureDetector(
                          onTap: () {
                            controller.closeView(null);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfile(
                                  name: contact['name']!,
                                  imagePath: contact['image']!,
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
                                  backgroundImage:
                                      AssetImage(contact['image']!),
                                  radius: 28,
                                  backgroundColor: Colors.transparent,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  contact['name']!,
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

                // Optional: File categories
                ListTile(
                  leading: Icon(Icons.image,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(
                    'Photos',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.video_collection,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(
                    'Videos',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.headphones,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(
                    'Music',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.language,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(
                    'Links',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  onTap: () {},
                ),
              ];
            },
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
