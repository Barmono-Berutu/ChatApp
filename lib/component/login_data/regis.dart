import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisPage extends StatelessWidget {
  final void Function()? onPressed;
  RegisPage({super.key, required this.onPressed});

  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _passK = TextEditingController();

  void regis() async {
    if (_pass.text == _passK.text) {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _username.text, password: _pass.text);

      FirebaseFirestore.instance
          .collection("UserEmail")
          .doc(userCredential.user?.uid)
          .set({'email': _username.text, 'id': userCredential.user?.uid});
    }
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
                  regis();
                },
                obscureText: false,
                decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black))),
              ),
              TextField(
                controller: _pass,
                onSubmitted: (_) {
                  regis();
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black))),
              ),
              TextField(
                controller: _passK,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Konfirmasi Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black))),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 20)),
                  onPressed: regis,
                  child: Text("Registrasi")),
              Row(
                children: [
                  Text("Sudah Memiliki Akun ?"),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(onPressed: onPressed, child: Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
