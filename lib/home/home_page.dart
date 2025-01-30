import 'package:flutter/material.dart';
import 'package:flutter_kit/home/home_page_view_model.dart';
import 'package:flutter_kit/user_service.dart';
import 'package:flutter_kit/utils/locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageViewModel homePageViewModel = HomePageViewModel(
    userService: locator<UserService>(),
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
