# Make API Requests

Oftentimes you app will not be limited to the functionality within the app, you will need to make API requests to external services.

To make these requests we use the `http` package. It is maintained by the Dart team so we can be sure it is well supported and maintained.

For supported platforms such as iOS and Android, they will use the underlying native libraries to make requests for optimal performance and support for features such VPN.

## How to Make a Request

The boilerplate provides an abstraction over the `http` package, so that you can make requests in a similar way across all platforms.

To use the HTTP abstraction in your view models, inject it through the constructor:

```dart
class HomeViewModel {
  HomeViewModel({required HttpAbstraction httpAbstraction})
    : _httpAbstraction = httpAbstraction;

  final HttpAbstraction _httpAbstraction;
  final _logger = Logger('$HomeViewModel');

  Future<List<Post>> fetchPosts() async {
    try {
      _logger.info('Fetching posts from API');

      final response = await _httpAbstraction.get(
        Uri.https('jsonplaceholder.typicode.com', '/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        _logger.info('Successfully fetched ${jsonData.length} posts');
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      _logger.severe('Error fetching posts: $e');
      rethrow;
    }
  }
}
```

## Creating URIs

There are two main ways to create URIs for your HTTP requests.

### Uri.https()

Use `Uri.https()` when building API endpoints:

```dart
// Basic endpoint
Uri.https('jsonplaceholder.typicode.com', '/posts')

// With query parameters
Uri.https('jsonplaceholder.typicode.com', '/posts', {
  'userId': '1',
  'limit': '10'
})

// Dynamic paths
Uri.https('api.example.com', '/users/$userId/posts')
```

This approach forces HTTPS and separates the host, path, and query parameters.

### Uri.parse()

Use `Uri.parse()` when you have complete URL strings:

```dart
// Complete URLs
Uri.parse('https://jsonplaceholder.typicode.com/posts')

// From configuration
Uri.parse(config.apiBaseUrl + '/posts')
```

This is useful when working with complete URLs from configuration files or external sources.

## Supported HTTP Methods

The `httpAbstraction` object supports the following HTTP methods:

- `get` - Retrieves data from a specified resource.
- `post` - Sends data to a specified resource to create a new resource.
- `put` - Updates a specified resource.
- `delete` - Deletes a specified resource.
- `patch` - Partially updates a specified resource.
