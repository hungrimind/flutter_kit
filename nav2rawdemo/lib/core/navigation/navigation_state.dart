import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_utils.dart';

class RouteState {
  RouteState({required this.label, required this.path, required this.builder});

  final String? label;
  final String path;
  final Widget Function(
    ValueKey<String>? key,
    String? name,
    MyRouteSettings routeData,
  )?
  builder;
}

class MyRouteSettings extends RouteSettings {
  final String path;
  final String label;
  final Map<String, String> queryParameters;
  final Map<String, String> pathParameters;
  final Map<String, dynamic>? metadata;
  final String? group;

  Uri get uri => Uri(path: path, queryParameters: queryParameters);

  MyRouteSettings({
    required this.path,
    this.label = '',
    this.queryParameters = const {},
    this.pathParameters = const {},
    this.metadata = const {},
    this.group,
    super.arguments,
  }) : super(
         name: NavigationUtils.canonicalUri(
           Uri(path: path, queryParameters: queryParameters).toString(),
         ),
       );

  factory MyRouteSettings.fromUrl(
    String url, {
    String label = '',
    String? group,
    Map<String, dynamic>? metadata,
  }) {
    Uri uri = Uri.parse(url);
    return MyRouteSettings(
      path: uri.path,
      queryParameters: uri.queryParameters,
      label: label,
      group: group,
      metadata: metadata,
    );
  }

  factory MyRouteSettings.fromUri(
    Uri uri, {
    String label = '',
    String? group,
    Map<String, dynamic>? metadata,
  }) {
    return MyRouteSettings(
      path: uri.path,
      queryParameters: uri.queryParameters,
      label: label,
      group: group,
      metadata: metadata,
    );
  }

  MyRouteSettings copyWith({
    String? label,
    String? path,
    Map<String, String>? queryParameters,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? metadata,
    String? group,
    Object? arguments,
  }) {
    return MyRouteSettings(
      label: label ?? this.label,
      path: path ?? this.path,
      queryParameters: queryParameters ?? this.queryParameters,
      pathParameters: pathParameters ?? this.pathParameters,
      metadata: metadata ?? this.metadata,
      group: group ?? this.group,
      arguments: arguments ?? this.arguments,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MyRouteSettings &&
      ((other.label.isNotEmpty && other.label == label) ||
          (other.path == path && other.path.isNotEmpty && path.isNotEmpty));

  @override
  int get hashCode => label.hashCode * path.hashCode;

  @override
  String toString() =>
      'Route(label: $label, path: $path, name: $name, queryParameters: $queryParameters, metadata: $metadata, group: $group, arguments: $arguments)';

  operator [](String key) => queryParameters[key];
}
