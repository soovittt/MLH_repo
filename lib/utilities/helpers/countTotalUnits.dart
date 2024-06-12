int countTotalUnits(Map<String, dynamic> courseData) {
  int totalUnits = 0;

  courseData.forEach((key, value) {
    if (value is Map<String, dynamic> && value.containsKey('units')) {
      int? units = int.tryParse(value['units'] ?? '');
      if (units != null) {
        totalUnits += units;
      }
    }
  });

  return totalUnits;
}
