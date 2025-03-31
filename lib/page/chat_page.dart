import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//View real-time chat messages exchanged with another user.
//Send new messages.
//Automatically scroll to the latest messages when typing or sending.
class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;

  ChatPage({
    super.key,
    required this.recieverEmail,
    required this.recieverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController =
      TextEditingController(); // Search input controller

  // Chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Focus for textfield
  FocusNode myFocusNode = FocusNode();
  bool _isSearching = false; // Track if the user is searching
  String _searchQuery = ""; // Store the search query

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessages(
          widget.recieverID, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search messages...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(widget.recieverEmail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0, // Prevents color change on scroll
        surfaceTintColor: Colors.transparent, // Ensures no background tint
        actions: [
          IconButton(
            onPressed: () {}, // Call functionality (not implemented yet)
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = "";
                  _searchController.clear();
                }
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
          IconButton(
            onPressed: () {}, // More options (not implemented yet)
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Text('Loading...');

        List<DocumentSnapshot> messages = snapshot.data!.docs;

        // Filter messages based on the search query
        if (_searchQuery.isNotEmpty) {
          messages = messages.where((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return data["message"]
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          }).toList();
        }

        return ListView(
          controller: _scrollController,
          children: messages.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 50.0, left: 10, right: 10), // Added left padding
      child: Row(
        children: [
          // Camera Icon
          IconButton(
            onPressed: () {}, // Currently does nothing
            icon: Icon(Icons.camera_alt,
                color: Theme.of(context).colorScheme.primary),
          ),

          // Image Icon
          IconButton(
            onPressed: () {}, // Currently does nothing
            icon:
                Icon(Icons.image, color: Theme.of(context).colorScheme.primary),
          ),

          // TextField with Expanded to take remaining space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // Send Button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 2),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.arrow_upward,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
