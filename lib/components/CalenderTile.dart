import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:time_planner/time_planner.dart';

class CalenderTile extends StatefulWidget {
  final double fontSize;
  const CalenderTile({Key? key, required this.fontSize}) : super(key: key);

  @override
  State<CalenderTile> createState() => _CalenderTileState();
}

class _CalenderTileState extends State<CalenderTile> {
  @override
  Widget build(BuildContext context) {
    return TimePlannerTask(
      // background color for task
      color: Colors.purple,
      // day: Index of header, hour: Task will be begin at this hour
      // minutes: Task will be begin at this minutes
      dateTime: TimePlannerDateTime(day: 1, hour: 8, minutes: 00),
      // Minutes duration of task
      minutesDuration: 30,
      // Days duration of task (use for multi days task)
      daysDuration: 1,
      onTap: () {},
      child: Column(children: [
        Center(
          child: Text(
            "EECS 50",
            style: TextStyle(fontSize: widget.fontSize),
          ),
        )
      ]),
    );
  }
}
