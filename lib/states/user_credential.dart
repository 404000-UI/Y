import 'package:flutter_riverpod/flutter_riverpod.dart';

final userEmailProvider =
    NotifierProvider<UserEmailState, String>(
      UserEmailState.new,
    );

class UserEmailState extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void setUserCredential(String email) {
    state = email;
  }
}
