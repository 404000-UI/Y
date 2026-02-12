import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:y/main.dart';
import 'package:y/routes/edit_tweet.dart';
import 'package:y/service/firestore.dart';
import 'package:y/states/user_credential.dart';

late List<Map<String, dynamic>> data;

class PostComponent extends StatefulWidget {
  const PostComponent({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  bool isLoading = true;

  Future<void> _init() async {
    data = await FirestoreService().getAllPosts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(0, 8, 0, 0),
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: "For you"),
                Tab(text: "Following"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ForYou(userEmail: userEmail.toString()),
                  _Following(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForYou extends StatefulWidget {
  const _ForYou({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<_ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<_ForYou> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 18),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return _CardComponent(
            author: item["author"],
            userEmail: userEmail.toString(),
            content: item["content"],
            likes: item["likes"],
            commentsLength: item["commentsLength"],
          );
        },
      ),
    );
  }
}

class _CardComponent extends ConsumerStatefulWidget {
  const _CardComponent({
    super.key,
    required this.author,
    required this.userEmail,
    required this.content,
    required this.likes,
    required this.commentsLength,
  });

  final String author;
  final String userEmail;
  final String content;
  final int likes;
  final int commentsLength;

  @override
  ConsumerState createState() => __CardComponentState();
}

enum MenuType { Edit, Delete }

class __CardComponentState extends ConsumerState<_CardComponent> {
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EditTweet(content: widget.content),
                          ),
                        );
                      } else {
                        final result = await showDialog(
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
                                  onPressed: () {
                                    FirestoreService().deleteContent(
                                      userEmail.toString(),
                                      widget.content,
                                    );
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Click a Refresh Button"),
                                      ),
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
                        if (result == true) {
                          print('사용자가 확인 클릭');
                          // 여기서 Firestore 삭제 등 작업 가능
                        } else {
                          print('사용자가 취소 클릭');
                        }
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

class _Following extends StatefulWidget {
  const _Following({super.key});

  @override
  State<_Following> createState() => _FollowingState();
}

class _FollowingState extends State<_Following> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Following", style: TextStyle(color: Colors.white)),
    );
    ;
  }
}
