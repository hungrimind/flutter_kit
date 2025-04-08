import 'package:flutter/material.dart';
import '../core/navigation/app_router.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final router = Router.of(context).routerDelegate as AppRouter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1 - Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Page 1 (Home)', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => router.navigateTo(AppRoute.page2),
              child: const Text('Go to Page 2'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => router.navigateTo(AppRoute.page3),
              child: const Text('Go to Page 3'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  () => router.navigateTo(
                    AppRoute.page3WithId,
                    params: {'id': '123'},
                  ),
              child: const Text('Go to Page 3 with ID'),
            ),
          ],
        ),
      ),
    );
  }
}
