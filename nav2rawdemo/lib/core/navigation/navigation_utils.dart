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
}
