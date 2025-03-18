class AppRequest {
  static Map<String, String> header([String? bearerToken]) {
    if (bearerToken == null) {
      return {'Accept': 'application/json'};
    } else {
      return {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };
    }
  }

  static String params(Map<String, String> parameters) {
    return parameters.entries
        .map((entry) {
          return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
        })
        .join('&');
  }
}
