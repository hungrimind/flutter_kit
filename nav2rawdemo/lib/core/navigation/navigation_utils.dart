import 'package:nav2demo/core/navigation/navigation_state.dart';

final RegExp _parameterRegExp = RegExp(r':(\w+)(\((?:\\.|[^\\()])+\))?');

class NavigationUtils {
  /// Extracts and returns path parameters from the given [route] using the [pattern].
  ///
  /// Returns a [Map] of parameter names and their corresponding values from the route.
  static Map<String, String> extractPathParametersWithPattern(
    String route,
    String pattern,
  ) {
    Map<String, String> pathParameters = {};

    if ((pattern.isNotEmpty && route.isNotEmpty)) {
      if (pattern.contains(':')) {
        final List<String> paramNames = <String>[];
        RegExp regExp = patternToRegExp(pattern, paramNames);
        final String? match = regExp.stringMatch(route);
        if (match == route) {
          final RegExpMatch match = regExp.firstMatch(route)!;
          pathParameters = extractPathParameters(paramNames, match);
          return pathParameters;
        }
      }
    }

    return pathParameters;
  }

  /// Converts a [pattern] such as `/user/:id` into [RegExp].
  ///
  /// The path parameters can be specified by prefixing them with `:`. The
  /// `parameters` are used for storing path parameter names.
  ///
  ///
  /// For example:
  ///
  ///  `pattern` = `/user/:id/book/:bookId`
  ///
  ///  The `parameters` would contain `['id', 'bookId']` as a result of calling
  ///  this method.
  ///
  /// To extract the path parameter values from a [RegExpMatch], pass the
  /// [RegExpMatch] into [extractPathParameters] with the `parameters` that are
  /// used for generating the [RegExp].
  static RegExp patternToRegExp(String pattern, List<String> parameters) {
    final StringBuffer buffer = StringBuffer('^');
    int start = 0;
    for (final RegExpMatch match in _parameterRegExp.allMatches(pattern)) {
      if (match.start > start) {
        buffer.write(RegExp.escape(pattern.substring(start, match.start)));
      }
      final String name = match[1]!;
      final String? optionalPattern = match[2];
      final String regex =
          optionalPattern != null
              ? _escapeGroup(optionalPattern, name)
              : '(?<$name>[^/]+)';
      buffer.write(regex);
      parameters.add(name);
      start = match.end;
    }

    if (start < pattern.length) {
      buffer.write(RegExp.escape(pattern.substring(start)));
    }

    if (!pattern.endsWith('/')) {
      buffer.write(r'(?=/|$)');
    }
    return RegExp(buffer.toString(), caseSensitive: false);
  }

  /// Escapes certain characters in group and returns it as a string.
  ///
  /// This method takes a [group] and a [name]. The group is a string which might contain special characters
  /// such as ':', '=', and '!'. These characters are escaped (i.e., prefixed with a backslash) using a `RegExp` replace operation.
  /// The result is then incorporated into a string which includes the [name] parameter.
  ///
  /// This function is typically used when creating regular expression groups with named capture groups.
  static String _escapeGroup(String group, String name) {
    final String escapedGroup = group.replaceFirstMapped(
      RegExp(r'[:=!]'),
      (Match match) => '\\${match[0]}',
    );
    return '(?<$name>$escapedGroup)';
  }

  /// Extracts arguments from the `match` and maps them by parameter name.
  ///
  /// The [parameters] should originate from the call to [patternToRegExp] that
  /// creates the [RegExp].
  static Map<String, String> extractPathParameters(
    List<String> parameters,
    RegExpMatch match,
  ) {
    return <String, String>{
      for (int i = 0; i < parameters.length; ++i)
        if (match.namedGroup(parameters[i]) != null)
          parameters[i]: match.namedGroup(parameters[i])!,
    };
  }

  /// Normalizes the location string.
  static String canonicalUri(String loc) {
    String canon = Uri.parse(loc).toString();
    canon = canon.endsWith('?') ? canon.substring(0, canon.length - 1) : canon;

    // remove trailing slash except for when you shouldn't, e.g.
    // /profile/ => /profile
    // / => /
    // /login?from=/ => /login?from=/
    canon =
        canon.endsWith('/') && canon != '/' && !canon.contains('?')
            ? canon.substring(0, canon.length - 1)
            : canon;

    // /login/?from=/ => /login?from=/
    // /?from=/ => /?from=/
    canon = canon.replaceFirst('/?', '?', 1);

    return canon;
  }

  /// Returns the first [NavigationData] that matches with [name].
  ///
  /// The method iterates through [routes] to find a [NavigationData] where the [name]
  /// matches with [NavigationData.label] or [NavigationData.url] or [NavigationData.path].
  /// It can match with either exact URL or path or with path pattern.
  ///
  /// If [name] does not start with '/', the method assumes it's a label and tries to find a match in [routes].
  ///
  /// If [name] starts with '/', the method tries exact URL match first. If it doesn't find any, it tries
  /// exact path match, then it tries path pattern match.
  ///
  /// The method canonicalizes the URL path before comparing it with [NavigationData.url] and [NavigationData.path].
  ///
  /// Returns the first matching [NavigationData], or null if no match is found.
  static RouteState? getNavigationDataFromName(
      List<RouteState> routes, String name) {
    if (name.isEmpty) return null;

    RouteState? navigationData;
    if (name.startsWith('/') == false) {
      try {
        navigationData = routes.firstWhere((element) =>
            ((element.label?.isNotEmpty ?? false) && element.label == name));
      } on StateError {
        // ignore: empty_catches
      }
    } else {
      String path = canonicalUri(Uri.tryParse(name)?.path ?? '');

      // Exact URL match routing.
      try {
        navigationData = routes.firstWhere((element) => (element.path == name));
      } on StateError {
        // ignore: empty_catches
      }

      // Exact path match routing.
      if (navigationData == null) {
        try {
          navigationData =
              routes.firstWhere((element) => (element.path == path));
        } on StateError {
          // ignore: empty_catches
        }
      }

      // Path pattern matching.
      if (navigationData == null) {
        try {
          navigationData = routes.firstWhere((element) {
            Map<String, String> pathParameters =
                extractPathParametersWithPattern(path, element.path);
            return pathParameters.isNotEmpty;
          });
        } on StateError {
          // ignore: empty_catches
        }
      }
    }

    return navigationData;
  }

/// Reconstructs the full path from a [pattern] and path parameters.
///
/// This is useful for restoring the original path from a [RegExpMatch].
///
/// For example, A path matched a [RegExp] returned from [patternToRegExp] and
/// produced a [RegExpMatch]. To reconstruct the path from the match, one
/// can follow these steps:
///
/// 1. Get the `pathParameters` by calling [extractPathParameters] with the
///    [RegExpMatch] and the parameters used for generating the [RegExp].
/// 2. Call [patternToPath] with the `pathParameters` from the first step and
///    the original `pattern` used for generating the [RegExp].
static String patternToPath(String pattern, Map<String, String> pathParameters) {
  final StringBuffer buffer = StringBuffer();
  int start = 0;
  for (final RegExpMatch match in _parameterRegExp.allMatches(pattern)) {
    if (match.start > start) {
      buffer.write(pattern.substring(start, match.start));
    }
    final String name = match[1]!;
    buffer.write(pathParameters[name] ?? '');
    start = match.end;
  }

  if (start < pattern.length) {
    buffer.write(pattern.substring(start));
  }
  return buffer.toString();
}
}
