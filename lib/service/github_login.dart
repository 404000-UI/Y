import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> signInWithGitHub() async {
  // Create a new provider
  GithubAuthProvider githubProvider = GithubAuthProvider();

  return await FirebaseAuth.instance.signInWithProvider(githubProvider);
}
