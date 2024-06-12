import 'package:notifyme/utilities/constants/UCI_MAP_POINTS.dart';

List<String?> getBuildingsOnAcademicUnit(String? academicUnit) {
  List<String?> academicUnitsBuilding = [];
  if (academicUnit == null) {
    return [];
  }
  for (var i = 0; i < LOCATION_POINTS[academicUnit]!.length; i++) {
    academicUnitsBuilding.add(LOCATION_POINTS[academicUnit]![i].title);
  }
  return academicUnitsBuilding;
}
