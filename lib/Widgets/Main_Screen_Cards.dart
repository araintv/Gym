import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Widgets/Button.dart';

Widget Main_Screen_Cards(BuildContext context, IconData icon, String title,
    subtitle, btnText, Function btnFunction, Function wholeCardClick) {
  return Card(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(width: 0.5, color: Colors.black)),
    child: Container(
      color: Colors.white,
      width: double.infinity,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                wholeCardClick();
              },
              child: Card(
                color: AppColors().primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Button_Widget(context, btnText, () {
              btnFunction();
            })
          ],
        ),
      ),
    ),
  );
}
