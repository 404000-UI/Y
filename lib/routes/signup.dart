import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:y/assets/icons/custom_icons_icons.dart';
import 'package:y/routes/home.dart';
import 'package:y/routes/manually_login.dart';
import 'package:y/service/github_login.dart';
import 'package:y/routes/manually_signup.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  void _showSnackBar(
    BuildContext context, {
    required String message,
    SnackBarBehavior behavior = SnackBarBehavior.fixed,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: behavior,
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool _isLoading = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset("lib/assets/icons/icon.png", width: 56, height: 56),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "지금 세계에서 무슨 일이",
                    style: TextStyle(
                      fontSize: width * 0.08,
                      color: Colors.white54,
                      fontFamily: "Surround",
                    ),
                  ),
                  Text(
                    "일어나고 있는지 알아보",
                    style: TextStyle(
                      fontSize: width * 0.08,
                      color: Colors.white54,
                      fontFamily: "Surround",
                    ),
                  ),
                  Text(
                    "세요.",
                    style: TextStyle(
                      fontSize: width * 0.08,
                      color: Colors.white54,
                      fontFamily: "Surround",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.8,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              final user = await signInWithGitHub();
                              if (!context.mounted) return;
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Home(
                                    userEmail: user.user!.email.toString(),
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              _showSnackBar(
                                context,
                                message: e.toString(),
                                duration: const Duration(seconds: 2),
                              );
                              return;
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CustomIcons.github, color: Colors.black),
                        SizedBox(width: width * 0.03),
                        Text(
                          "Github로 계속하기",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey),
                      width: width * 0.3,
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("또는", style: TextStyle(color: Colors.grey)),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey),
                      width: width * 0.3,
                      height: 1,
                    ),
                  ],
                ),
                SizedBox(
                  width: width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => ManuallySignUp(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("계정 만들기", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "가입하면 트위터의 ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "이용약관, 개인정보 처리방침, 쿠키 사용",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      Text("에 동의하게 됩니다.", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      children: [
                        Text(
                          "이미 계정이 있으신가요? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ManuallyLogin(),
                              ),
                            );
                          },
                          child: Text(
                            "로그인하기",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
