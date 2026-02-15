import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:y/components/post_card.dart';
import 'package:y/main.dart';
import 'package:y/routes/edit_tweet.dart';
import 'package:y/routes/home.dart';
import 'package:y/service/firestore.dart';

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
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Home(userEmail: userEmail.toString()),
          ),
          (route) => false,
        );
      },
      child: ListView.builder(
        padding: EdgeInsetsGeometry.symmetric(vertical: 18),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return CardComponent(
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
