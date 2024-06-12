import 'package:notifyme/classes/MapLocation.dart';
import 'package:notifyme/utilities/constants/UCI_MAP_POINTS.dart';

MapLocation? getMapLocationPoints(String? place, String? AcademicUnit) {
  MapLocation? location;

  for (var i = 0; i < LOCATION_POINTS[AcademicUnit]!.length; i++) {
    if (LOCATION_POINTS[AcademicUnit]![i].title == place) {
      location = LOCATION_POINTS[AcademicUnit]![i];
    }
  }
  return location;
}
