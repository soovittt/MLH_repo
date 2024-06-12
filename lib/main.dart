import 'package:flutter/material.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/providers/ScreenDataProvider.dart';
import 'package:notifyme/screens/Dashboard.dart';
import 'package:notifyme/screens/ScheduleSearchPage.dart';
import 'package:provider/provider.dart';
import 'classes/NotificationController.dart';
import 'firebase_options.dart';
import 'screens/EntryPage.dart';
import 'package:notifyme/providers/CalenderProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CalenderProvider>(
        create: (context) => CalenderProvider(),
      ),
      ChangeNotifierProvider<BottomNavigationProvider>(
          create: (context) => BottomNavigationProvider()),
      ChangeNotifierProvider<ScreenDataProvider>(
          create: (context) => ScreenDataProvider()),
    ],
    child: const MyApp(),
  ));
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupName: 'Basic group',
          channelGroupKey: 'basic_channel_group',
        )
      ],
      debug: true);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotifyMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Ubuntu'),
      initialRoute: EntryPage.id,
      routes: {
        EntryPage.id: (context) => const EntryPage(),
        Dashboard.id: (context) => const Dashboard(),
        ScheduleSearchPage.id: (context) => const ScheduleSearchPage(),
      },
    );
  }
}
