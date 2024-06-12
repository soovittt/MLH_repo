import '../constants/weekdayEncoding.dart';

/// This function takes a list of string days as input and converts each string into
/// the corresponding integer value according to the `weekdayEncode` map.

List<int> weekdayIntEncodingGenerator(List<String> weekdayStringList) {
  List<int> encodedList = [];
  for (var day in weekdayStringList) {
    print(day);
    encodedList.add(weekdayEncode[day]!);
  }
  return encodedList;
}
