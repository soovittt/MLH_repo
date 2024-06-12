import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

import '../classes/Calenders.dart';

class CalenderProvider implements ChangeNotifier {
  List<Calenders> _calenders = [];

  List<Calenders> get calenders => _calenders;

  void addCalender(Calenders calender) {
    _calenders.insert(0, calender);
    notifyListeners();
  }

  void addTimePlannerTask(TimePlannerTask task, String id) {
    for (var calender in _calenders) {
      if (calender.id == id) {
        calender.calenderClasses.add(task);
        print("added");
      }
    }
  }

  List<TimePlannerTask> getListTimePlannerTask(String id) {
    List<TimePlannerTask> taskList = [];
    for (var calender in _calenders) {
      if (calender.id == id) {
        taskList = calender.getCalenderClass();
      }
    }
    return taskList;
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  void maybeDispatchObjectCreation() {
    // TODO: implement maybeDispatchObjectCreation
  }
}
