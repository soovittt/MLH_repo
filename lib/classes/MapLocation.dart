import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapLocation {
  final String? image;
  final String? title;
  final String? address;
  final Position? location;

  MapLocation({
    required this.image,
    required this.title,
    this.address,
    required this.location,
  });
}
