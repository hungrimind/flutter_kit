import 'package:flutter/material.dart';
import 'package:flutter_kit/user.dart';
import 'package:flutter_kit/user_service.dart';

class LoginViewModel {
  LoginViewModel({required UserService userService})
      : _userService = userService;

  final UserService _userService;

  ValueNotifier<User?> get userNotifier => _userService.userNotifier;

  void login(String name) {
    _userService.createSession(name);
  }
}
