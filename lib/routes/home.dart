import 'package:flutter/material.dart';
import 'package:y/components/mail.dart';
import 'package:y/components/notification.dart';
import 'package:y/components/post.dart';
import 'package:y/components/search.dart';
import 'package:y/main.dart';
import 'package:y/routes/post_tweets.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final _bodyComponents = [
    PostComponent(userEmail: userEmail.toString()),
    SearchComponent(),
    Container(),
    NotificationComponent(),
    MailComponent(),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: isLargeScreen
            ? null
            : Padding(
                padding: EdgeInsetsGeometry.fromLTRB(10, 0, 0, 0),
                child: IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "       Y",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Outline",
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                ),
              ),
              if (isLargeScreen) Expanded(child: _navBarItems()),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: OutlinedButton(
              onPressed: () {},
              child: const Text(
                'Subscribe',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      drawer: isLargeScreen ? null : _drawer(),
      body: _bodyComponents[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Home(userEmail: userEmail.toString()),
                  ),
                  (route) => false,
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(Icons.restart_alt_outlined),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: _bottomNavBarItems,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => PostTweets()));
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  final _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined, color: Colors.white),
      label: "",
      activeIcon: Icon(Icons.home, color: Colors.white),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search_outlined, color: Colors.white),
      label: "",
      activeIcon: Icon(Icons.saved_search, color: Colors.white),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_circle_outlined, color: Colors.white),
      label: "",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications_none_outlined, color: Colors.white),
      label: "",
      activeIcon: Icon(Icons.notifications, color: Colors.white),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mail_outline_outlined, color: Colors.white),
      label: "",
      activeIcon: Icon(Icons.mail, color: Colors.white),
    ),
  ];

  Widget _drawer() => Drawer(
    backgroundColor: Colors.black,
    child: ListView(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.white, size: 40.0),
              Icon(Icons.add_circle_outline, color: Colors.white),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 18, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userEmail.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "@$userEmail",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      " Following",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      " Follower",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ..._menuItems.map(
          (item) => ListTile(
            onTap: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            title: item,
          ),
        ),
      ],
    ),
  );

  final List<Row> _menuItems = <Row>[
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.person_outline_rounded,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Profile',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.person_add_alt_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Follow',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            "Y",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Outline",
              fontWeight: FontWeight.w900,
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 9),
          child: Text(
            'Premium',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.list_alt_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Lists',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.people_alt_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Communities',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.bookmark_outline_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Bookmarks',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.science_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Creator Studio',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.flash_on_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Business',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Ads',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.settings_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Settings and privacy',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Icon(
            Icons.logout_outlined,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: Text(
            'Log out',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  ];

  Widget _navBarItems() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: _menuItems
        .map(
          (item) => InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16,
              ),
              child: item,
              // Text(
              //   item,
              //   style: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w900,
              //     color: Colors.white,
              //   ),
              // ),
            ),
          ),
        )
        .toList(),
  );
}
