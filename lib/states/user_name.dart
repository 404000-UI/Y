import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNameProvider = NotifierProvider<UserName, String>(UserName.new);

class UserName extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void setUserName(String userName) {
    state = userName;
  }
}
