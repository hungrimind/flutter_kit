import 'package:fetch_client/fetch_client.dart';
import 'package:http/http.dart' as http;

/// Creates a platform-specific HTTP client for web
http.Client httpClient() => FetchClient(mode: RequestMode.cors);