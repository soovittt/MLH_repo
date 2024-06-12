String convertUrlPatternToNormal(String urlPattern) {
  Map<String, String> conversion = {"%26": "&", "%2F": "/"};

  conversion.forEach((key, value) {
    urlPattern = urlPattern.replaceAll(key, value);
  });
  urlPattern = urlPattern.replaceAll(' ', '');
  return urlPattern;
}
