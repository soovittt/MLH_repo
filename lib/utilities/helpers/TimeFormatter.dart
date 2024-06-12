//This function formats the time

Map<String, dynamic> formatmeetingTime(String time) {
  Map<String, dynamic> data = {};
  String meridiem = "";
  List<String> parts = time.split('-');
  String startTime = parts[0].trim();
  String endTime = parts[1].trim();

  List<String> startParts = startTime.split(':');
  int startHour = int.parse(startParts[0]);
  int startMinute = int.parse(startParts[1]);

  List<String> endParts = endTime.split(':');

  int endHour = int.parse(endParts[0]);
  meridiem = endParts[1][endParts[1].length - 1] == "p" ? "pm" : "am";
  int endMinute = meridiem == "pm"
      ? int.parse(endParts[1].substring(0, endParts[1].length - 1))
      : int.parse(endParts[1]);
  DateTime startDateTime = DateTime(
      2000,
      1,
      1,
      meridiem == "pm" && startHour != 12 ? startHour + 12 : startHour,
      startMinute);
  DateTime endDateTime = DateTime(2000, 1, 1,
      meridiem == "pm" && endHour != 12 ? endHour + 12 : startHour, endMinute);

  int startMilliseconds = startDateTime.millisecondsSinceEpoch;
  int endMilliseconds = endDateTime.millisecondsSinceEpoch;

  int minuteDifference =
      (endMilliseconds - startMilliseconds) ~/ Duration.millisecondsPerMinute;

  data = {
    "startTime": startTime,
    "startHour": meridiem == "pm"
        ? (startHour == 12 ? startHour : startHour + 12)
        : startHour,
    "startMinute": startMinute,
    "duration": minuteDifference,
    "meridiem": meridiem,
  };

  return data;
}
