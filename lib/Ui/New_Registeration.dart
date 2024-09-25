// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Components/snackBar.dart';
import 'package:gym/Ui/Payment_Screen.dart';
import 'package:gym/Widgets/Button.dart';
import 'package:gym/Widgets/DropDown_Menu.dart';
import 'package:gym/Widgets/GetTextInputField.dart';
import 'package:image_picker/image_picker.dart';

class New_Registeration_Screen extends StatefulWidget {
  String title;
  String? name, phone;
  New_Registeration_Screen(
      {super.key, required this.title, this.name, this.phone});

  @override
  State<New_Registeration_Screen> createState() =>
      _New_Registeration_ScreenState();
}

class _New_Registeration_ScreenState extends State<New_Registeration_Screen> {
  TextEditingController nameCntrl = TextEditingController();
  TextEditingController phoneNmbr = TextEditingController();
  String? membershipType, feePaid;
  File? _image;
  bool isLoading = false;

  void _pickImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context)
                        .pop(); // Close the bottom sheet after selection
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context)
                        .pop(); // Close the bottom sheet after selection
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _imgFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path); // Update the _image variable
      });
    }
  }

  Future<void> _imgFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path); // Update the _image variable
      });
    }
  }

  Future<void> _uploadData() async {
    if (widget.title == 'Membership Renewal') {
      // Ensure the phone number is entered
      if (membershipType == null || feePaid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Please provide phone number, membership duration, and fee.')),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Query Firestore to find the document with the matching phone number
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('customers')
            .where('phone_number', isEqualTo: widget.phone)
            .get();

        if (querySnapshot.docs.isEmpty) {
          // If no matching document is found
          CustomSnackBar(
              context, const Text('No member found with this phone number.'));
          setState(() {
            isLoading = false;
          });
          return;
        }

        // If a document is found, get the document ID
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the membership type and fee
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(documentId)
            .update({
          'membership_type': membershipType,
          'fee_paid': feePaid,
          'updated_at': Timestamp.now(),
        });

        await FirebaseFirestore.instance.collection('notifications').add({
          'title': widget.name.toString(),
          'header': 'Membership: $membershipType',
          'content': 'Membership renewal successfully..',
          'created_at': Timestamp.now(),
        });

        CustomSnackBar(context, const Text('Membership renewal successful!'));

        setState(() {
          membershipType = null;
          feePaid = null;
          phoneNmbr.clear();
        });

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Payment_Screen()));
      } catch (e) {
        CustomSnackBar(context, Text('Error: $e'));
      } finally {
        setState(() {
          isLoading = false; // Hide loader after updating
        });
      }
    } else {
      // Handle New Registration as before
      if (nameCntrl.text.isEmpty ||
          phoneNmbr.text.isEmpty ||
          membershipType == null ||
          feePaid == null ||
          _image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please fill all fields and upload an image')),
        );
        return;
      }

      setState(() {
        isLoading = true; // Show loader while uploading
      });

      try {
        // Upload image to Firebase Storage
        String imageFileName =
            'customers/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef =
            FirebaseStorage.instance.ref().child(imageFileName);
        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot storageSnapshot = await uploadTask;
        String downloadUrl = await storageSnapshot.ref.getDownloadURL();

        // Upload new customer data to Firestore
        await FirebaseFirestore.instance.collection('customers').add({
          'name': nameCntrl.text,
          'phone_number': phoneNmbr.text,
          'membership_type': membershipType,
          'fee_paid': feePaid,
          'image_url': downloadUrl,
          'created_at': Timestamp.now(),
        });

        // here below chatgpt, please sortout
        await FirebaseFirestore.instance.collection('earnings').add({
          'phone': phoneNmbr.text,
          'fees': feePaid, // Save the fee paid for the membership
          'membership':
              'Membership: $membershipType', // Indicate the membership type
          'created_at': Timestamp.now(),
        });

        await FirebaseFirestore.instance.collection('notifications').add({
          'title': nameCntrl.text,
          'header': 'Membership: $membershipType',
          'content': 'Registered a new member.',
          'created_at': Timestamp.now(),
        });

        CustomSnackBar(context, const Text('Registration successful!'));

        setState(() {
          _image = null;
          nameCntrl.clear();
          phoneNmbr.clear();
          membershipType = null;
          feePaid = null;
        });

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Payment_Screen()));
      } catch (e) {
        CustomSnackBar(context, Text('Error: $e'));
      } finally {
        setState(() {
          isLoading = false; // Hide loader after uploading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors().primaryColor,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title == 'New Registration') ...[
                GetTextInputField_Widget(
                    context, 'Name', TextInputType.name, nameCntrl),
                const SizedBox(height: 10),
                GetTextInputField_Widget(
                    context, 'Mobile Number', TextInputType.phone, phoneNmbr),
                const SizedBox(height: 15),
              ],
              Text(
                'Membership Type',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12)),
                child: CustDropDown(
                  items: const [
                    CustDropdownMenuItem(
                      value: "1 month",
                      child: Text("1 month"),
                    ),
                    CustDropdownMenuItem(
                      value: "2 months",
                      child: Text("2 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "3 months",
                      child: Text("3 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "6 months",
                      child: Text("6 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "12 months",
                      child: Text("12 months"),
                    ),
                  ],
                  hintText: "Select the Duration",
                  borderRadius: 5,
                  onChanged: (val) {
                    setState(() {
                      membershipType = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Fees',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12)),
                child: CustDropDown(
                  items: const [
                    CustDropdownMenuItem(
                      value: '500',
                      child: Text("500"),
                    ),
                    CustDropdownMenuItem(
                      value: '1000',
                      child: Text("1000"),
                    ),
                    CustDropdownMenuItem(
                      value: '1500',
                      child: Text("1500"),
                    ),
                    CustDropdownMenuItem(
                      value: '2000',
                      child: Text("2000"),
                    ),
                    CustDropdownMenuItem(
                      value: '2500',
                      child: Text("2500"),
                    ),
                  ],
                  hintText: "Select the Fee",
                  borderRadius: 5,
                  onChanged: (val) {
                    setState(() {
                      feePaid = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (widget.title == 'New Registration' && _image != null)
                Center(
                  child: Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              if (widget.title == 'New Registration')
                SizedBox(
                    width: double.infinity,
                    child: Button_Widget(context, 'Upload Photo', () {
                      _pickImage(context);
                    })),
              SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Button_Widget(context, 'Next', () {
                          _uploadData();
                        })),
            ],
          ),
        ),
      ),
    );
  }
}
