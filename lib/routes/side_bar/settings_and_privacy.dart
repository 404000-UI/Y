import 'package:flutter/material.dart';

class SettingsAndPrivacy extends StatelessWidget {
  const SettingsAndPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Center(child: Text("SettingsAndPrivacy", style: TextStyle(color: Colors.white),)),
    );
  }
}
