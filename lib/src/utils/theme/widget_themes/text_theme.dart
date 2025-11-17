import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Assuming 'tDarkColor' and 'tWhiteColor' are defined constants
// For this example, I'll use Colors.black and Colors.white as placeholders.
// You should define your actual color constants if you haven't already.
const Color tDarkColor = Colors.black;
const Color tWhiteColor = Colors.white;

class TTextTheme {
  // Use 'static const' for better performance and to indicate that
  // these themes are constant.
  static final TextTheme LightTextTheme = TextTheme(
    // M2: headline1 -> M3: displayLarge
    displayLarge: GoogleFonts.montserrat(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: tDarkColor,
    ),
    // M2: headline2 -> M3: headlineLarge (or displayMedium)
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: tDarkColor,
    ),
    // M2: headline3 -> M3: headlineMedium
    headlineMedium: GoogleFonts.poppins(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: tDarkColor,
    ),
    // M2: headline4 -> M3: titleLarge
    titleLarge: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: tDarkColor,
    ),
    // M2: headline5 -> M3: titleMedium
    titleMedium: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: tDarkColor,
    ),
    // M2: bodyText1 -> M3: bodyLarge
    bodyLarge: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: tDarkColor,
    ),
    // M2: bodyText2 -> M3: bodyMedium
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: tDarkColor,
    ),
  );

  static final TextTheme DarkTextTheme = TextTheme(
    // M2: headline1 -> M3: displayLarge
    displayLarge: GoogleFonts.montserrat(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: tWhiteColor,
    ),
    // M2: headline2 -> M3: headlineLarge
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: tWhiteColor,
    ),
    // M2: headline3 -> M3: headlineMedium
    headlineMedium: GoogleFonts.poppins(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: tWhiteColor,
    ),
    // M2: headline4 -> M3: titleLarge
    titleLarge: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: tWhiteColor,
    ),
    // M2: headline5 -> M3: titleMedium
    titleMedium: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: tWhiteColor,
    ),
    // M2: bodyText1 -> M3: bodyLarge
    bodyLarge: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: tWhiteColor,
    ),
    // M2: bodyText2 -> M3: bodyMedium
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: tWhiteColor,
    ),
  );
}