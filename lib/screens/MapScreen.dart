import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:notifyme/classes/MapLocation.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/providers/ScreenDataProvider.dart';
import 'package:notifyme/utilities/constants/UCI_MAP_POINTS.dart';
import 'package:notifyme/utilities/helpers/getBuildingsOnAcademicUnit.dart';
import 'package:notifyme/utilities/helpers/getMapLocationData.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/visibility.dart' as Visible;
import 'package:http/http.dart' as http;
import 'package:notifyme/classes/Route.dart' as Route;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;

  TextEditingController searchText = TextEditingController();
  // ignore: non_constant_identifier_names
  String? selectedAcademicUnit;
  String? selectedBuilding;
  String? geoJsonMapData;

  bool showAcademicUnitsBuilding = false;
  var focusNode = FocusNode();
  List<dynamic> markers = [];
  MapLocation? location;
  bool showLocationData = false;
  dynamic symbol;
  bool? isNull;
  // LatLng latLngCenter = const LatLng(33.6459364781619, -117.84258701691596);

  double? _currentLocationLattitude = 33.65324512443399;
  double? _currentLocationLongitude = -117.84115273878534;
  double? _finalDestinationLattitude;
  double? _finalDestinationLongitude;

// 33.65324512443399, -117.84115273878534

  PointAnnotationManager? _pointAnnotationManager;
  PolylineAnnotationManager? _polylineAnnotationManager;

  @override
  void initState() {
    super.initState();
  }

  void addSymbolToMap(Position finalDestinationCoordinates) async {
    print("calleed");
    final ByteData bytes = await rootBundle.load('assets/images/marker.png');
    final Uint8List list = bytes.buffer.asUint8List();
    var options = <PointAnnotationOptions>[];
    options.add(PointAnnotationOptions(
        geometry: Point(coordinates: finalDestinationCoordinates).toJson(),
        image: list));
    dynamic val = _pointAnnotationManager?.createMulti(options);
    isNull = (val == null);
  }

  void stateUpdate() {
    setState(() {});
  }

  void UpdateCamera() {
    mapboxMap?.flyTo(
        CameraOptions(
            anchor: ScreenCoordinate(x: 0, y: 0),
            zoom: 17,
            bearing: 180,
            pitch: 30),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  }

  List<dynamic> routeCoordinates = [];

  // Future<dynamic> fetchDirections(double longitude, double lattitude) async {
  //   final response = await http.get(
  //     Uri.parse(
  //       'https://api.mapbox.com/directions/v5/mapbox/driving/${_currentLongitude}%2C${_currentLattitude}%3B${longitude}%2C${lattitude}?alternatives=true&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1Ijoic29vdml0dHQiLCJhIjoiY2xqaTI4bGd0MDNybDNzbGxheXo1Y21xaCJ9.lOnns32fGyecibYjq5DdCA',
  //     ),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final coordinates = data['routes'][0]['geometry']['coordinates'];
  //     return coordinates.map<dynamic>((coord) {
  //       return Point(
  //           coordinates: Position(coord[1].toDouble(), coord[0].toDouble()));
  //     }).toList();
  //   } else {
  //     throw Exception('Failed to fetch directions');
  //   }
  // }

  Future<dynamic> fetchDirections(double longitude, double lattitude) async {
    final response = await http.get(
      Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/${_currentLocationLongitude}%2C${_currentLocationLattitude}%3B${longitude}%2C${lattitude}?alternatives=true&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1Ijoic29vdml0dHQiLCJhIjoiY2xqaTI4bGd0MDNybDNzbGxheXo1Y21xaCJ9.lOnns32fGyecibYjq5DdCA',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      return data;
      // final coordinates = data['routes'][0]['geometry']['coordinates'];
      // return coordinates.map<dynamic>((coord) {
      //   return Point(
      //       coordinates: Position(coord[1].toDouble(), coord[0].toDouble()));
      // }).toList();
    } else {
      throw Exception('Failed to fetch directions');
    }
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
                Visible.Visibility(
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
                      print(selectedAcademicUnit);
                      print(selectedBuilding);
                      location = getMapLocationPoints(
                          selectedBuilding, selectedAcademicUnit);

                      stateUpdate();
                      Navigator.of(context).pop();
                      showLocationData = false;

                      if (isNull == false) {
                        _pointAnnotationManager!.deleteAll();
                        // mapboxMap!.style.removeStyleLayer("line_layer");
                        mapboxMap!.style.removeStyleLayer("line_layer");
                        mapboxMap!.style.removeStyleSource("line");
                      }
                      stateUpdate();
                      _finalDestinationLattitude =
                          location!.location!.lat as double?;
                      _finalDestinationLongitude =
                          location!.location!.lng as double?;
                      addSymbolToMap(location!.location!);
                      showLocationData = true;
                      fetchDirections(_finalDestinationLongitude!,
                              _finalDestinationLattitude!)
                          .then((geoData) async {
                        print(geoData);
                        final List<List<dynamic>> allCoordinates = [];

                        for (final leg in geoData["routes"][0]["legs"]) {
                          for (final step in leg["steps"]) {
                            final stepCoordinates =
                                step["geometry"]["coordinates"];
                            if (stepCoordinates != null) {
                              allCoordinates.addAll(
                                stepCoordinates
                                    .map<List<dynamic>>(
                                      (coord) => [
                                        coord[0].toDouble(),
                                        coord[1].toDouble()
                                      ],
                                    )
                                    .toList(),
                              );
                            }
                          }
                        }
                        dynamic route = Route.Route(
                          distance: geoData["routes"][0]["distance"],
                          duration: geoData["routes"][0]["duration"],
                          weight: geoData["routes"][0]["weight"],
                          // mode: geoData["routes"][0]["legs"][0]["mode"],
                          coordinates: allCoordinates,
                        );
                        final geoJson = json.encode(route.toJson());
                        await mapboxMap!.style.addSource(
                            GeoJsonSource(id: "line", data: geoJson));

                        await mapboxMap!.style.addLayer(LineLayer(
                            id: "line_layer",
                            sourceId: "line",
                            lineJoin: LineJoin.ROUND,
                            lineCap: LineCap.ROUND,
                            lineOpacity: 0.7,
                            lineColor: Colors.red.value,
                            lineWidth: 8.0));
                      });
                      stateUpdate();
                      // print("before data");
                      // print(geoJsonMapData);
                      // if (mapboxMap != null && routeCoordinates.isNotEmpty) {
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

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap?.annotations
        .createPointAnnotationManager()
        .then((pointAnnotationManager) async {
      _pointAnnotationManager = pointAnnotationManager;
    });

    mapboxMap?.annotations
        .createPolylineAnnotationManager()
        .then((polyLineAnnotationManager) async {
      _polylineAnnotationManager = polyLineAnnotationManager;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    final screenDataProvider =
        Provider.of<ScreenDataProvider>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.my_location_rounded),
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
          MapWidget(
            resourceOptions: ResourceOptions(
                accessToken:
                    "pk.eyJ1Ijoic29vdml0dHQiLCJhIjoiY2xqaTI4bGd0MDNybDNzbGxheXo1Y21xaCJ9.lOnns32fGyecibYjq5DdCA"),
            cameraOptions: CameraOptions(
                center: Point(
                        coordinates:
                            Position(-117.84258701691596, 33.6459364781619))
                    .toJson(),
                zoom: 15.0),
            onMapCreated: _onMapCreated,
          ),
          Visible.Visibility(
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
                                      "_currentLattitude",
                                      _currentLocationLattitude);
                                  screenDataProvider.addData(
                                      "_currentLongitude",
                                      _currentLocationLongitude);
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
    );
  }
}
