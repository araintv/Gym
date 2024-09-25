import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Components/snackBar.dart';
import 'package:gym/Widgets/Button.dart';
import 'package:gym/Widgets/DropDown_Menu.dart';
import 'package:gym/Widgets/GetTextInputField.dart';

class Update_Info extends StatefulWidget {
  final String name;
  final String phone;
  final String image;
  final String documentId;

  Update_Info({
    super.key,
    required this.name,
    required this.phone,
    required this.image,
    required this.documentId,
  });

  @override
  State<Update_Info> createState() => _Update_InfoState();
}

class _Update_InfoState extends State<Update_Info> {
  late TextEditingController nameCntrl;
  late TextEditingController phoneNmbr;
  String? image;
  String? membershipType;
  String? feePaid;
  bool isLoading = false; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    nameCntrl = TextEditingController(text: widget.name);
    phoneNmbr = TextEditingController(text: widget.phone);
    image = widget.image;
  }

  @override
  void dispose() {
    nameCntrl.dispose();
    phoneNmbr.dispose();
    super.dispose();
  }

  Future<void> updateMember() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      Map<String, dynamic> dataToUpdate = {
        'name': nameCntrl.text,
        'phone_number': phoneNmbr.text,
      };

      if (membershipType != null) {
        dataToUpdate['membership_type'] = membershipType;
      }
      if (feePaid != null) {
        dataToUpdate['fee_paid'] = feePaid;
      }

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.documentId)
          .update(dataToUpdate);

      await FirebaseFirestore.instance.collection('notifications').add({
        'title': widget.name.toString(),
        'header': 'New details',
        'content': 'User details updated succuessfully',
        'created_at': Timestamp.now(),
      });

      CustomSnackBar(context, Text('Updated Successfully.'));
      Navigator.pop(context);
    } catch (e) {
      CustomSnackBar(context, Text('Error: $e'));
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
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
          'Update Details',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetTextInputField_Widget(
                  context, 'Name', TextInputType.name, nameCntrl),
              const SizedBox(height: 10),
              GetTextInputField_Widget(
                  context, 'Phone Number', TextInputType.phone, phoneNmbr),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 150,
                child: Image.network(
                  image!,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Membership Type (Optional)',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 10),
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
                      value: "4 months",
                      child: Text("4 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "5 months",
                      child: Text("5 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "6 months",
                      child: Text("6 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "7 months",
                      child: Text("7 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "8 months",
                      child: Text("8 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "9 months",
                      child: Text("9 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "10 months",
                      child: Text("10 months"),
                    ),
                    CustDropdownMenuItem(
                      value: "11 months",
                      child: Text("11 months"),
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
                      membershipType = val; // Update membership type
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Fees (Optional)',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 10),
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
                    CustDropdownMenuItem(
                      value: '3000',
                      child: Text("3000"),
                    ),
                    CustDropdownMenuItem(
                      value: '3500',
                      child: Text("3500"),
                    ),
                    CustDropdownMenuItem(
                      value: '4000',
                      child: Text("4000"),
                    ),
                    CustDropdownMenuItem(
                      value: '4500',
                      child: Text("4500"),
                    ),
                    CustDropdownMenuItem(
                      value: '5000',
                      child: Text("5000"),
                    ),
                  ],
                  hintText: "Select the Fee",
                  borderRadius: 5,
                  onChanged: (val) {
                    setState(() {
                      feePaid = val; // Update fee paid
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: isLoading
                    ? CircularProgressIndicator() // Show circular progress indicator while loading
                    : SizedBox(
                        width: double.infinity,
                        child: Button_Widget(context, 'Update', () {
                          updateMember(); // Call update function
                        }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
