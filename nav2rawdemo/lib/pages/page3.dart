import 'package:flutter/material.dart';
import '../core/navigation/app_router.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    final router = Router.of(context).routerDelegate as AppRouter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 3'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Page 3', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => router.navigateTo(AppRoute.home),
              child: const Text('Go back to Home'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  () => router.navigateTo(
                    AppRoute.page3WithId,
                    params: {'id': '456'},
                  ),
              child: const Text('Go to Page 3 with ID 456'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page3WithId extends StatelessWidget {
  final String id;

  const Page3WithId({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final router = Router.of(context).routerDelegate as AppRouter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 3 with ID'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is Page 3 with ID: $id',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => router.navigateTo(AppRoute.page3),
              child: const Text('Go back to Page 3'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => router.navigateTo(AppRoute.home),
              child: const Text('Go back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
