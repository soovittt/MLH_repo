import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifyme/classes/MapConstants.dart';
import 'package:notifyme/classes/MapLocation.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/providers/ScreenDataProvider.dart';
import 'package:notifyme/utilities/constants/UCI_MAP_POINTS.dart';
import 'package:notifyme/utilities/helpers/getBuildingsOnAcademicUnit.dart';
import 'package:notifyme/utilities/helpers/getMapLocationData.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController searchText = TextEditingController();
  // ignore: non_constant_identifier_names
  String? selectedAcademicUnit;
  String? selectedBuilding;
  bool showAcademicUnitsBuilding = false;
  var focusNode = FocusNode();
  List<dynamic> markers = [];
  MapLocation? location;
  bool showLocationData = false;
  dynamic symbol;
  LatLng latLngCenter = const LatLng(33.6459364781619, -117.84258701691596);
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  late MapBoxNavigationViewController mapboxNavigationController;

  //currentLocation Variables

  //waypoints variables
  //source
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
// Latitude: 33.6537181, Longitude: -117.84034
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void stateUpdate() {
    setState(() {});
  }

  void getPosSetLocator() async {
    var position = await _determinePosition();
    setState(() {
      _currentLattitude = position.latitude;
      _currentLongitude = position.longitude;
    });
    // controller.addSymbol()
  }

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLngCenter, zoom: 15);
    getPosSetLocator();
  }

  @override
  void dispose() {
    super.dispose();
  }

  SymbolOptions _getSymbolOptions(String iconImage, int symbolCount) {
    LatLng geometry = const LatLng(33.6459364781619, -117.84258701691596);
    return SymbolOptions(
      geometry: geometry,
      iconImage: iconImage,
    );
  }

  List<LatLng> routeCoordinates = [];

  Future<dynamic> fetchDirections(double longitude, double lattitude) async {
    final response = await http.get(
      Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/${_currentLongitude}%2C${_currentLattitude}%3B${longitude}%2C${lattitude}?alternatives=true&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1Ijoic29vdml0dHQiLCJhIjoiY2xqaTI4bGd0MDNybDNzbGxheXo1Y21xaCJ9.lOnns32fGyecibYjq5DdCA',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'];
      return coordinates.map<LatLng>((coord) {
        return LatLng(coord[1].toDouble(), coord[0].toDouble());
      }).toList();
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/images/map.png");
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    Position position = await _determinePosition();

    // controller.animateCamera(
    //     CameraUpdate.newLatLng(LatLng(33.6459364781619, -117.84258701691596)));

    // controller.onSymbolTapped.add((symbol) async {
    //   print('Symbol tapped');
    //   print("before : $showLocationData");
    //   setState(() {
    //     showLocationData = true;
    //   });

    //   fetchDirections(
    //           location!.location!., location!.location!.latitude)
    //       .then((coordinates) {
    //     setState(() {
    //       routeCoordinates = coordinates;
    //     });

    //     if (controller != null && routeCoordinates.isNotEmpty) {
    //       controller.addLine(
    //         LineOptions(
    //           geometry: routeCoordinates,
    //           lineColor: '#0000FF', // Blue color
    //           lineWidth: 3.0, // Width of the polyline
    //         ),
    //       );
    //     }
    //   });
    // });
  }

  void symbolUpdated(dynamic symbolTo) {
    setState(() {
      symbol = symbolTo;
    });
  }

  showMapSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          markers = [];
          return AlertDialog(
            title: Text('Campus Map Search'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(
                          5.0), // Border radius (optional)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: const Text(
                          "Academic Units",
                          style: TextStyle(
                            color: Color.fromARGB(255, 126, 126, 126),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        items: LOCATION_POINTS.keys
                            .toList()
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedAcademicUnit,
                        onChanged: (value) {
                          print("value changed to ${value}");
                          setState(() {
                            showAcademicUnitsBuilding = true;
                            selectedAcademicUnit = value as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      showAcademicUnitsBuilding, // Set visibility based on showMajorList
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(
                            5.0), // Border radius (optional)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text(
                            "Buildings",
                            style: TextStyle(
                              color: Color.fromARGB(255, 126, 126, 126),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          items:
                              getBuildingsOnAcademicUnit(selectedAcademicUnit)
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                          value: selectedBuilding,
                          onChanged: (value) {
                            print("value changed to ${value}");
                            setState(() {
                              selectedBuilding = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: FloatingActionButton(
                    onPressed: () async {
                      // markers.add(getMapLocationPoints(
                      //     selectedBuilding, selectedAcademicUnit));
                      // location = getMapLocationPoints(
                      //     selectedBuilding, selectedAcademicUnit);
                      // stateUpdate();
                      // Navigator.of(context).pop();
                      // showLocationData = false;

                      // stateUpdate();
                      // if (symbol != null) {
                      //   await controller.removeSymbol(symbol);
                      // }

                      // _finalDestinationLattitude = location!.location!.latitude;
                      // _finalDestinationLongitude =
                      //     location!.location!.longitude;

                      // var symbolTo = await controller.addSymbol(SymbolOptions(
                      //   geometry: location!.location,
                      //   iconImage: "assets/images/marker.png",
                      // ));
                      // symbolUpdated(symbolTo);
                    },
                    child: const Icon(Icons.done),
                  ),
                )
              ],
            ),
            actions: [],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    final screenDataProvider =
        Provider.of<ScreenDataProvider>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.my_location),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 33, 32, 32),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  bottomNavigationProvider.setIndex(0);
                });
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    // selectedAcademicUnit = "";
                    showAcademicUnitsBuilding = false;
                  });
                  showMapSearchDialog();
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Stack(
          children: [
            MapboxMap(
              accessToken:
                  'sk.eyJ1Ijoic29vdml0dHQiLCJhIjoiY2xqbmxnMGdhMTdleTNrcWwweDFqY3JhciJ9.1wpoWnrkZdlSy7Lh02m9FQ',
              initialCameraPosition: const CameraPosition(
                  target: LatLng(-117.84258701691596, 33.6459364781619),
                  zoom: 15),
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoaded,
              myLocationEnabled: false,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
            ),
            Visibility(
                visible: showLocationData,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: height * 0.25,
                      width: width * 0.85,
                      decoration: BoxDecoration(
                          color: Color(0XFF201C1D),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  location != null
                                      ? location!.title!
                                      : "No data Found !",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Center(
                                child: Text(
                                  location != null
                                      ? location!.address!
                                      : " No data Found!",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Center(
                                child: FloatingActionButton(
                                  onPressed: () {
                                    screenDataProvider.clearData();
                                    screenDataProvider.addData(
                                        "_currentLattitude", _currentLattitude);
                                    screenDataProvider.addData(
                                        "_currentLongitude", _currentLongitude);
                                    screenDataProvider.addData(
                                        "_finalDestinationLattitude",
                                        _finalDestinationLattitude);
                                    screenDataProvider.addData(
                                        "_finalDestinationLongitude",
                                        _finalDestinationLongitude);
                                    bottomNavigationProvider.setIndex(10);
                                  },
                                  child: Icon(Icons.done),
                                ),
                              )
                            ],
                          )),
                          Expanded(
                              child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(location != null
                                  ? location!.image!
                                  : "assets/images/science_lib_uci.jpeg"),
                            ),
                          )),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
