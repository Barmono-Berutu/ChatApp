import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String peerEmail;
  final TextEditingController messageController = TextEditingController();

  ChatPage({super.key, required this.peerEmail});

  void sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    String chatId = _getChatId(currentUserEmail, peerEmail);

    messageController.clear();
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'sender': currentUserEmail,
      'receiver': peerEmail,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'participants': [currentUserEmail, peerEmail],
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  String _getChatId(String email1, String email2) {
    List<String> emails = [email1, email2];
    emails.sort();
    return emails.join('_');
  }

  @override
  Widget build(BuildContext context) {
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    String chatId = _getChatId(currentUserEmail, peerEmail);

    String capitalize(String s) {
      if (s.isEmpty) {
        return s;
      }
      return s[0].toUpperCase() + s.substring(1);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackButton(),
            const CircleAvatar(
              backgroundImage: AssetImage("lib/images/user.png"),
            ),
            const SizedBox(width: 20.0 * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  peerEmail,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Active 3m ago",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          const SizedBox(width: 20.0 / 2),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        messages[index].data() as Map<String, dynamic>;
                    bool isMe = data['sender'] == currentUserEmail;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Text(
                                  capitalize(
                                      data['sender'].toString().split('@')[0]),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Chip(
                                label: Text(
                                  data['message'],
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Mengatur warna teks menjadi putih
                                  ),
                                ),
                                backgroundColor: Color(0xFF00BF6D),
                                shape: const StadiumBorder(
                                  side: BorderSide(style: BorderStyle.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
