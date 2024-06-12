import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';

import 'package:notifyme/providers/ScreenDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:flutter_mapbox_navigation/library.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late MapBoxNavigationViewController mapboxNavigationController;
  double? _currentLattitude;
  double? _currentLongitude;
  //destination
  double? _finalDestinationLattitude;
  double? _finalDestinationLongitude;
  // WayPoint sourceWaypoint , destinationWayPoint
  // var waypoints =[]
  WayPoint? sourceWayPoint, destinationWayPoint;
  var waypoints = <WayPoint>[];

  late MapBoxNavigation _directions;
  late MapBoxOptions _options;
  late double _distanceRemaining, _durationRemaining;

  String _instruction = "";
  bool _arrived = false;
  bool _routeBuilt = false;
  bool _isNavigating = false;

  BottomNavigationProvider? bottomNavigationProvider;

  @override
  void initState() {
    super.initState();
    final dataProvider =
        Provider.of<ScreenDataProvider>(context, listen: false);
    dynamic data = dataProvider.getData();
    _currentLattitude = data["_currentLattitude"];
    _currentLongitude = data["_currentLongitude"];
    _finalDestinationLattitude = data["_finalDestinationLattitude"];
    _finalDestinationLongitude = data["_finalDestinationLongitude"];
    setState(() {});
    print(_currentLattitude);
    print(_currentLongitude);
    print(_finalDestinationLattitude);
    print(_finalDestinationLongitude);
    bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initialize() async {
    if (!mounted) return;

    // Setup directions and options
    // _directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);

    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        isOptimized: true,
        units: VoiceUnits.metric,
        simulateRoute: false,
        language: "en");

    // Configure waypoints
    sourceWayPoint = WayPoint(
        name: "Source",
        latitude: _currentLattitude,
        longitude: _currentLongitude);
    destinationWayPoint = WayPoint(
        name: "Destination",
        latitude: _finalDestinationLattitude,
        longitude: _finalDestinationLongitude);
    waypoints.add(sourceWayPoint!);
    waypoints.add(destinationWayPoint!);

    // Start the trip
    await MapBoxNavigation.instance
        .startNavigation(wayPoints: waypoints, options: _options);
  }

  Future<void> _onRouteEvent(e) async {
    _distanceRemaining =
        (await MapBoxNavigation.instance.getDistanceRemaining())!;
    _durationRemaining =
        (await MapBoxNavigation.instance.getDurationRemaining())!;

    // _distanceRemaining = (await _directions.distanceRemaining)!;
    // _durationRemaining = (await _directions.durationRemaining)!;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        _routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        _routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        _isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        await mapboxNavigationController.finishNavigation();
        break;
      case MapBoxEvent.navigation_finished:
        setState(() {
          bottomNavigationProvider!.setIndex(9);
        });
        break;
      case MapBoxEvent.navigation_cancelled:
        print("Navigation cancelled");
        _routeBuilt = false;
        _isNavigating = false;
        await MapBoxNavigation.instance.finishNavigation();
        setState(() {
          bottomNavigationProvider!.setIndex(9);
        });
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[300],
          leading: IconButton(
              onPressed: () {
                setState(() {
                  bottomNavigationProvider!.setIndex(9);
                });
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Column(
          children: [
            const Center(
              child: Text("Aww ! Navigation cancelled !"),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    bottomNavigationProvider!.setIndex(9);
                  });
                },
                child: const Center(
                  child: Text("Return to Dashboard page"),
                )),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    bottomNavigationProvider!.setIndex(9);
                  });
                },
                child: const Center(
                  child: Text("Return to Map page"),
                )),
          ],
        ));
  }
}
