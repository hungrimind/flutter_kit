import 'package:flutter/material.dart';
import 'package:flutter_kit/auth/user_service.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/home/home_page_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageViewModel homePageViewModel = HomePageViewModel(
    userService: locator.get<UserService>(),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: homePageViewModel.userNotifier,
      builder: (context, user, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    homePageViewModel.signOut();
                  },
                  child: const Text("Sign Out"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
