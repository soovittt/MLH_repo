//This is a random Id generator helper function . Used temporarily and will be removed
//later
import 'dart:math';

String generateRandomId() {
  Random random = Random();
  int min = 100000;
  int max = 999999;
  int randomNumber = min + random.nextInt(max - min);
  return randomNumber.toString();
}
