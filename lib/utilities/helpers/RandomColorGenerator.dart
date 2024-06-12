import 'dart:math';

String generateRandomColor() {
  final random = Random();
  final r = random.nextInt(256); // Random value for red component
  final g = random.nextInt(256); // Random value for green component
  final b = random.nextInt(256); // Random value for blue component
  final colorCode = 0xFF000000 +
      (r << 16) +
      (g << 8) +
      b; // Generate color code in hexadecimal format
  return colorCode.toRadixString(16).padLeft(8, '0');
}
