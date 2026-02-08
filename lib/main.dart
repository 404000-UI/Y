import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:y/routes/home.dart';
import 'package:y/routes/signup.dart';

final bool isLogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: isLogin ? Home() : Signup(),
    );
  }
}
