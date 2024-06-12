import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:http/http.dart' as http;
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/utilities/constants/majorList.dart';
import 'package:notifyme/utilities/helpers/RandomColorGenerator.dart';
import 'package:notifyme/utilities/helpers/RandomIdGenerator.dart';
import 'package:notifyme/utilities/helpers/convertQuarterListToPlannerDataFormat.dart';
import 'package:notifyme/utilities/helpers/getQuarters.dart';
import 'package:notifyme/utilities/helpers/integerParser.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';
import '../providers/ScreenDataProvider.dart';

class Planner extends StatefulWidget {
  const Planner({super.key});

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  final tooltipController = JustTheController();
  TextEditingController addPlannertextcontroller = TextEditingController();
  TextEditingController editPlannertextController = TextEditingController();

  List<String> plannerTypes = ['2-year', '3-year', '4-year', '5-year'];
  String? selectedPlannerType;

  List<String> englishAlphabets = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  String? selectedMajorLetter;
  String? selectedMajor;

  bool showMajorList = false;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  Future<List> fetchPlanners() async {
    Map<String, dynamic> requestData = {
      'email': 'sovitn@uci.edu',
    };
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/notifyme/planner/get/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data. Error: ${response.statusCode}');
    }
  }

  void stateUpdate() {
    setState(() {});
  }

  showAlertDialog(
      BuildContext context, double screenHeight, double screenWidth) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Add Planner"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {},
                  controller: addPlannertextcontroller,
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 1,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
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
                          "Planner Type",
                          style: TextStyle(
                            color: Color.fromARGB(255, 126, 126, 126),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        items: plannerTypes
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
                        value: selectedPlannerType,
                        onChanged: (value) {
                          print("value changed to ${value}");
                          setState(() {
                            selectedPlannerType = value as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
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
                          "Major Letter",
                          style: TextStyle(
                            color: Color.fromARGB(255, 126, 126, 126),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        items: englishAlphabets
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
                        value: selectedMajorLetter,
                        onChanged: (value) {
                          print("value changed to ${value}");
                          print("init : ${showMajorList}");
                          setState(() {
                            showMajorList = true;
                            selectedMajorLetter = value as String;
                          });
                          print("init : ${showMajorList}");
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      showMajorList, // Set visibility based on showMajorList
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
                            "Major",
                            style: TextStyle(
                              color: Color.fromARGB(255, 126, 126, 126),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          items: majorList[selectedMajorLetter]
                              ?.keys
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
                          value: selectedMajor,
                          onChanged: (value) {
                            print("value changed to ${value}");
                            setState(() {
                              selectedMajor = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // : Center(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () async {
                      var plannerName = addPlannertextcontroller.text;
                      var id = generateRandomId();
                      var color = generateRandomColor();
                      addPlannertextcontroller.clear();

                      Map<String, dynamic> requestData = {
                        'id': id,
                        'title': plannerName,
                        'color': color,
                        'email': 'sovitn@uci.edu',
                        'type': selectedPlannerType,
                        'major': selectedMajor,
                        'major_url':
                            majorList[selectedMajorLetter]![selectedMajor],
                        'data': convertQuarterListToPlannerDataFormat(
                            getQuarters(selectedPlannerType!))
                      };
                      final response = await http.post(
                        Uri.parse(
                            "http://127.0.0.1:8000/notifyme/planner/post/"),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode(requestData),
                      );

                      if (response.statusCode == 201 ||
                          response.statusCode == 200) {
                        print("created succesfullyy");
                      } else {
                        print("Print Failed");
                      }

                      Navigator.of(context).pop();
                      stateUpdate();
                    },
                    child: const Center(
                      child: Icon(Icons.done),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  showDeleteDialog(BuildContext context, String plannerName, String plannerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Planner'),
          content: Text(
              "Are you sure you want to delete ${plannerName} id : ${plannerId} schedule ?"),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                final response = await http.delete(
                  Uri.parse(
                      "http://127.0.0.1:8000/notifyme/planner/delete/${plannerId}"),
                  headers: {'Content-Type': 'application/json'},
                );
                if (response.statusCode == 201 || response.statusCode == 200) {
                  print("deleted succesfullyy");
                } else {
                  print("Print Failed");
                }
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  showEditDialog(BuildContext context, String plannerName, String plannerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Planner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Edit your planner name before editing"),
              TextField(
                controller: editPlannertextController..text = plannerName,
                onChanged: (value) {
                  editPlannertextController.text = value;
                  editPlannertextController.selection = TextSelection.collapsed(
                      offset: editPlannertextController.text.length);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('done'),
              onPressed: () async {
                final response = await http.put(
                    Uri.parse(
                        "http://127.0.0.1:8000/notifyme/planner/update/${plannerId}"),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'email': 'sovitn@uci.edu',
                      'title': editPlannertextController.text
                    }));
                if (response.statusCode == 201 || response.statusCode == 200) {
                  print("edited succesfullyy");
                } else {
                  print("Print Failed");
                }
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double textScaleFactor = mediaQuery.textScaleFactor;
    double textSize = screenWidth * 0.05 * textScaleFactor;
    final bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    final screenDataProvider =
        Provider.of<ScreenDataProvider>(context, listen: true);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Planners",
        onPressed: () {
          showAlertDialog(context, screenHeight, screenWidth);
        },
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            tooltipController.showTooltip();
                          },
                          child: JustTheTooltip(
                            controller: tooltipController,
                            content: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'This is the Planner page where where you can add your tentative 4 - year schedules. Edit the schedules or Add new planners that you are planning on !',
                                style: TextStyle(color: Color(0XFFA7A7A7)),
                              ),
                            ),
                            child: const Icon(
                              Icons.info,
                              color: Color(0XFFA7A7A7),
                            ),
                          ),
                        )),
                  ),
                  Container(
                    color: Colors.white,
                    child: Center(
                        child: Text(
                      "Planner",
                      style: TextStyle(
                          fontSize: textSize, fontWeight: FontWeight.w500),
                    )),
                  )
                ],
              )),
          Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0XFFFAFAFA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: FutureBuilder(
                          future: fetchPlanners(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                              return Center(
                                child: Text('This Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData) {
                              final planners = snapshot.data!;
                              print(planners);
                              return SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: planners.length,
                                  itemBuilder: (context, index) {
                                    final planner = planners[index];
                                    return GestureDetector(
                                      onTap: () {
                                        screenDataProvider.clearData();
                                        bottomNavigationProvider.setIndex(7);
                                        screenDataProvider.addData(
                                            "id", planner['id']);
                                        screenDataProvider.addData(
                                            "title", planner['title']);
                                        screenDataProvider.addData(
                                            "type", planner['type']);
                                        screenDataProvider.addData(
                                            "major", planner['major']);
                                        screenDataProvider.addData(
                                            "major_url", planner['major_url']);
                                        // screenDataProvider.addData(
                                        //     "major", selectedMajor);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: screenHeight * 0.12,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Color(0XFFFFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors
                                                      .grey, // Shadow color
                                                  blurRadius:
                                                      10, // Spread of the shadow
                                                  offset: Offset(0,
                                                      3), // Offset of the shadow
                                                ),
                                              ],
                                            ),
                                            child: LayoutBuilder(builder:
                                                (BuildContext context,
                                                    BoxConstraints
                                                        constraints) {
                                              double parentWidth =
                                                  constraints.maxWidth;
                                              double parentHeight =
                                                  constraints.maxHeight;
                                              return Center(
                                                  child: Container(
                                                height: parentHeight * 0.7,
                                                width: parentWidth * 0.8,
                                                decoration: const BoxDecoration(
                                                  color: Color(0XFFF4F6FF),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                  ),
                                                ),
                                                child: LayoutBuilder(builder:
                                                    (BuildContext context,
                                                        BoxConstraints
                                                            constraints) {
                                                  double secondParentWidth =
                                                      constraints.maxWidth;
                                                  double secondParentHeight =
                                                      constraints.maxHeight;
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          height:
                                                              secondParentHeight,
                                                          width:
                                                              secondParentWidth *
                                                                  0.02,
                                                          color: Color(
                                                              int.parse(
                                                                  planner[
                                                                      "color"],
                                                                  radix: 16))),
                                                      const Expanded(
                                                        flex: 1,
                                                        child: Center(),
                                                      ),
                                                      Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            // color: Colors.yellow,
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        planner[
                                                                            'title'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                textSize),
                                                                      ),
                                                                    )),
                                                                const Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: Text(
                                                                          "created : 9/2/2023"),
                                                                    )),
                                                              ],
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Center(
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          showEditDialog(
                                                                              context,
                                                                              planner['title'],
                                                                              planner['id']);
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Color(0XFFA9A9AA),
                                                                        )),
                                                                  )),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Center(
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          showDeleteDialog(
                                                                              context,
                                                                              planner['title'],
                                                                              planner['id']);
                                                                        },
                                                                        icon: const Icon(Icons.delete, color: Color(0XFFA9A9AA))),
                                                                  )),
                                                            ],
                                                          ))
                                                    ],
                                                  );
                                                }),
                                              ));
                                            }),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('No data available'),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      )),
    );
  }
}
