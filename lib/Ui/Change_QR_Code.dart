import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Components/snackBar.dart';
import 'package:gym/Widgets/Button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class Change_QR_code_Screen extends StatefulWidget {
  const Change_QR_code_Screen({super.key});

  @override
  State<Change_QR_code_Screen> createState() => _Change_QR_code_ScreenState();
}

class _Change_QR_code_ScreenState extends State<Change_QR_code_Screen> {
  bool underProcessing = true;
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors().primaryColor,
        title: Text(
          "Change QR Code",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: underProcessing
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: pickQR(context),
            )
          : done(context),
    );
  }

  Widget done(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 120,
          ),
          Text(
            'You have been registered successfully',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget pickQR(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: InkWell(
                onTap: () {
                  _showImageSourceOptions(context);
                },
                child: Image.asset('lib/assets/QR.png'))),
        // SizedBox(
        //     width: double.infinity,
        //     height: 50,
        //     child: Button_Widget(context, 'Pick an QR Code', () {
        //       _pickImage();
        //     })),
        // const SizedBox(
        //   height: 10,
        // ),
        SizedBox(
            width: double.infinity,
            height: 50,
            child: Button_Widget(context, 'Proceed', () {
              CustomSnackBar(
                  context, const Text('QR Code Changed Successfully'));
            })),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
