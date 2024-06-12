import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/screens/Calender.dart';
import 'package:notifyme/screens/Dashboard.dart';
import 'package:notifyme/screens/NotificationPage.dart';
import 'package:notifyme/screens/Settings.dart';
import 'package:notifyme/services/ApiService.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:notifyme/utilities/constants/departments.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import '../components/CourseScheduleTile.dart';
import '../components/DiscussionTile.dart';
import 'package:notifyme/screens/Calender.dart';
import 'package:notifyme/screens/NotificationPage.dart';
import 'package:notifyme/screens/Settings.dart';

class ScheduleSearchPage extends StatefulWidget {
  const ScheduleSearchPage({super.key});
  static String id = "schedule_search_page";

  @override
  State<ScheduleSearchPage> createState() => _ScheduleSearchPageState();
}

class _ScheduleSearchPageState extends State<ScheduleSearchPage> {
  Future<Map<String, dynamic>> getData(
      String term, String quarter, String query) {
    APIService apiService = APIService(
        "https://api.peterportal.org/rest/v0//schedule/soc?term=${term}%20${quarter}&department=${query}");
    return apiService.getRequest();
  }

  final List<String> term = [
    "2023",
    "2022",
    "2021",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
    "2013",
  ];

  final Map<String, String> quarter = {
    "Fall": "Fall",
    "Winter": "Winter",
    "Spring": "Spring",
    "Summer session 1": "Summer1",
    "Summer session 2": "Summer2",
    "Summer session 10 Wk": "Summer10wk"
  };

  TextEditingController searchController = TextEditingController();

  String? selectedTerm;
  String? selectedQuarter;
  String? selectedDepartment;

  bool _searched = false;
  bool isIconPressed = false;

  List<Map<String, String>> filteredSuggestions = [];
  final FocusNode _searchFocusNode = FocusNode();

  void filterSuggestions(String query) {
    setState(() {
      _searched = false;
      _listItemClicked = true;
    });
    if (query.isNotEmpty) {
      final lowercaseQuery = query.toLowerCase();
      final pattern = RegExp(lowercaseQuery, caseSensitive: false);
      final results = <Map<String, String>>[];

      for (final entry in departments.entries) {
        if (pattern.hasMatch(entry.key) || pattern.hasMatch(entry.value)) {
          results.add({'Department': entry.key, 'Code': entry.value});
        }
      }
      setState(() {
        filteredSuggestions = results;
      });
    } else {
      setState(() {
        filteredSuggestions = [];
      });
    }
  }

  void clearSearch() {
    setState(() {
      filteredSuggestions = [];
    });
    _searchFocusNode.unfocus();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  bool _listItemClicked = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Consumer<BottomNavigationProvider>(builder: (context, data, _) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Schedule of Classes",
              style: TextStyle(
                color: Color.fromRGBO(47, 80, 97, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Color.fromRGBO(47, 80, 97, 1),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () {
                data.setIndex(0);
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(height * 0.01),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(height * 0.01),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(2, 84, 146, 1)
                                    .withOpacity(0.3),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: const Text(
                                    "Year",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 126, 126, 126),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  items: term
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedTerm,
                                  onChanged: (value) {
                                    print("value changed to ${value}");
                                    setState(() {
                                      selectedTerm = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(height * 0.01),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(2, 84, 146, 1)
                                    .withOpacity(0.3),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: const Text(
                                    "Term",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 126, 126, 126),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  items: quarter.keys
                                      .toList()
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedQuarter,
                                  onChanged: (value) {
                                    print("value changed to ${value}");
                                    setState(() {
                                      selectedQuarter = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.01,
                          bottom: height * 0.01,
                          right: width * 0.05,
                          left: width * 0.05,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(2, 84, 146, 1)
                                .withOpacity(0.3),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: filterSuggestions,
                                  controller: searchController,
                                  cursorColor:
                                      const Color.fromARGB(255, 126, 126, 126),
                                  decoration: const InputDecoration(
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 126, 126, 126),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.filter_alt),
                                color: isIconPressed
                                    ? Colors.red
                                    : const Color.fromRGBO(2, 84, 146, 1),
                                onSelected: (value) {
                                  print("Selected filter: $value");
                                  setState(() {
                                    isIconPressed = !isIconPressed;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: "option1",
                                      child: Text("Filter Option 1"),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "option2",
                                      child: Text("Filter Option 2"),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _listItemClicked,
                        child: Expanded(
                            child: ListView.builder(
                          itemCount: filteredSuggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = filteredSuggestions[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: height * 0.01,
                                right: width * 0.06,
                                left: width * 0.06,
                              ),
                              child: InkWell(
                                onTap: () {
                                  selectedDepartment = suggestion['Code'];
                                  searchController.text =
                                      suggestion['Department']!;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  setState(() {
                                    _searched = true;
                                    _listItemClicked = false;
                                  });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(2, 84, 146, 1),
                                          Color.fromRGBO(87, 191, 202, 1),
                                          Color.fromRGBO(2, 84, 146, 1),
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                    height: height * 0.04,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        suggestion['Department']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Expanded(
                          child: _searched == false
                              ? Container()
                              : SingleChildScrollView(
                                  child: FutureBuilder(
                                      future: getData(
                                          selectedTerm!,
                                          selectedQuarter!,
                                          selectedDepartment!),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        late dynamic courseData;
                                        String? courseDepartment;
                                        String? courseNumber;
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasData) {
                                          courseData = snapshot.data?["schools"]
                                              [0]["departments"][0]["courses"];
                                          // print(courseData);
                                          // courseDepartment = snapshot
                                          //         .data?["schools"][0]
                                          //     ["departments"][0]["deptCode"];
                                          // courseNumber = snapshot
                                          //             .data?["schools"][0]
                                          //         ["departments"][0]["courses"]
                                          //     [0]["courseNumber"];
                                        }
                                        return ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: courseData.length,
                                            shrinkWrap: true,
                                            itemBuilder: ((context, index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .grey, // shadow color
                                                              blurRadius:
                                                                  5, // how much the shadow is blurred
                                                              offset: Offset(0,
                                                                  3), // changes position of shadow
                                                              spreadRadius:
                                                                  2, // how much the shadow is spread
                                                            ),
                                                          ]),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    width *
                                                                        0.03,
                                                                    height *
                                                                        0.02,
                                                                    width *
                                                                        0.01,
                                                                    height *
                                                                        0.01),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    colors: [
                                                                      Color.fromRGBO(
                                                                          66,
                                                                          151,
                                                                          160,
                                                                          1),
                                                                      Color.fromRGBO(
                                                                          87,
                                                                          191,
                                                                          202,
                                                                          1),
                                                                      Color.fromRGBO(
                                                                          66,
                                                                          151,
                                                                          160,
                                                                          1),
                                                                    ],
                                                                    begin: Alignment
                                                                        .bottomLeft,
                                                                    end: Alignment
                                                                        .topRight,
                                                                  ),
                                                                ),
                                                                height: height *
                                                                    0.05,
                                                                width: width *
                                                                    0.25,
                                                                child: Center(
                                                                  child: Text(
                                                                    '${courseData[index]["deptCode"]} - ${courseData[index]["courseNumber"]}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          for (var i = 0;
                                                              i <
                                                                  courseData[index][
                                                                          "sections"]
                                                                      .length;
                                                              i++)
                                                            courseData[index]["sections"]
                                                                            [i][
                                                                        "sectionType"] ==
                                                                    "Lec"
                                                                ? Padding(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        width *
                                                                            0.03,
                                                                        height *
                                                                            0.005,
                                                                        width *
                                                                            0.01,
                                                                        height *
                                                                            0.005),
                                                                    child:
                                                                        courseScheduleTile(
                                                                      classIdCode:
                                                                          courseData[index]["sections"][i]
                                                                              [
                                                                              "sectionCode"],
                                                                      meetingDay:
                                                                          courseData[index]["sections"][i]["meetings"][0]
                                                                              [
                                                                              "days"],
                                                                      meetingTime:
                                                                          courseData[index]["sections"][i]["meetings"][0]
                                                                              [
                                                                              "time"],
                                                                      maxCapacity:
                                                                          courseData[index]["sections"][i]
                                                                              [
                                                                              "maxCapacity"],
                                                                      currentEnrollNum:
                                                                          courseData[index]["sections"][i]["numCurrentlyEnrolled"]
                                                                              [
                                                                              "totalEnrolled"],
                                                                      courseData:
                                                                          courseData[index]["sections"]
                                                                              [
                                                                              i],
                                                                      className:
                                                                          "${courseData[index]["deptCode"]}-${courseData[index]["courseNumber"]}",
                                                                      term:
                                                                          "$selectedQuarter $selectedTerm",
                                                                      deptCode:
                                                                          selectedDepartment!,
                                                                      courseNumber:
                                                                          courseData[index]
                                                                              [
                                                                              "courseNumber"],
                                                                      dept: courseData[
                                                                              index]
                                                                          [
                                                                          "deptCode"],
                                                                    ),
                                                                  )
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        DiscussionTile(
                                                                      meetingDay:
                                                                          courseData[index]["sections"][i]["meetings"][0]
                                                                              [
                                                                              "days"],
                                                                      meetingTime:
                                                                          courseData[index]["sections"][i]["meetings"][0]
                                                                              [
                                                                              "time"],
                                                                      maxCapacity:
                                                                          courseData[index]["sections"][i]
                                                                              [
                                                                              "maxCapacity"],
                                                                      currentEnrollNum:
                                                                          courseData[index]["sections"][i]["numCurrentlyEnrolled"]
                                                                              [
                                                                              "totalEnrolled"],
                                                                      courseData:
                                                                          courseData[index]["sections"]
                                                                              [
                                                                              i],
                                                                      className:
                                                                          "${courseData[index]["deptCode"]}-${courseData[index]["courseNumber"]}",
                                                                      term:
                                                                          "${selectedQuarter} ${selectedTerm}",
                                                                      classIdCode:
                                                                          courseData[index]["sections"][i]
                                                                              [
                                                                              "sectionCode"],
                                                                      deptCode:
                                                                          selectedDepartment!,
                                                                      courseNumber:
                                                                          courseData[index]
                                                                              [
                                                                              "courseNumber"],
                                                                      dept: courseData[
                                                                              index]
                                                                          [
                                                                          "deptCode"],
                                                                    ),
                                                                  )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }));
                                      })))
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
