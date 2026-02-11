import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:y/main.dart';

class Home extends ConsumerStatefulWidget {
  final String userEmail;

  const Home({super.key, required this.userEmail});

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Y",
          style: TextStyle(
            fontFamily: "Outline",
            fontWeight: FontWeight.w900,
            fontSize: 40,
          ),
        ),
      ),
      body: Center(child: Text(userEmail!)),
    );
  }
}
