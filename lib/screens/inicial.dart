import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class Inicial extends StatefulWidget {
  const Inicial({super.key});

  @override
  _InicialState createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber,
            border: Border.all(color: Colors.orange, width: 5),
          ),
          child: Center(
            child: Icon(
              Icons.attach_money,
              size: 50,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}