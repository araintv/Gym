import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Components/snackBar.dart';
import 'package:gym/Widgets/Button.dart';
import 'package:gym/Widgets/DropDown_Menu.dart';
import 'package:gym/Widgets/GetTextInputField.dart';

class Deleting_Offer_Screen extends StatefulWidget {
  const Deleting_Offer_Screen({super.key});

  @override
  State<Deleting_Offer_Screen> createState() => _Deleting_Offer_ScreenState();
}

class _Deleting_Offer_ScreenState extends State<Deleting_Offer_Screen> {
  TextEditingController nameCntrl = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().primaryColor,
        elevation: 10,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 30,
                )),
            Text(
              'Existing Offer',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                CustomSnackBar(
                    context, const Text('Existing offer deleted successfully'));
              },
              child: const Icon(
                Icons.delete,
                size: 30,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetTextInputField_Widget(
                context, 'Custom Offer Title', TextInputType.name, nameCntrl),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Select Membership Type',
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
                    value: 0,
                    child: Text("1 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 1,
                    child: Text("2 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 2,
                    child: Text("3 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 3,
                    child: Text("4 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 4,
                    child: Text("5 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 5,
                    child: Text("6 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 6,
                    child: Text("7 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 7,
                    child: Text("8 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 8,
                    child: Text("9 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 9,
                    child: Text("10 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 10,
                    child: Text("11 month"),
                  ),
                  CustDropdownMenuItem(
                    value: 11,
                    child: Text("12 month"),
                  ),
                ],
                hintText: "Select the Duration",
                borderRadius: 5,
                onChanged: (val) {
                  print(val);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Set Custom Price',
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
                    value: 0,
                    child: Text("500"),
                  ),
                  CustDropdownMenuItem(
                    value: 1,
                    child: Text("1000"),
                  ),
                  CustDropdownMenuItem(
                    value: 2,
                    child: Text("1500"),
                  ),
                  CustDropdownMenuItem(
                    value: 3,
                    child: Text("2000"),
                  ),
                  CustDropdownMenuItem(
                    value: 4,
                    child: Text("2500"),
                  ),
                  CustDropdownMenuItem(
                    value: 5,
                    child: Text("3000"),
                  ),
                  CustDropdownMenuItem(
                    value: 6,
                    child: Text("3500"),
                  ),
                  CustDropdownMenuItem(
                    value: 7,
                    child: Text("4000"),
                  ),
                  CustDropdownMenuItem(
                    value: 8,
                    child: Text("4500"),
                  ),
                  CustDropdownMenuItem(
                    value: 9,
                    child: Text("5000"),
                  ),
                ],
                hintText: "Select the Price",
                borderRadius: 5,
                onChanged: (val) {
                  print(val);
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                    child: Button_Widget(context, 'Update Offer', () {
                  CustomSnackBar(context,
                      const Text('Existing offer updated successfully'));
                })),
              ],
            )
          ],
        ),
      ),
    );
  }
}
