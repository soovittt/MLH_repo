import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List> fetchSubscribedClasses() async {
    Map<String, dynamic> requestData = {
      'email': 'sovitn@uci.edu',
    };
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/notifyme/subscribed/classes/get/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data. Error: ${response.statusCode}');
    }
  }

// subscribed/classes/delete/

  showDeleteDialog(BuildContext context, String classId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unsubscribe class'),
          content: Text(
              "Are you sure you want to delete ${classId} from subscribed classes"),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                final response = await http.delete(
                    Uri.parse(
                        "http://127.0.0.1:8000/notifyme/subscribed/classes/delete/"),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(
                        {'email': 'sovitn@uci.edu', 'class_id': classId}));
                if (response.statusCode == 201 || response.statusCode == 200) {
                  print("deleted succesfullyy");
                } else {
                  print("Print Failed");
                }
                setState(() {});
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

    return Scaffold(
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
                                'This is the Notification Subsciption page where where you can see what classes you are subscribed to. The subscribed classes are the classes for which you will recieve notifications. You can add more subscribed classes from the schedule page.',
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
                      "Notification",
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
                  padding: EdgeInsets.all(8.0),
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: FutureBuilder(
                              future: fetchSubscribedClasses(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else if (snapshot.hasData) {
                                  final subscribedClasses = snapshot.data!;
                                  return SingleChildScrollView(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: subscribedClasses.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var notifications =
                                              subscribedClasses[index];
                                          print(notifications);
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0XFFF4F6FF),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(5),
                                                        bottomLeft:
                                                            Radius.circular(5),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                        topRight:
                                                            Radius.circular(15),
                                                      ),
                                                    ),
                                                    child: LayoutBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            BoxConstraints
                                                                constraints) {
                                                      double secondParentWidth =
                                                          constraints.maxWidth;
                                                      double
                                                          secondParentHeight =
                                                          constraints.maxHeight;
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              height:
                                                                  secondParentHeight,
                                                              width:
                                                                  secondParentWidth *
                                                                      0.02,
                                                              color: Color(int.parse(
                                                                  notifications[
                                                                      "color"],
                                                                  radix: 16))),
                                                          const Expanded(
                                                            flex: 1,
                                                            child: Center(),
                                                          ),
                                                          Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          notifications[
                                                                              'title'],
                                                                          style:
                                                                              TextStyle(fontSize: textSize),
                                                                        ),
                                                                      )),
                                                                  const Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child: Text(
                                                                            "created : 9/2/2023"),
                                                                      )),
                                                                ],
                                                              )),
                                                          Expanded(
                                                              flex: 1,
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Center()),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Center(
                                                                        child: IconButton(
                                                                            onPressed: () {
                                                                              showDeleteDialog(context, notifications["class_id"]);
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
                                          );
                                        }),
                                  );
                                }
                                return const Center();
                              }))
                    ],
                  ),
                ),
              )),
        ],
      )),
    );
  }
}
