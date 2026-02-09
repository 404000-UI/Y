import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userCredentialProvider =
    NotifierProvider<UserCredentialState, UserCredential?>(
      UserCredentialState.new,
    );

class UserCredentialState extends Notifier<UserCredential?> {
  @override
  UserCredential? build() {
    return null;
  }

  void setUserCredential(UserCredential userCredential) {
    state = userCredential;
  }
}
