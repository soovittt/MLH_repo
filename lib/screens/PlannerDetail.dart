import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/providers/ScreenDataProvider.dart';
import 'package:notifyme/screens/Planner.dart';
import 'package:notifyme/utilities/constants/departments.dart';
import 'package:notifyme/utilities/helpers/convertUrlPatternToNormal.dart';
import 'package:notifyme/utilities/helpers/countTotalUnits.dart';
import 'package:notifyme/utilities/helpers/getQuarters.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PlannerDetail extends StatefulWidget {
  const PlannerDetail({super.key});

  @override
  State<PlannerDetail> createState() => _PlannerDetailState();
}

class _PlannerDetailState extends State<PlannerDetail> {
  String? selectedDepartment;
  TextEditingController classCodeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenDataProvider =
        Provider.of<ScreenDataProvider>(context, listen: true);

    final bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);

    dynamic plannerData = screenDataProvider.getData();
    List<String> quarterList = getQuarters(plannerData["type"]);

    WebViewController webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(plannerData["major_url"]));

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Future<Map<String, dynamic>> fetchPlannersDetail() async {
      Map<String, dynamic> requestData = {
        'email': 'sovitn@uci.edu',
        'id': plannerData['id']
      };
      final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/notifyme/planner/detail/get/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestData));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch data. Error: ${response.statusCode}');
      }
    }

    void stateUpdate() {
      setState(() {});
    }

    showAlertDialog(String quarter) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text("Add Classes"),
                content: Column(
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
                            isExpanded: true,
                            hint: const Text(
                              "Department",
                              style: TextStyle(
                                color: Color.fromARGB(255, 126, 126, 126),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            items: departments.keys
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
                            value: selectedDepartment,
                            onChanged: (value) {
                              print("value changed to ${value}");
                              setState(() {
                                selectedDepartment = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: classCodeController,
                      decoration: InputDecoration(
                          hintText: "Class Code EX - 2B , 2D",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1,
                              style: BorderStyle.none,
                            ),
                          )),
                      onChanged: (value) {},
                    ),
                    Center(
                      child: FloatingActionButton(
                        onPressed: () async {
                          print("yes");
                          final response = await http.patch(
                              Uri.parse(
                                  "http://127.0.0.1:8000/notifyme/planner/detail/update/"),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'email': 'sovitn@uci.edu',
                                'department_name': selectedDepartment,
                                'department_url_code':
                                    convertUrlPatternToNormal(
                                        departments[selectedDepartment]!),
                                'code': classCodeController.text,
                                'planner_id': plannerData['id'],
                                'quarter': quarter
                              }));
                          // print("response :  ${response.statusCode}");
                          if (response.statusCode == 404) {
                            Navigator.of(context).pop();
                            const snackdemo = SnackBar(
                              content: Text('No such class available !'),
                              backgroundColor: Colors.green,
                              elevation: 10,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(5),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackdemo);
                          } else if (response.statusCode == 200) {
                            Navigator.of(context).pop();
                            stateUpdate();
                          }
                        },
                        child: Icon(Icons.done),
                      ),
                    )
                  ],
                ),
              );
            });
          });
        },
      );
    }

    showDeleteDialog(BuildContext context, String className, String plannerId,
        String plannerName, String quarter) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Planner'),
            content: Text(
                "Are you sure you want to delete ${className} : ${plannerId} planner ?"),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  final response = await http.delete(
                      Uri.parse(
                          "http://127.0.0.1:8000/notifyme/planner/detail/delete/"),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'email': 'sovitn@uci.edu',
                        'id': plannerId,
                        'className': className,
                        'quarter': quarter
                      }));
                  if (response.statusCode == 201 ||
                      response.statusCode == 200) {
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

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 230, 223, 223),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(66, 151, 160, 1),
          leading: IconButton(
              onPressed: () {
                screenDataProvider.clearData();
                bottomNavigationProvider.setIndex(6);
              },
              icon: const Icon(Icons.arrow_back)),
          title: Text(plannerData['title']),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            contentPadding: EdgeInsets.zero,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            title: const Text("Helper"),
                            content: Builder(
                              builder: (context) {
                                return SizedBox(
                                  height: height - height / 3,
                                  width: width - width / 20,
                                  child:
                                      WebViewWidget(controller: webController),
                                );
                              },
                            ),
                          ));
                },
                icon: const Icon(Icons.info))
          ],
        ),
        body: FutureBuilder(
            future: fetchPlannersDetail(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else if (snapshot.hasData) {
                Map<String, dynamic>? data = snapshot.data;
                // String plannerTitle = data!["title"];
                Map<String, dynamic> plannerClasses = data!["data"];

                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: plannerClasses.keys.toList().length,
                          itemBuilder: (context, index) {
                            String plannerTile =
                                plannerClasses.keys.toList()[index];
                            Map<String, dynamic> classes =
                                plannerClasses[plannerTile]["classes"] ?? {};
                            int? total_units = countTotalUnits(classes);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FractionallySizedBox(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(plannerTile),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  // print(plannerClasses[
                                                  //     plannerTile]["id"]);
                                                  showAlertDialog(plannerTile);
                                                },
                                                icon: const Icon(Icons.add))
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Table(
                                            children: [
                                              const TableRow(children: [
                                                Center(
                                                  child: Text(
                                                    "SL.NO",
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    "Class",
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    "Units",
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                Center()
                                              ]),
                                              for (var entry in classes.entries)
                                                TableRow(children: [
                                                  Center(
                                                    child: Text(
                                                      entry.value["index"],
                                                      style: const TextStyle(
                                                          fontSize: 15.0),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      entry.key,
                                                      style: const TextStyle(
                                                          fontSize: 15.0),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      entry.value["units"],
                                                      style: const TextStyle(
                                                          fontSize: 15.0),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDeleteDialog(
                                                            context,
                                                            entry.key,
                                                            plannerData['id'],
                                                            plannerData[
                                                                'title'],
                                                            plannerTile);
                                                      },
                                                      icon: const Icon(
                                                          Icons.remove))
                                                ]),
                                              TableRow(children: [
                                                const Center(
                                                  child: Text(
                                                    "Total",
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                const Center(
                                                  child: Text(
                                                    "",
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    total_units.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                Center()
                                              ])
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }
              return const Center();
            }));
  }
}
