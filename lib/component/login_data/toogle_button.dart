import 'package:chat_app/component/login_data/login_page.dart';
import 'package:chat_app/component/login_data/regis.dart';
import 'package:flutter/material.dart';

class ToogleButton extends StatefulWidget {
  const ToogleButton({super.key});

  @override
  State<ToogleButton> createState() => _ToogleButtonState();
}

class _ToogleButtonState extends State<ToogleButton> {
  bool isLogin = true;

  void Button() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPage(
        onPressed: Button,
      );
    } else {
      return RegisPage(
        onPressed: Button,
      );
    }
  }
}
