import 'package:flutter/material.dart';

import '../responsive/responsive.dart';

class CustomTextTheme {
  TextTheme getTextTheme(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);

    return TextTheme(
      // Define various text styles here with different font sizes based on screen size
      titleLarge: TextStyle(fontSize: isDesktop ? 18.0 : 14.0, fontFamily: 'IR'
          // Other properties...
          ),
      titleMedium: TextStyle(
          fontSize: isDesktop ? 14.0 : 12.0,
          fontFamily: 'IR',
          fontWeight: FontWeight.w700
          // Other properties...
          ),
      titleSmall: TextStyle(
          fontSize: isDesktop ? 12.0 : 10.0,
          fontFamily: 'IR',
          fontWeight: FontWeight.w400
          // Other properties...
          ),
      bodySmall: TextStyle(
          fontSize: isDesktop ? 14.0 : 12.0,
          fontFamily: 'IR',
          fontWeight: FontWeight.w400,
          color: Colors.white
          // Other properties...
          ),
      // Add more text styles as needed...
    );
  }
}
