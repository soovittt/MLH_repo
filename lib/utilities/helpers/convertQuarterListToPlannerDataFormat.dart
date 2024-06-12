Map<String, dynamic> convertQuarterListToPlannerDataFormat(
    List<String> quarterList) {
  Map<String, dynamic> finalMap = {};
  int _counter = 1;
  for (var quarter in quarterList) {
    finalMap[quarter] = {"id": _counter, "classes": {}};
    _counter++;
  }
  return finalMap;
}
