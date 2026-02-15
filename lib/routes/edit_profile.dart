import 'package:flutter/material.dart';
import 'package:y/main.dart';
import 'package:y/routes/home.dart';
import 'package:y/service/firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.userId, required this.userEmail});

  final String userId;
  final String userEmail;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _btnEnabled = false;
  late String userInput;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
              child: ElevatedButton(
                onPressed: () async {
                  FirestoreService().upsertUserId(widget.userEmail, userInput);
                  _controller.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          Home(userEmail: userEmail.toString()),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _btnEnabled ? Colors.blue : Colors.blueGrey,
                ),
                child: Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _btnEnabled = true;
              });
            } else {
              setState(() {
                _btnEnabled = false;
              });
            }
            userInput = value;
          },
          expands: true,
          maxLines: null,
          keyboardType: TextInputType.text,
          maxLength: 50,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(fontSize: 28, color: Colors.white),
          decoration: InputDecoration(
            hintText: widget.userId,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 28),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
