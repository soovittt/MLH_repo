class Route {
  final double distance;
  final double duration;
  final double weight;
  // final String mode;
  final List<List<dynamic>> coordinates;

  Route({
    required this.distance,
    required this.duration,
    required this.weight,
    // required this.mode,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': {
            'name': 'Route',
            'distance': distance,
            'duration': duration,
            'weight': weight,
            // 'mode': mode,
          },
          'geometry': {
            'type': 'LineString',
            'coordinates': coordinates,
          },
        },
      ],
    };
  }
}
