import 'package:flutter/material.dart';
import 'package:y/main.dart';
import 'package:y/routes/home.dart';
import 'package:y/service/firestore.dart';

class PostTweets extends StatefulWidget {
  const PostTweets({super.key});

  @override
  State<PostTweets> createState() => _PostTweetsState();
}

class _PostTweetsState extends State<PostTweets> {
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
              child: TextButton(
                onPressed: () {},
                child: Text("Cancel", style: TextStyle(color: Colors.blue)),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
              child: ElevatedButton(
                onPressed: () {
                  FirestoreService().setDateAtPostCollection(
                    userEmail.toString(),
                    userInput,
                  );
                  _controller.clear();
                  Navigator.of(context).pop(
                    MaterialPageRoute(
                      builder: (context) =>
                          Home(userEmail: userEmail.toString()),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Click a Refresh Button")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _btnEnabled ? Colors.blue : Colors.blueGrey,
                ),
                child: Text("Post", style: TextStyle(color: Colors.white)),
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
            hintText: "What's happening?",
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
