import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onPressed;
  LoginPage({super.key, required this.onPressed});

  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  void Login() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _username.text, password: _pass.text);
    FirebaseFirestore.instance
        .collection("UserEmail")
        .doc(userCredential.user?.uid)
        .set({'email': _username.text, 'id': userCredential.user?.uid},
            SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: _username,
                onSubmitted: (_) {
                  Login();
                },
                obscureText: false,
                decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black))),
              ),
              TextField(
                onSubmitted: (_) {
                  Login();
                },
                controller: _pass,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black))),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 20)),
                  onPressed: Login,
                  child: Text("Login")),
              Row(
                children: [
                  Text("Belum Punya Akun ?"),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(onPressed: onPressed, child: Text("Register"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
