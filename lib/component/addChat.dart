import 'package:chat_app/component/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddChat extends StatelessWidget {
  const AddChat({super.key});

  String capitalize(String s) {
    if (s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: Text("Add Chat "),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot?>(
          stream:
              FirebaseFirestore.instance.collection("UserEmail").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            List<DocumentSnapshot> users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    users[index].data() as Map<String, dynamic>;
                String email = data['email'] ?? 'No email found';

                if (email != FirebaseAuth.instance.currentUser?.email) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("lib/images/user.png"),
                    ),
                    title: Text(capitalize(email.split('@')[0])),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatPage(peerEmail: email),
                      ));
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
