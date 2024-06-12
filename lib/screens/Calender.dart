import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/providers/ScreenDataProvider.dart';
import 'package:notifyme/utilities/helpers/RandomColorGenerator.dart';
import 'package:notifyme/utilities/helpers/RandomIdGenerator.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  TextEditingController addCalendertextcontroller = new TextEditingController();
  TextEditingController editCalendertextController =
      new TextEditingController();
  final tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();
  }

  Future<List> fetchCalendars() async {
    print("called");
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/notifyme/calendars/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data. Error: ${response.statusCode}');
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Add Calenders"),
      content: Column(
        children: [
          TextField(
            onChanged: (value) {},
            controller: addCalendertextcontroller,
            decoration: InputDecoration(
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
            child: FloatingActionButton(
              onPressed: () async {
                var calenderName = addCalendertextcontroller.text;
                var id = generateRandomId();
                var color = generateRandomColor();
                Map<String, dynamic> requestData = {
                  'id': id,
                  'title': calenderName,
                  'color': color,
                };
                final response = await http.post(
                    Uri.parse("http://127.0.0.1:8000/notifyme/calendars/"),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(requestData));

                if (response.statusCode == 201 || response.statusCode == 200) {
                  print("created succesfullyy");
                } else {
                  print("Print Failed");
                }
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Center(
                child: Icon(Icons.done),
              ),
            ),
          )
        ],
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeleteDialog(
      BuildContext context, String calenderName, String calenderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Calender'),
          content: Text(
              "Are you sure you want to delete ${calenderName} id : ${calenderId} schedule ?"),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                final response = await http.delete(
                  Uri.parse(
                      "http://127.0.0.1:8000/notifyme/calendars/${calenderId}/"),
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

  showEditDialog(BuildContext context, String calenderName, String calenderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Calender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Edit your calender name before editing"),
              TextField(
                controller: editCalendertextController..text = calenderName,
                onChanged: (value) {
                  editCalendertextController.text = value;
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
                        "http://127.0.0.1:8000/notifyme/calendars/${calenderId}/"),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'email': 'sovitn@uci.edu',
                      'title': editCalendertextController.text
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
    double textSize = screenWidth * 0.045 * textScaleFactor;
    final bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    final screenDataProvider =
        Provider.of<ScreenDataProvider>(context, listen: true);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Calenders",
        onPressed: () {
          showAlertDialog(
            context,
          );
        },
        backgroundColor: const Color.fromRGBO(2, 84, 146, 1),
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(47, 80, 97, 1),
        ),
        leading: Container(),
        centerTitle: true,
        title: Row(
          children: [
            const Text(
              "Calendar",
              style: TextStyle(
                color: Color.fromRGBO(47, 80, 97, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  tooltipController.showTooltip();
                },
                child: JustTheTooltip(
                  controller: tooltipController,
                  content: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'This is the calendar page where you can add your tentative schedules. Edit the schedules or Add new calendars that you are planning to take next quarter',
                      style: TextStyle(color: Color(0XFFA7A7A7)),
                    ),
                  ),
                  child: const Icon(
                    Icons.info,
                    color: Color.fromARGB(255, 255, 0, 0),
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: FutureBuilder(
                        future: fetchCalendars(),
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
                            final calendars = snapshot.data!;
                            print(calendars);
                            return SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: calendars.length,
                                itemBuilder: (context, index) {
                                  final calendar = calendars[index];
                                  print(calendar);

                                  return GestureDetector(
                                    onTap: () {
                                      screenDataProvider.clearData();
                                      screenDataProvider.addData(
                                          "id", calendar['id']);
                                      setState(() {
                                        bottomNavigationProvider.setIndex(8);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Container(
                                            height: screenHeight * 0.1,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 175, 175, 175),
                                                  blurRadius: 10,
                                                  // offset: Offset(0, 5),
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
                                                width: parentWidth * 0.9,
                                                decoration: BoxDecoration(
                                                  color: Color(int.parse(
                                                          calendar["color"],
                                                          radix: 16))
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      const BorderRadius.only(
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
                                                        color: Color(int.parse(
                                                            calendar["color"],
                                                            radix: 16)),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Icon(
                                                          Icons.edit_calendar,
                                                          color: Color(int.parse(
                                                                  calendar[
                                                                      "color"],
                                                                  radix: 16))
                                                              .withAlpha(1000),
                                                          size: 32,
                                                        ),
                                                      ),
                                                      const Expanded(
                                                          flex: 1,
                                                          child: Center()),
                                                      Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      calendar[
                                                                          'title'],
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            textSize,
                                                                      ),
                                                                    ),
                                                                  )),
                                                              const Expanded(
                                                                  flex: 1,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "Created: 9/2/2023",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
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
                                                                              calendar['title'],
                                                                              calendar['id']);
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color: Color.fromRGBO(
                                                                              2,
                                                                              84,
                                                                              146,
                                                                              1),
                                                                          size:
                                                                              20,
                                                                        )),
                                                                  )),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Center(
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          showDeleteDialog(
                                                                              context,
                                                                              calendar['title'],
                                                                              calendar['id']);
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color: Color.fromRGBO(
                                                                              2,
                                                                              84,
                                                                              146,
                                                                              1),
                                                                          size:
                                                                              20,
                                                                        )),
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
              )),
        ],
      )),
    );
  }
}

class NotificationPageClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 100, 100);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}
