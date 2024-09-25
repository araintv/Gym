import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Ui/Custom_Offer.dart';
import 'package:gym/Ui/Earnings.dart';
import 'package:gym/Ui/Home_Tab.dart';
import 'package:gym/Ui/Notification.dart';
import 'package:gym/Ui/calendarTab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Home_Page_Tab(),
    Calendar_Tab(),
    Notification_Tab(),
    Earning_Tab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              width: 50,
              height: 50,
              'lib/assets/gymLogo.png',
            ),
            Text(
              'Health & Fitness',
              style: GoogleFonts.poppins(),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Custom_Offer_Screen()),
                );
              },
              child: Icon(
                Icons.add,
                size: 40,
                color: AppColors().primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: AppColors().primaryColor,
        selectedItemColor: AppColors().primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
