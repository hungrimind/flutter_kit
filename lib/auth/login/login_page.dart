import 'package:flutter/material.dart';
import 'package:flutter_kit/auth/create_account/create_page.dart';
import 'package:flutter_kit/auth/user_service.dart';
import 'package:flutter_kit/core/ui/buttons/primary_button.dart';
import 'package:flutter_kit/core/ui/buttons/secondary_button.dart';
import 'package:flutter_kit/core/utils/locator.dart';

import 'login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginViewModel loginViewModel = LoginViewModel(
    userService: locator.get<UserService>(),
  );

  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
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
      body: Stack(
        children: [
          ShaderMask(
            blendMode: BlendMode.darken,
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.surface,
                ],
                stops: const [0.1, 0.91],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds);
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/texture.png'),
                  repeat: ImageRepeat.repeat,
                  opacity: 0.69,
                ), // DecorationImage
              ), // BoxDecoration ), //
            ),
          ),
          Center(
            child: ValueListenableBuilder(
              valueListenable: loginViewModel.userNotifier,
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
                            'Welcome',
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
                          text: 'Login',
                          width: double.infinity,
                          onPressed: () async {
                            try {
                              loginViewModel.login(nameController.text);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                        ),
                        SecondaryButton(
                          text: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                                TextSpan(
                                  text: "Sign up",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateAccountPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
