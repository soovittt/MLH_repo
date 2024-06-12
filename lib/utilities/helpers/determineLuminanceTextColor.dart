import 'dart:ui';

import 'package:flutter/material.dart';

Color determineTextColor(Color backgroundColor) {
  // Calculate relative luminance
  final luminance = (0.299 * backgroundColor.red +
          0.587 * backgroundColor.green +
          0.114 * backgroundColor.blue) /
      255;

  // Use black text on light backgrounds and white text on dark backgrounds
  return luminance > 0.5 ? Colors.black : Colors.white;
}
