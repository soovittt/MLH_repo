import 'package:flutter/material.dart';
import 'package:notifyme/screens/CalenderDetail.dart';
import 'package:notifyme/screens/Catalogue.dart';
import 'package:notifyme/screens/MapScreen.dart';
import 'package:notifyme/screens/NavigationScreen.dart';
import 'package:notifyme/screens/NotificationPage.dart';
import 'package:notifyme/screens/Planner.dart';
import 'package:notifyme/screens/PlannerDetail.dart';
import 'package:notifyme/screens/ScheduleSearchPage.dart';

import '../screens/Calender.dart';
import '../screens/DashboardDisplay.dart';
import '../screens/Settings.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _index = 0;

  final List<Widget> _screens = [
    const DashboardDisplay(), //0
    const Calender(), //1
    const NotificationPage(), //2
    const Settings(), //3
    const ScheduleSearchPage(), //4
    const Catalogue(), //5
    const Planner(), //6
    const PlannerDetail(), //7,
    const CalenderDetail(), //8
    const MapScreen(), //9
    const NavigationScreen() //10
  ];

  int getIndex() {
    return _index;
  }

  void setIndex(int ind) {
    _index = ind;
    notifyListeners();
  }

  Widget getScreen() {
    return _screens[_index];
  }
}
// Irvinehacks_notifyme