import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/providers/ScreenDataProvider.dart';
import 'package:notifyme/utilities/helpers/determineLuminanceTextColor.dart';
import 'package:notifyme/utilities/helpers/getInstructorLastName.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/time_planner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math';

class CalenderDetail extends StatefulWidget {
  const CalenderDetail({super.key});

  @override
  State<CalenderDetail> createState() => _CalenderDetailState();
}

class _CalenderDetailState extends State<CalenderDetail> {
  List<TimePlannerTask> tasks = [];

  static String? proffesorLastName;
  static String? courseType;
  static String? department;
  static String? courseCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void proffesorNameUpdate(String shortName) {
    String lastName = getInstructorLastName(shortName);
    setState(() {
      proffesorLastName = lastName;
    });
  }

  Future<List> fetchTimePlannerTasks(String calenderId) async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/notifyme/timeplannertask/get/${calenderId}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data. Error: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchInstructorData(
      String instructorShortName) async {
    final response = await http
        .get(Uri.parse("https://api.peterportal.org/rest/v0/instructors/all"));
    if (response.statusCode == 200) {
      print(instructorShortName);
      final List<dynamic> data = jsonDecode(response.body);
      Map<String, dynamic> instructor_map = {};
      for (var instructor_data in data) {
        if (instructor_data["shortened_name"] == instructorShortName) {
          instructor_map = instructor_data;
        }
      }

      return instructor_map;
    } else {
      throw Exception('Failed to fetch data. Error: ${response.statusCode}');
    }
  }

  showRateMyProffesorDialog(double height, double width,
      String instructorShortName, WebViewController webController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            title: const Text("Rate My Proffesor"),
            content: Builder(
              builder: (context) {
                return SizedBox(
                  height: height - height / 3,
                  width: width - width / 20,
                  child: WebViewWidget(controller: webController),
                );
              },
            ),
          );
        });
      },
    );
  }

  showZotisticsDialog(double height, double width, String instructorShortName,
      WebViewController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            title: const Text("Zotistics"),
            content: Builder(
              builder: (context) {
                return SizedBox(
                  height: height - height / 3,
                  width: width - width / 20,
                  child: WebViewWidget(controller: controller),
                );
              },
            ),
          );
        });
      },
    );
  }

  showInstructorAlertDialog(
      double height, double width, String instructorShortName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            title: const Text("Instructor"),
            content: Builder(
              builder: (context) {
                return SizedBox(
                  height: height - height / 3,
                  width: width - width / 20,
                  child: FutureBuilder(
                      future: fetchInstructorData(instructorShortName),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          print(snapshot.data);
                          Map<String, dynamic> data = snapshot.data!;
                          if (data.isEmpty) {
                            return const Center(
                                child: Text("Sorry No Instuctor data found!"));
                          } else {
                            return Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Name : "),
                                      Text(data["name"])
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("UCINETID : "),
                                      Text(data['ucinetid']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Lecturer : "),
                                      Text(data['title']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Department : "),
                                      Text(data['department']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Email : "),
                                      Text(data['email']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          proffesorNameUpdate(
                                              instructorShortName);
                                          setState(() {});
                                          WebViewController webController =
                                              WebViewController()
                                                ..setJavaScriptMode(
                                                    JavaScriptMode.unrestricted)
                                                ..setBackgroundColor(
                                                    const Color(0x00000000))
                                                ..setNavigationDelegate(
                                                  NavigationDelegate(
                                                    onProgress: (int progress) {
                                                      // Update loading bar.
                                                    },
                                                    onPageStarted:
                                                        (String url) {},
                                                    onPageFinished:
                                                        (String url) {},
                                                    onWebResourceError:
                                                        (WebResourceError
                                                            error) {},
                                                    onNavigationRequest:
                                                        (NavigationRequest
                                                            request) {
                                                      if (request.url.startsWith(
                                                          'https://www.youtube.com/')) {
                                                        return NavigationDecision
                                                            .prevent;
                                                      }
                                                      return NavigationDecision
                                                          .navigate;
                                                    },
                                                  ),
                                                )
                                                ..loadRequest(Uri.parse(
                                                    "https://www.ratemyprofessors.com/search/professors/1074?q=$proffesorLastName"));

                                          showRateMyProffesorDialog(
                                              height,
                                              width,
                                              instructorShortName,
                                              webController);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0XFF6e2b9e),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Image.asset(
                                                  'assets/images/rmp.png',
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      "Rate My Proffesor")),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          WebViewController webController =
                                              WebViewController()
                                                ..setJavaScriptMode(
                                                    JavaScriptMode.unrestricted)
                                                ..setBackgroundColor(
                                                    const Color(0x00000000))
                                                ..setNavigationDelegate(
                                                  NavigationDelegate(
                                                    onProgress: (int progress) {
                                                      // Update loading bar.
                                                    },
                                                    onPageStarted:
                                                        (String url) {},
                                                    onPageFinished:
                                                        (String url) {},
                                                    onWebResourceError:
                                                        (WebResourceError
                                                            error) {},
                                                    onNavigationRequest:
                                                        (NavigationRequest
                                                            request) {
                                                      if (request.url.startsWith(
                                                          'https://www.youtube.com/')) {
                                                        return NavigationDecision
                                                            .prevent;
                                                      }
                                                      return NavigationDecision
                                                          .navigate;
                                                    },
                                                  ),
                                                )
// https://zotistics.com/?&selectQuarter=&selectYear=&selectDep=${}&classNum=${}&code=&submit=Submit
                                                //
                                                ..loadRequest(Uri.parse(
                                                    "https://zotistics.com/?&selectQuarter=&selectYear=&selectDep=${department}&classNum=${courseCode}&code=&submit=Submit"));
                                          showZotisticsDialog(
                                              height,
                                              width,
                                              instructorShortName,
                                              webController);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0XFF43dcf0),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Image.asset(
                                                  'assets/images/zotistics_icon.png',
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text("Zotistics")),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {}
                        return Center();
                      }),
                );
              },
            ),
          );
        });
      },
    );
  }

  showClassInfoDialog(
      BuildContext context,
      String id,
      String className,
      String sectionCode,
      String term,
      String instructor,
      String Location,
      String finalTime,
      double height,
      double width) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${className} info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(className),
                  IconButton(
                      onPressed: () async {
                        final response = await http.delete(
                          Uri.parse(
                              "http://127.0.0.1:8000/notifyme/timeplannertask/delete/${id}/"),
                          headers: {'Content-Type': 'application/json'},
                        );
                        if (response.statusCode == 201 ||
                            response.statusCode == 200) {
                          print("deleted succesfullyy");
                        } else {
                          print("Print Failed");
                        }
                        setState(() {
                          tasks = [];
                        });
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Section Code - $sectionCode")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Term - $term")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Instructor - "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      showInstructorAlertDialog(height, width, instructor);
                    },
                    child: Text(
                      instructor,
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    ),
                  )
                ],
                //  decoration: TextDecoration.underline, // Add underline
                // color: Colors.blue
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Location - $Location")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      child: Text(
                    "Final Time - $finalTime",
                    overflow: TextOverflow.visible,
                  ))
                ],
              )
            ],
          ),
          actions: [],
        );
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Fall 2021",
              style: TextStyle(
                color: Color.fromRGBO(47, 80, 97, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
                color: const Color.fromRGBO(2, 84, 146, 1),
                onPressed: () {
                  setState(() {
                    bottomNavigationProvider.setIndex(1);
                  });
                },
                icon: Icon(Icons.arrow_back)),
          ),
          body: FutureBuilder<List>(
            future: fetchTimePlannerTasks(screenDataProvider.getData()["id"]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the data
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Display an error message if an error occurs
                return Text('Error: ${snapshot.error}');
              } else {
                // Data has been successfully loaded
                dynamic tasksList = snapshot.data!;
                if (tasksList.length != 0) {
                  for (var taskElement in tasksList) {
                    var days =
                        jsonDecode(taskElement["additional_data"])["days"];
                    for (var i = 0; i < days.length; i++) {
                      tasks.add(TimePlannerTask(
                        // background color for task
                        color:
                            Color(int.parse(taskElement["color"], radix: 16)),
                        // day: Index of header, hour: Task will be begin at this hour
                        // minutes: Task will be begin at this minutes
                        dateTime: TimePlannerDateTime(
                            day: days[i],
                            hour: taskElement["hour"],
                            minutes: taskElement["minutes"]),
                        // Minutes duration of task
                        minutesDuration: taskElement["minutes_duration"],
                        // Days duration of task (use for multi days task)
                        daysDuration: taskElement["days_duration"],
                        onTap: () {
                          showClassInfoDialog(
                              context,
                              taskElement["id"],
                              taskElement["title"],
                              taskElement["section_code"],
                              taskElement["term"],
                              taskElement["instructor"],
                              taskElement["location"],
                              taskElement["final"],
                              height,
                              width);
                          department = taskElement["department"];
                          courseCode = taskElement["code"];
                        },
                        child: Center(
                          child: Text(
                            taskElement["title"],
                            style: TextStyle(
                                color: determineTextColor(Color(int.parse(
                                    taskElement["color"],
                                    radix: 16))),
                                fontSize: 6),
                          ),
                        ),
                      ));
                    }
                  }
                }
                return TimePlanner(
                  currentTimeAnimation: true,
                  startHour: 8,
                  endHour: 23,
                  headers: const [
                    TimePlannerTitle(
                      title: "Mon",
                      titleStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    TimePlannerTitle(
                      title: "Tue",
                      titleStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    TimePlannerTitle(
                      title: "Wed",
                      titleStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    TimePlannerTitle(
                      title: "Thu",
                      titleStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    TimePlannerTitle(
                      title: "Fri",
                      titleStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ],
                  tasks: tasks,
                  style: TimePlannerStyle(
                    backgroundColor: Colors.white,
                    cellHeight: height ~/ 20,
                    cellWidth: width ~/ 6,
                    dividerColor: Colors.black,
                    showScrollBar: true,
                    horizontalTaskPadding: 5,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                );
              }
            },
          )),
    );
  }
}
