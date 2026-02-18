import 'package:flutter/material.dart';

class CreatorStudio extends StatelessWidget {
  const CreatorStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Center(child: Text("CreatorStudio", style: TextStyle(color: Colors.white),)),
    );
  }
}
