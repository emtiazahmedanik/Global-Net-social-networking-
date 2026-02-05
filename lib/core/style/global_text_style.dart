import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle globalTextStyle({
  double fontSize = 15.0,
  FontWeight fontWeight = FontWeight.normal,
  double lineHeight = 1.5,
  TextAlign textAlign = TextAlign.center,
  Color color = Colors.black,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: lineHeight,
    color: color,
  );
}
