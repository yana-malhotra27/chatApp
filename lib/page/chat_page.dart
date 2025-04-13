import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
  final String recieverUsername;

  ChatPage({
    super.key,
    required this.recieverEmail,
    required this.recieverID,
    required this.recieverUsername,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  final FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  String _searchQuery = "";

  late final String senderID;

  @override
  void initState() {
    super.initState();

    senderID = _authService.currentUser?.uid ?? '';

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), scrollDown);
      }
    });

    Future.delayed(const Duration(milliseconds: 500), scrollDown);
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      await _chatService.sendMessages(widget.recieverID, text);
      _messageController.clear();
      scrollDown();
    }
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
                decoration: const InputDecoration(
                  hintText: "Search messages...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(
                widget.recieverUsername,
                style: TextStyle(fontWeight: FontWeight.bold),
              ), // Change this line to use username
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {}, // Call feature
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
            onPressed: () {}, // More options
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
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Error"));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;

        if (_searchQuery.isNotEmpty) {
          messages = messages.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data["message"]
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          }).toList();
        }

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          children: messages.map(_buildMessageItem).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final bool isCurrentUser = data['senderID'] == senderID;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Camera Icon
          IconButton(
            onPressed: () {}, // Camera feature
            icon: Icon(
              Icons.camera_alt,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // Gallery Icon
          IconButton(
            onPressed: () {}, // Gallery feature
            icon: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // Built-in TextField
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer, // Background color
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: myFocusNode,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Send Button
          Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
