// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Ui/New_Registeration.dart';
import 'package:gym/Ui/Payment_Screen.dart';
import 'package:gym/Ui/Update_Infor.dart';
import 'package:gym/Widgets/Button.dart';

class Registered_Users extends StatefulWidget {
  String title, heading, status, image;
  Color statusColor;
  Function onClick, update, renue;
  Registered_Users(
      {super.key,
      required this.image,
      required this.title,
      required this.heading,
      required this.status,
      required this.onClick,
      required this.update,
      required this.renue,
      required this.statusColor});

  @override
  State<Registered_Users> createState() => _Registered_UsersState();
}

class _Registered_UsersState extends State<Registered_Users> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: AppColors().greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30, // Image radius
                backgroundImage: NetworkImage(widget.image),
              ),
              SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    widget.update();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.heading,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.status,
                        style: GoogleFonts.poppins(color: widget.statusColor),
                      )
                    ],
                  ),
                ),
              ),
              Button_Widget(context, 'Renue', () {
                widget.renue();
              })
            ],
          ),
        ));
  }
}
