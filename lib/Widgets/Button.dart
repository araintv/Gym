import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';

Widget Button_Widget(BuildContext context, String btnTitle, Function onClick) {
  return ElevatedButton(
    onPressed: () {
      onClick();
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors().primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // <-- Radius
      ),
    ),
    child: Text(
      btnTitle,
      style: GoogleFonts.poppins(color: Colors.white),
    ),
  );
}
