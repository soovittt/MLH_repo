import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:notifyme/providers/CalenderProvider.dart';
import 'package:notifyme/utilities/helpers/RandomColorGenerator.dart';
import 'package:notifyme/utilities/helpers/dayEncodegenerator.dart';
import 'package:notifyme/utilities/helpers/stringsplitter.dart';

import '../utilities/helpers/RandomIdGenerator.dart';
import '../utilities/helpers/TimeFormatter.dart';

class courseScheduleTile extends StatefulWidget {
  final String meetingDay;
  final String meetingTime;
  final String maxCapacity;
  final String currentEnrollNum;
  final String className;
  final String term;
  final Map<dynamic, dynamic> courseData;
  final dynamic classIdCode;
  final String deptCode;
  final String dept;
  final String courseNumber;
  const courseScheduleTile(
      {super.key,
      required this.meetingDay,
      required this.meetingTime,
      required this.maxCapacity,
      required this.currentEnrollNum,
      required this.courseData,
      required this.className,
      required this.term,
      this.classIdCode,
      required this.deptCode,
      required this.dept,
      required this.courseNumber});

  @override
  State<courseScheduleTile> createState() => _courseScheduleTileState();
}

class _courseScheduleTileState extends State<courseScheduleTile> {
  late CalenderProvider calenderProvider;

  Future<List> fetchCalendars() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/notifyme/calendars/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data. Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  showAlertDialog(BuildContext context, Text text) {
    AlertDialog alert = AlertDialog(
        title: text,
        content: SingleChildScrollView(
          child: FutureBuilder(
            future: fetchCalendars(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final calendars = snapshot.data!;
                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: calendars.length,
                    itemBuilder: (context, index) {
                      final calendar = calendars[index];
                      return InkWell(
                        child: ListTile(
                          title: Text(calendar["title"]),
                        ),
                        onTap: () async {
                          var cid = calendar["id"];
                          var days = weekdayIntEncodingGenerator(stringSplit(
                              widget.courseData["meetings"][0]["days"]));
                          var timings = formatmeetingTime(
                              widget.courseData["meetings"][0]["time"]);
                          Map<String, dynamic> requestData = {
                            "id": generateRandomId(),
                            "calender": cid,
                            "title": widget.className,
                            "minutes_duration": timings["duration"],
                            "days_duration": 1,
                            "minutes": timings["startMinute"],
                            "hour": timings["startHour"],
                            "color": generateRandomColor(),
                            "repetition": days.length,
                            "additional_data": jsonEncode({"days": days}),
                            "section_code": widget.courseData["sectionCode"],
                            "term": widget.term,
                            "instructor": widget.courseData["instructors"][0],
                            "location": widget.courseData["meetings"][0]
                                ["bldg"],
                            "final": widget.courseData["finalExam"],
                            "department": widget.dept,
                            "code": widget.courseNumber,
                            "course_type": "Lec",
                          };
                          final response = await http.post(
                              Uri.parse(
                                  "http://127.0.0.1:8000/notifyme/timeplannertask/"),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode(requestData));

                          if (response.statusCode == 201 ||
                              response.statusCode == 200) {
                            print("created succesfullyy");
                          } else {
                            print("Print Failed");
                          }
                          Navigator.of(context).pop();
                          setState(() {});
                        },
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
        ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: height * 0.06,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(47, 80, 97, 1),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showAlertDialog(context, const Text("Choose Calendar"));
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: height * 0.02,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0XFFff66c4),
                          Color.fromARGB(255, 231, 123, 51)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      "Lec",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      "${widget.meetingDay} ${widget.meetingTime}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "${widget.currentEnrollNum}/${widget.maxCapacity}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      height: height * 0.015,
                      width: width * 0.09,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0XFF0097b2), Color(0XFF7ed957)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          "OPEN",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.currentEnrollNum == widget.maxCapacity
                  ? Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () async {
                            print('dept : ${widget.deptCode}');
                            Map<String, dynamic> requestData = {
                              'class_id': widget.classIdCode,
                              'title': widget.className,
                              'email': 'sovitn@uci.edu',
                              'class_type': 'Lec',
                              'department': widget.deptCode,
                              'color': generateRandomColor(),
                            };
                            final response = await http.post(
                                Uri.parse(
                                    "http://127.0.0.1:8000/notifyme/subscribed/classes/post/"),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode(requestData));

                            if (response.statusCode == 201 ||
                                response.statusCode == 200) {
                              print("Subscription Succesful");
                            } else {
                              print("Unable to Subscribe");
                            }
                          },
                          icon: const Icon(
                            Icons.notification_add,
                            color: Colors.white,
                          )))
                  : Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            showAlertDialog(
                                context, const Text("Course Still Vacant"));
                          },
                          icon: const Icon(
                            Icons.notifications_off,
                            color: Color.fromARGB(255, 206, 206, 206),
                          )))
            ],
          ),
        ),
      ),
    );
  }
}
