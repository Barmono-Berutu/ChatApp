import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("sadsad"),
        actions: [IconButton(onPressed: logOut, icon: Icon(Icons.logout))],
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

                if (email == FirebaseAuth.instance.currentUser?.email) {
                  return ListTile(
                    title: Text(email),
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
