// ignore: file_names
import 'package:flutter/material.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/screens/Calender.dart';
import 'package:notifyme/screens/DashboardDisplay.dart';
import 'package:notifyme/screens/NotificationPage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notifyme/screens/Settings.dart';
import 'package:provider/provider.dart';

// Very Important: Credit to contributors <a href="https://www.flaticon.com/free-icons/calendar" title="calendar icons">Calendar icons created by Freepik - Flaticon</a>

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static String id = "dashboard_page";
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _index = 0;
  final List<Widget> _pages = [
    const DashboardDisplay(),
    const Calender(),
    const NotificationPage(),
    const Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(builder: (context, data, _) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: data.getScreen(),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: GNav(
                    backgroundColor: Colors.white,
                    color: Colors.white,
                    activeColor: Colors.white,
                    rippleColor: Colors.white.withOpacity(0.3),
                    haptic: true,
                    tabBorderRadius: 25,
                    tabBackgroundColor:
                        const Color.fromRGBO(2, 84, 146, 1).withOpacity(0.9),
                    curve: Curves.easeInOutQuad,
                    duration: const Duration(milliseconds: 175),
                    gap: 8,
                    iconSize: 25,
                    padding: const EdgeInsets.all(12),
                    tabs: [
                      GButton(
                        icon: Icons.dashboard,
                        text: 'Dashboard',
                        iconColor: const Color.fromRGBO(2, 84, 146, 1),
                        onPressed: () {
                          data.setIndex(0);
                          setState(() {});
                        },
                      ),
                      GButton(
                        icon: Icons.calendar_month,
                        text: 'Calendar',
                        iconColor: const Color.fromRGBO(2, 84, 146, 1),
                        onPressed: () {
                          data.setIndex(1);
                          setState(() {});
                        },
                      ),
                      GButton(
                        icon: Icons.notification_add,
                        text: 'Subscriptions',
                        iconColor: const Color.fromRGBO(2, 84, 146, 1),
                        onPressed: () {
                          data.setIndex(2);
                          setState(() {});
                        },
                      ),
                      GButton(
                        icon: Icons.settings,
                        text: 'Settings',
                        iconColor: const Color.fromRGBO(2, 84, 146, 1),
                        onPressed: () {
                          data.setIndex(3);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }
}
