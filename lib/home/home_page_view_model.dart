import 'package:flutter/material.dart';
import 'package:flutter_kit/auth/user.dart';
import 'package:flutter_kit/auth/user_service.dart';

class HomePageViewModel {
  HomePageViewModel({required UserService userService})
      : _userService = userService;

  final UserService _userService;

  ValueNotifier<User?> get userNotifier => _userService.userNotifier;

  void signOut() {
    _userService.endSession();
  }
}
