import 'package:flutter/material.dart';
import 'package:notifyme/utilities/helpers/integerParser.dart';

List<String> getQuarters(String planType) {
  List<String> quarterList = [];
  List<String> quarters = ['Fall', 'Winter', 'Spring', 'Summer'];
  DateTime now = DateTime.now();
  int currentYear = now.year;
  if (planType == '2-year') {
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < quarters.length; j++) {
        quarterList.add("${quarters[j]}-${currentYear + i}");
      }
    }
  } else if (planType == '3-year') {
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < quarters.length; j++) {
        quarterList.add("${quarters[j]}-${currentYear + i}");
      }
    }
  } else if (planType == '4-year') {
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < quarters.length; j++) {
        quarterList.add("${quarters[j]}-${currentYear + i}");
      }
    }
  } else if (planType == '5-year') {
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < quarters.length; j++) {
        quarterList.add("${quarters[j]}-${currentYear + i}");
      }
    }
  }

  return quarterList;
}
