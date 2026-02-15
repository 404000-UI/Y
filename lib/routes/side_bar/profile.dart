import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:y/main.dart';
import 'package:y/routes/edit_profile.dart';
import 'package:y/service/firestore.dart';
import 'package:y/states/user_credential.dart';

import '../../components/post_card.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

final profileDataProvider = FutureProvider((ref) async {
  final String userEmail = ref.watch(userEmailProvider);

  final List<Map<String, dynamic>> posts = await FirestoreService().getOwnPosts(
    userEmail,
  );
  final String userId = await FirestoreService().getUserId(userEmail);

  return {
    "posts": posts,
    "userEmail": userEmail.toString(),
    "userId": userId.toString(),
  };
});

class _ProfileState extends ConsumerState<Profile> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(profileDataProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileDataProvider);

    return profile.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Error $e"),
      data: (data) {
        final posts = data["posts"] as List<Map<String, dynamic>>;
        final userEmail = data["userEmail"] as String;
        final userId = data["userId"] as String;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              userId,
              style: TextStyle(color: Colors.white, fontFamily: "Outline"),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: _TopPortion(userId: userId, userEmail: userEmail),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 30,
                            ),
                            child: Text(
                              userEmail,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _ProfileInfoRow(postsLength: posts.length),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 18),
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final item = posts[index];
                            return CardComponent(
                              author: item["author"],
                              userEmail: userEmail.toString(),
                              content: item["content"],
                              likes: item["likes"],
                              commentsLength: item["commentsLength"],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.postsLength});

  final int postsLength;

  @override
  Widget build(BuildContext context) {
    final List<ProfileInfoItem> items = [
      ProfileInfoItem("Posts", postsLength),
      ProfileInfoItem("Followers", 0),
      ProfileInfoItem("Following", 0),
    ];

    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map(
              (item) => Expanded(
                child: Row(
                  children: [
                    if (items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item.value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      Text(item.title, style: TextStyle(color: Colors.white)),
    ],
  );
}

class ProfileInfoItem {
  final String title;
  final int value;

  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({required this.userId, required this.userEmail});

  final String userId;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://instagram.fcjb3-4.fna.fbcdn.net/v/t51.2885-19/573323465_1219825463302212_7278921664109726296_n.png?stp=dst-jpg_e0_s150x150_tt6&efg=eyJ2ZW5jb2RlX3RhZyI6InByb2ZpbGVfcGljLmRqYW5nby4xNTAuYzIifQ&_nc_ht=instagram.fcjb3-4.fna.fbcdn.net&_nc_cat=1&_nc_oc=Q6cZ2QGX02fFJTdwbbvBKbEKS77DngHfHuCrImm-xUd59mcvdgLzCKpkYHcgjztJ_q2HZ0A5t_-baN0F1zDqOtWmKJK8&_nc_ohc=eQeo-gpIgOcQ7kNvwHQCPUf&_nc_gid=FzsCDXqO-NILVLqeU84puQ&edm=AL4D0a4BAAAA&ccb=7-5&ig_cache_key=YW5vbnltb3VzX3Byb2ZpbGVfcGlj.3-ccb7-5&oh=00_AftfRPVAm-z3MIkb2n7UFDHLSIzryPXPZwVhZaFn5zcMZA&oe=699737EA&_nc_sid=9e8221',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfile(userId: userId, userEmail: userEmail),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                side: BorderSide(color: Colors.white),
              ),
              child: Text(
                "Edit profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
