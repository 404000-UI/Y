import 'package:flutter/material.dart';

class PostComponent extends StatelessWidget {
  const PostComponent({super.key});

  @override
  Widget build(BuildContext context) {
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
            Expanded(child: TabBarView(children: [_ForYou(), _Following()])),
          ],
        ),
      ),
    );
  }
}

class _ForYou extends StatefulWidget {
  const _ForYou({super.key});

  @override
  State<_ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<_ForYou> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 18),
      child: ListView(
        children: [
          _CardComponent(
            author: "minkwan",
            content: "Hi",
            likes: 3,
            commentsLength: 5,
          ),
        ],
      ),
    );
  }
}

class _CardComponent extends StatefulWidget {
  const _CardComponent({
    super.key,
    required this.author,
    required this.content,
    required this.likes,
    required this.commentsLength,
  });

  final String author;
  final String content;
  final int likes;
  final int commentsLength;

  @override
  State<_CardComponent> createState() => _CardComponentState();
}

class _CardComponentState extends State<_CardComponent> {
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
            Icon(Icons.more_vert),
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
