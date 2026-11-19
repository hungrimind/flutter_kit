# Testing

## Overview

Testing is a crucial part of building robust and maintainable applications. The Flutter Kit is designed with testability in mind. This guide outlines our recommended approach, distinguishing between Unit and Widget tests based on a simple framework:

- **Unit Tests**: `input <-> output`
- **Widget Tests**: `action <-> result`

## Unit Testing (`input <-> output`)

Unit tests are best suited for testing isolated pieces of logic, particularly **pure functions** or methods with predictable inputs and outputs. They should be fast, self-contained, and have minimal dependencies. The goal is to verify that given a specific input, the function reliably produces the expected output.

**When to Use:**

- Utility or helper functions.
- Specific data transformation/validation logic that can be easily isolated.

**Example:**

Consider a simple utility function:

```dart
// lib/utils/validators.dart
bool isEmailValid(String email) {
  if (email.isEmpty) return false;
  // Basic check for demonstration
  return email.contains('@') && email.contains('.');
}
```

A unit test verifies its input/output behavior:

```dart
// test/utils/validators_test.dart
void main() {
  test('isEmailValid should return true for valid emails', () {
    expect(isEmailValid('test@example.com'), isTrue);
  });

  test('isEmailValid should return false for invalid emails', () {
    expect(isEmailValid('testexample.com'), isFalse);
    expect(isEmailValid('test@examplecom'), isFalse);
    expect(isEmailValid(''), isFalse);
  });
}
```

Complex classes with multiple dependencies (like full ViewModels or Services interacting with external systems) are generally better tested through Widget tests in this architecture, as isolating them for pure unit tests often requires excessive mocking.

## Widget Testing (`action <-> result`)

Widget tests are the primary way to test the functionality of your features. In the MVVM pattern used by the boilerplate, a View and its ViewModel are tightly coupled (1-to-1) and should be tested **together** as a single unit. The focus is on verifying that user **actions** lead to the expected **results** in the UI and state.

**When to Use:**

- Testing the behavior of a complete screen or component.
- Verifying UI rendering based on ViewModel state.
- Ensuring interactions (button taps, form submissions) trigger the correct logic in the ViewModel and update the UI accordingly.

**Example:**

Imagine a simple counter view/viewmodel:

```dart
// counter_viewmodel.dart
class CounterViewModel {
  final ValueNotifier<int> counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }

  void dispose() {
    counter.dispose();
  }
}
```

```dart
// counter_view.dart
class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late final CounterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CounterViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _viewModel.counter,
            builder: (context, value, _) {
              return Text('Counter: $value');
            },
          ),
          ElevatedButton(
            onPressed: _viewModel.incrementCounter,
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}
```

A widget test verifies the action-result flow:

```dart
// test/counter/counter_view_test.dart
void main() {
  testWidgets('CounterView increments counter when button is pressed', (WidgetTester tester) async {
    // Arrange: Pump the widget
    await tester.pumpWidget(MaterialApp(home: CounterView()));

    // Assert: Initial state (result)
    expect(find.text('Counter: 0'), findsOneWidget);

    // Act: Simulate user action (tap the button)
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild the widget tree

    // Assert: Final state (result after action)
    expect(find.text('Counter: 1'), findsOneWidget);
  });
}
```

Notice how we test the `CounterView` directly. The test verifies that the **action** (tapping the button) correctly interacts with the ViewModel logic (instantiated within the View's state) and produces the expected **result** (the text updates to 'Counter: 1'). This single test covers both the View's rendering and the ViewModel's core logic for this feature.

> [!NOTE]
>
> While Golden Tests and Integration Tests are also valuable, this guide focuses on the foundational unit (`input <-> output`) and widget (`action <-> result`) tests frequently used during development.
