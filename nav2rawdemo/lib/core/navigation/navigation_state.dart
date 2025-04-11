import 'package:flutter/foundation.dart'; // For ValueNotifier

// Represents the different logical routes/states in our app
enum AppRoute { home, books, bookDetails, settings, unknown }

// Holds the current navigation state
@immutable // Good practice for state objects
class NavigationState {
  final AppRoute currentRoute;
  final String? selectedBookId; // For routes like /books/:id
  final bool isUnknown; // Flag for 404 routes

  // Constructor for a known route
  const NavigationState({required this.currentRoute, this.selectedBookId})
    : isUnknown = false;

  // Constructor for an unknown route
  const NavigationState.unknown()
    : currentRoute = AppRoute.unknown,
      selectedBookId = null,
      isUnknown = true;

  // Initial state
  const NavigationState.initial()
    : currentRoute = AppRoute.home,
      selectedBookId = null,
      isUnknown = false;

  // Helper for creating copies with modifications
  NavigationState copyWith({
    AppRoute? currentRoute,
    String? selectedBookId, // Allow clearing the book ID
    bool? clearSelectedBookId, // Explicit flag to clear bookId
    bool? isUnknown,
  }) {
    final bool finalIsUnknown = isUnknown ?? this.isUnknown;
    if (finalIsUnknown) {
      return const NavigationState.unknown();
    }

    final String? finalSelectedBookId =
        (clearSelectedBookId ?? false)
            ? null
            : (selectedBookId ?? this.selectedBookId);

    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      selectedBookId: finalSelectedBookId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationState &&
          runtimeType == other.runtimeType &&
          currentRoute == other.currentRoute &&
          selectedBookId == other.selectedBookId &&
          isUnknown == other.isUnknown;

  @override
  int get hashCode =>
      currentRoute.hashCode ^ selectedBookId.hashCode ^ isUnknown.hashCode;

  @override
  String toString() {
    return 'NavigationState(currentRoute: $currentRoute, selectedBookId: $selectedBookId, isUnknown: $isUnknown)';
  }
}
