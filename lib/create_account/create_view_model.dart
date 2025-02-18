import 'package:flutter/material.dart';
import 'package:flutter_kit/auth/user.dart';
import 'package:flutter_kit/auth/user_service.dart';

class CreateAccountViewModel {
  CreateAccountViewModel(UserService userService) : _userService = userService;

  final UserService _userService;

  late final ValueNotifier<User?> userNotifier = _userService.userNotifier;

  void createUser(String name) {
    _userService.createUser(name);
    _userService.createSession(name);
  }
}
