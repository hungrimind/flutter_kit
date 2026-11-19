# Send Internal Notification

Internal notifications are used to notify a user of an action that has been taken while they are within the app experience.

The reason for this is to give the simplest surface area for how to handle tasks such as showing toasts easily from anywhere in the app.

## Supported Notifications

- [Toast](#toast)
- [Haptic Feedback](#haptic-feedback)

## How to use

To use the notification system, inject the `NotifyService` class and call the associated function for the notification you want to show.

```dart
// notify_usage_example.dart
class _MyViewState extends State<MyView> {
  final MyViewModel _viewModel = MyViewModel(notifyService: locator<NotifyService>());

  // .. build method etc ..
}

class MyViewModel {
  MyViewModel({required NotifyService notifyService}) : _notifyService = notifyService;

  final NotifyService _notifyService;

  void doSomething() {
    // some code for some specific action
    _notifyService.setToastEvent(
      ToastEventSuccess(message: "Hello, world!"),
    );
  }
}
```

## How it works

The `NotifyService` holds a state of the current notification events using `ValueNotifier`s. We have an overlay widget that wraps the entire app and listens to these notifiers.

When a new notification event is emitted, the overlay initiates the notification and automatically dismisses it after a short delay.

## Toast

A toast serves the same purpose as a snackbar: it displays a message to the user. The reason we implemented our own notification system is because snackbars are tightly coupled to `BuildContext` and the current screen.

```dart
_notifyService.setToastEvent(
  ToastEventSuccess(message: "Hello, world!"),
);
```

### Toast Events

- `ToastEventSuccess` - A success message.
- `ToastEventError` - An error message.
- `ToastEventWarning` - A warning message.
- `ToastEventInfo` - An info message.

## Haptic Feedback

By building our own system, we can trigger messages and haptic feedback from anywhere in the app, even from services or view models that don't have access to context.

```dart
_notifyService.setHapticFeedbackEvent(HapticFeedbackEvent.success);
```

### Haptic Feedback Events

- `HapticFeedbackEvent.lightImpact` - Provides light haptic feedback
- `HapticFeedbackEvent.mediumImpact` - Provides medium haptic feedback
- `HapticFeedbackEvent.heavyImpact` - Provides heavy haptic feedback
- `HapticFeedbackEvent.selectionClick` - Provides selection click haptic feedback
- `HapticFeedbackEvent.success` - Provides success haptic feedback (uses medium impact).
- `HapticFeedbackEvent.error` - Provides error haptic feedback (uses heavy impact).
- `HapticFeedbackEvent.warning` - Provides warning haptic feedback (uses light impact).
