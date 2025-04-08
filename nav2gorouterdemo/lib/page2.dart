import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Page 2', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go back to Home'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/page2/details'),
              child: const Text('Go to Page 2 Details'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2Details extends StatelessWidget {
  const Page2Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2 Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is Page 2 Details (Nested Route)',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/page2'),
              child: const Text('Go back to Page 2'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
