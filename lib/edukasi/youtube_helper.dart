String convertUrlToId(String url) {
  final uri = Uri.parse(url);
  if (uri.host.contains("youtu.be")) {
    return uri.pathSegments.first;
  } else {
    return uri.queryParameters['v'] ?? '';
  }
}
