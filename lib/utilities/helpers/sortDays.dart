import 'package:notifyme/utilities/constants/weekdayEncoding.dart';

List<String> sortDays(List<String> strList) {
  strList.sort((a, b) => weekdayEncode[a]!.compareTo(weekdayEncode[b]!));
  return strList;
}
