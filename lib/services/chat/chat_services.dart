import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Stream
  // Fetches a real-time stream of users from the Users collection in Firestore.
  Stream<List<Map<String, dynamic>>> getUserStream() {
    // List of maps where each contains user email, uid, etc.
    return _firestore.collection("Users").snapshots().map((snapshot) {
      // Uses snapshots() to listen for real-time updates.
      return snapshot.docs.map((doc) {
        // Maps each document in the Users collection to a user map.
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Send Message
  // Sends a message and saves it in the appropriate chat room.
  Future<void> sendMessages(String recieverId, message) async {
    // Fetches the sender's ID and email from Firebase Auth.
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Uses the Message model to structure the message data.
    Message newMessage = Message(
      senderId: currentUserID,
      senderEmail: currentUserEmail,
      recieverId: recieverId,
      message: message,
      timestamp: timestamp,
    );

    // Combines and sorts the sender's and receiver's IDs to create a unique chat room ID.
    List<String> ids = [currentUserID, recieverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Adds the message to the messages subcollection under the chat_rooms document.
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get Messages
  // Returns a stream that updates whenever new messages are added.
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Delete Conversation
  // Deletes all messages from the conversation between the current user and another user.
  Future<void> deleteConversation(String otherUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // Generate the same chat room ID used for storing messages
    List<String> ids = [currentUser.uid, otherUserId];
    ids.sort();
    String chatRoomID = ids.join('_');

    final chatRef = _firestore.collection("chat_rooms").doc(chatRoomID);

    // Get all message documents in the conversation
    final messages = await chatRef.collection('messages').get();

    // Delete each message
    for (var doc in messages.docs) {
      await doc.reference.delete();
    }

    // Optionally delete the empty chat room document
    await chatRef.delete();
  }
}
