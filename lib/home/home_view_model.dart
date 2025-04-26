import 'package:flutter/foundation.dart';
import 'package:flutter_kit/core/http/http_abstraction.dart';
import 'package:flutter_kit/core/services/toast_service.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Manages the dog image gallery for the home screen
class HomeViewModel {
  final HttpAbstraction _http;
  final ToastService _toastService;

  HomeViewModel({
    required HttpAbstraction http,
  })  : _http = http,
        _toastService = locator.get<ToastService>();

  /// The current dog image URL as a ValueNotifier
  final ValueNotifier<String?> currentDogImageUrl =
      ValueNotifier<String?>(null);

  /// List of fetched dog images
  final ValueNotifier<List<String>> dogImageGallery =
      ValueNotifier<List<String>>([]);

  /// Loading state for dog image fetching
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// Error message if image fetching fails
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  void showToast(String message) {
    _toastService.show(message);
  }

  /// Fetches a random dog image from the Dog API
  Future<void> fetchRandomDogImage() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      // We'll use a direct http client as a fallback if the abstraction fails
      http.Response response;

      try {
        response = await _http
            .get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
      } catch (httpError) {
        // Fallback to direct HTTP call if abstraction fails
        debugPrint(
            'HTTP abstraction error: $httpError - falling back to direct http call');
        response = await http
            .get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Debug output for API response
        debugPrint('API Response: $data');

        if (data.containsKey('message') && data['message'] is String) {
          final String imageUrl = data['message'];
          debugPrint('Setting image URL: $imageUrl');

          // Add to gallery if it's not already there
          if (!dogImageGallery.value.contains(imageUrl)) {
            final updatedGallery = List<String>.from(dogImageGallery.value)
              ..add(imageUrl);
            dogImageGallery.value = updatedGallery;
          }

          // Set current image AFTER updating the gallery
          currentDogImageUrl.value = imageUrl;
        } else {
          errorMessage.value = 'Invalid API response format';
          debugPrint('Invalid API response format: $data');
        }
      } else {
        errorMessage.value =
            'Failed to fetch image: HTTP ${response.statusCode}';
        debugPrint('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching image: ${e.toString()}';
      debugPrint('Exception during fetch: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Clears the image gallery
  void clearGallery() {
    dogImageGallery.value = [];
    currentDogImageUrl.value = null;
    errorMessage.value = null;
  }

  /// Sets a specific image from the gallery as the current image
  void setCurrentImage(String imageUrl) {
    currentDogImageUrl.value = imageUrl;
    errorMessage.value = null;
  }

  /// Initializes the view model by fetching a first random image
  Future<void> initialize() async {
    if (currentDogImageUrl.value == null && dogImageGallery.value.isEmpty) {
      await fetchRandomDogImage();
    }
  }

  /// Dispose resources when they are no longer needed
  void dispose() {
    currentDogImageUrl.dispose();
    dogImageGallery.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}
