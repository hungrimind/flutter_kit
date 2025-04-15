class NavigationUtils {
  static Map<String, String> extractPathParametersWithPattern(
    String path,
    String pattern,
  ) {
    final params = <String, String>{};
    final regex = RegExp(r'(:(\w+))');
    final matches = regex.allMatches(path);
    for (final match in matches) {
      final paramName = match.group(2);
      if (paramName != null) {
        params[paramName] = '';
      }
    }
    return params;
  }
}
