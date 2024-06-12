import 'package:time_planner/time_planner.dart';
import 'package:flutter/material.dart';

class Calenders {
  String id = "";
  String title = "Fall 2023";
  Color? color;
  List<TimePlannerTask> calenderClasses = [];
  Calenders({required color, required title, required id}) {
    this.title = title;
    this.color = color;
    this.id = id;
  }

  String get getTitle => title;
  Color? get getColor => color;
  List<TimePlannerTask> getCalenderClass() => calenderClasses;

  factory Calenders.fromJson(Map<String, dynamic> json) {
    return Calenders(
        title: json["title"],
        color: Color(json["color"]),
        id: json["id"].toString());
  }
}
