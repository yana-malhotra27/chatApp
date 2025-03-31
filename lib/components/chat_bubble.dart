import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        // Show profile image only for receiver messages
        if (!isCurrentUser)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8.0), // Added left padding
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent, // Removes blue background
              backgroundImage: AssetImage("lib/images/person.jpg"),
            ),
          ),

        // Message bubble
        Container(
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}