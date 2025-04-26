import 'package:flutter/material.dart';
import 'package:flutter_kit/home/home_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeView displays counter and handles button presses',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: HomeView()));

    // Assert - Initial state
    expect(find.text('0'), findsOneWidget);
    expect(find.text('You have pushed the button this many times:'),
        findsOneWidget);

    // Act - Increment counter
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Assert - Counter incremented
    expect(find.text('1'), findsOneWidget);

    // Act - Increment counter again
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Assert - Counter incremented to 2
    expect(find.text('2'), findsOneWidget);

    // Act - Reset counter
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Assert - Counter reset
    expect(find.text('0'), findsOneWidget);
  });
}
