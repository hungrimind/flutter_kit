import 'package:flutter/material.dart';
import 'package:flutter_kit/auth/create_account/create_view_model.dart';
import 'package:flutter_kit/auth/user_service.dart';
import 'package:flutter_kit/core/ui/buttons/primary_button.dart';
import 'package:flutter_kit/core/utils/locator.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late final CreateAccountViewModel createAccountViewModel;
  late final UserService userService = locator.get<UserService>();
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    createAccountViewModel = CreateAccountViewModel(userService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: Container(
          padding: const EdgeInsets.all(16),
          height: kToolbarHeight,
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/logo-dark.png'
                : 'assets/logo.png',
          ),
        ),
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: userService.userNotifier,
          builder: (context, user, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 32.0,
                          top: MediaQuery.of(context).size.height * 0.1),
                      child: Text(
                        'Create Your Account',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Create Account',
                      width: double.infinity,
                      onPressed: () async {
                        createAccountViewModel.createUser(nameController.text);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
