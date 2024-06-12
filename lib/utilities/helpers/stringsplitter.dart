//This is a helper function which splits  the string into individual characters and then returns the List
List<String> stringSplit(String meetingTime) {
  var len = meetingTime.length;
  List<String> splitStringList = [];
  if (len == 1) {
    splitStringList = meetingTime.split("");
  } else if (len == 2) {
    if (meetingTime == "Tu" || meetingTime == "Th") {
      splitStringList[0] = meetingTime;
    } else {
      splitStringList = meetingTime.split("");
    }
  } else if (len == 3) {
    if (meetingTime.contains("Tu") || meetingTime.contains("Th")) {
      var indexOfT = meetingTime.indexOf("T");
      var subStr = meetingTime.substring(indexOfT, indexOfT + 2);
      splitStringList.add(subStr);
      meetingTime = meetingTime.replaceAll(subStr, "");
      splitStringList.add(meetingTime);
    } else {
      splitStringList = meetingTime.split("");
    }
  } else if (len == 4) {
    if (meetingTime.contains("Tu") && meetingTime.contains("Th")) {
      splitStringList.add("Tu");
      splitStringList.add("Th");
    } else if (meetingTime.contains("Tu") || meetingTime.contains("Th")) {
      var indexOfT = meetingTime.indexOf("T");
      var subStr = meetingTime.substring(indexOfT, indexOfT + 2);
      splitStringList.add(subStr);
      splitStringList.add(subStr);
      meetingTime.replaceAll(subStr, "");
      splitStringList.add(meetingTime);
    } else {
      splitStringList = meetingTime.split("");
    }
  }
  return splitStringList;
}
