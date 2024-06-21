import 'package:chat_app/component/addChat.dart';
import 'package:chat_app/component/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  String capitalize(String s) {
    if (s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: Text("Chat App"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          Menu()
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.person_add_alt_1,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF00BF6D),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddChat(),
            ));
          }),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot?>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .where('participants', arrayContains: currentUserEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No Chats Yet"));
            }

            List<DocumentSnapshot> chats = snapshot.data!.docs;

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    chats[index].data() as Map<String, dynamic>;
                String peerEmail = (data['participants'] as List<dynamic>)
                    .firstWhere((email) => email != currentUserEmail);

                return ListTile(
                  subtitle: Text(data["lastMessage"]),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage("lib/images/user.png"),
                  ),
                  title: Text(capitalize(peerEmail.split('@')[0])),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatPage(peerEmail: peerEmail),
                    ));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      fixedColor: Color(0xFF00BF6D),
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("lib/images/user.png"),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  Widget Menu() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Logout"),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        )
      ],
    );
  }
}
