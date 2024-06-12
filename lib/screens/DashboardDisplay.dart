import 'package:flutter/material.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/screens/MapScreen.dart';
import 'package:notifyme/screens/ScheduleSearchPage.dart';
import 'package:provider/provider.dart';

import 'Catalogue.dart';
import 'Planner.dart';

class DashboardDisplay extends StatefulWidget {
  const DashboardDisplay({super.key});

  @override
  State<DashboardDisplay> createState() => _DashboardDisplayState();
}

class _DashboardDisplayState extends State<DashboardDisplay> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final double topMargin = height * 0.025;
    final double sideMargin = height * 0.03;

    final double cardParentheight = height * 0.25;
    // final double cardChildheight = ;

    return Consumer<BottomNavigationProvider>(builder: (context, data, _) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: height * 0.0505,
                        child: const Text(
                          'Hello Sovit!👋',
                          style: TextStyle(
                            color: Color.fromRGBO(47, 80, 97, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.3),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor:
                              const Color.fromRGBO(66, 151, 160, 1),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: height * 0.05,
                              height: height * 0.05,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(
                              Icons.notifications,
                              size: 30.0,
                              color: Color.fromRGBO(66, 151, 160, 1),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: height * 0.007,
                                height: height * 0.007,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 255, 66, 52),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: cardParentheight,
                          margin: EdgeInsets.only(
                            top: 15,
                            right: sideMargin,
                            left: sideMargin,
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(251, 239, 205, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/courses.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: height * 0.17,
                                  width: width * 0.83,
                                  margin: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(228, 243, 159, 33),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 25,
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Schedule',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Find out what classes are available for enrollment in Fall 2023',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 35,
                                right: 35,
                                height: height * 0.035,
                                child: ElevatedButton(
                                  onPressed: () {
                                    data.setIndex(4);
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(228, 243, 159, 33),
                                  ),
                                  child: const Text('View Classes'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: cardParentheight,
                          margin: EdgeInsets.only(
                            top: topMargin,
                            right: sideMargin,
                            left: sideMargin,
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 212, 206, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/map.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: height * 0.17,
                                  width: width * 0.83,
                                  margin: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        230, 255, 131, 112),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 25,
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Maps',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Lost on campus? Find out your way to a destination                                                         ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 35,
                                right: 35,
                                height: height * 0.035,
                                child: ElevatedButton(
                                  onPressed: () {
                                    data.setIndex(9);
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    backgroundColor:
                                        const Color.fromRGBO(255, 131, 112, 1),
                                  ),
                                  child: const Text('Navigate'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: cardParentheight,
                          margin: EdgeInsets.only(
                            top: topMargin,
                            right: sideMargin,
                            left: sideMargin,
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(171, 186, 253, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/catalogue.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: height * 0.17,
                                  width: width * 0.83,
                                  margin: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                        82, 114, 255, 0.897),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 25,
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Catalogue',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Explore available programs at UC Irvine                                        ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 35,
                                right: 35,
                                height: height * 0.035,
                                child: ElevatedButton(
                                  onPressed: () {
                                    data.setIndex(5);
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      backgroundColor: const Color.fromRGBO(
                                          82, 113, 255, 1)),
                                  child: const Text('Discover Programs'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: cardParentheight,
                          margin: EdgeInsets.only(
                            top: topMargin,
                            right: sideMargin,
                            left: sideMargin,
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 193, 209, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/planner.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: height * 0.17,
                                  width: width * 0.83,
                                  margin: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(228, 228, 34, 86),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 25,
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Planner',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Create an effective course plan for your next quarter',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 35,
                                right: 35,
                                height: height * 0.035,
                                child: ElevatedButton(
                                  onPressed: () {
                                    data.setIndex(6);
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    backgroundColor:
                                        const Color.fromRGBO(228, 34, 86, 1),
                                  ),
                                  child: const Text('Plan Ahead'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
