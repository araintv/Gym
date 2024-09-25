import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Ui/Main_Screen.dart';
import 'package:gym/Widgets/Button.dart';

class Payment_Screen extends StatefulWidget {
  const Payment_Screen({super.key});

  @override
  State<Payment_Screen> createState() => _Payment_ScreenState();
}

class _Payment_ScreenState extends State<Payment_Screen> {
  bool underProcessing = true;
  @override
  Widget build(BuildContext context) {
    return underProcessing ? underProcess(context) : complete(context);
  }

  Widget complete(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              },
              child: Icon(
                Icons.close,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Center(
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
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget underProcess(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors().primaryColor,
        title: Text(
          'Payment Gateway',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: Image.asset('lib/assets/QR.png')),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: Button_Widget(context, 'Proceed', () {
                  setState(() {
                    underProcessing = false;
                  });
                })),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
