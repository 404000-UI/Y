import 'package:flutter_riverpod/flutter_riverpod.dart';

final userEmailProvider = NotifierProvider<UserEmailState, String>(
  UserEmailState.new,
);

class UserEmailState extends Notifier<String> {
  final String initialEmail;

  UserEmailState([this.initialEmail = ""]) {
    state = initialEmail;
  }

  @override
  String build() {
    return state;
  }

  void setUserCredential(String email) {
    state = email;
  }
}
