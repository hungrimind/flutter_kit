bool matchRoute(String pattern, String path) {
  final pathUri = Uri.parse(path);
  final pathSegments = getSegments(pathUri.path);
  final patternSegments = getSegments(pattern);

  if (patternSegments.length != pathSegments.length) return false;

  for (var i = 0; i < patternSegments.length; i++) {
    if (patternSegments[i].startsWith(':')) continue;
    if (patternSegments[i] != pathSegments[i]) return false;
  }

  return true;
}

/// Splits a path into segments, filtering out empty segments
List<String> getSegments(String path) =>
    path.split('/').where((s) => s.isNotEmpty).toList();
