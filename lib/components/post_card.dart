import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:y/main.dart';
import 'package:y/routes/edit_tweet.dart';
import 'package:y/routes/home.dart';
import 'package:y/service/firestore.dart';

class CardComponent extends ConsumerStatefulWidget {
  const CardComponent({
    super.key,
    required this.author,
    required this.userEmail,
    required this.content,
    required this.likes,
    required this.commentsLength,
    this.deleteCallback,
  });

  final String author;
  final String userEmail;
  final String content;
  final int likes;
  final int commentsLength;
  final Function? deleteCallback;

  @override
  ConsumerState createState() => _CardComponentState();
}

enum MenuType { Edit, Delete }

class _CardComponentState extends ConsumerState<CardComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(child: Icon(Icons.person)),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.author,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  widget.content,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.favorite_border_outlined, size: 24),
                    ),
                    SizedBox(width: 4),
                    Text("${widget.likes}"),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.mode_comment_outlined),
                    ),
                    SizedBox(width: 4),
                    Text("${widget.commentsLength}"),
                  ],
                ),
              ],
            ),
            Spacer(),
            userEmail == widget.author
                ? PopupMenuButton<MenuType>(
                    onSelected: (MenuType result) async {
                      if (result.name.toString() == "Edit") {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                EditTweet(content: widget.content),
                          ),
                          (route) => false,
                        );
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Are you sure?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FirestoreService().deleteContent(
                                      userEmail.toString(),
                                      widget.content,
                                    );
                                    Duration(seconds: 1);
                                    if (!context.mounted) return;
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => Home(
                                          userEmail: userEmail.toString(),
                                        ),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (BuildContext buildContext) {
                      return [
                        for (final value in MenuType.values)
                          PopupMenuItem(
                            value: value,
                            child: Text(value.name.toString()),
                          ),
                      ];
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
