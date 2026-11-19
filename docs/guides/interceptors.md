# Intercept APIs

Interceptors (similar to middleware) are a way to modify requests and responses. It is a middle man between your app and the network. They can be used for a variety of purposes such as logging, authentication, and caching.

The `HttpAbstraction` is made to work with interceptors out of the box. We have added a `LoggingInterceptor` that will log requests only during development. To activate an interceptor you can pass it in the `interceptors` parameter of the `HttpAbstraction` constructor.

```dart
HttpAbstraction(
  interceptors: [
    LoggingInterceptor(
      logBody: !kReleaseMode, // Only log bodies in debug mode
    ),
  ],
),
```

## Create Your Own Interceptor

You can create your own interceptor by implementing the `HttpInterceptor` interface. This will have two methods: `interceptRequest` and `interceptResponse`.

The `interceptRequest` method will be called when a request is made. You can modify this request and return it to be used by the `HttpAbstraction`.

The `interceptResponse` method will be called when a response is received. You can modify this response and return to be used by the `HttpAbstraction`.

```dart
class MyCustomInterceptor implements HttpInterceptor {
  @override
  Future<http.BaseRequest> interceptRequest(http.BaseRequest request) async {
    // do something with the request, maybe refresh a token?
    return request;
  }

  @override
  Future<http.BaseResponse> interceptResponse(http.BaseResponse response) async {
    // do something with the response.
    return response;
  }
}
```
