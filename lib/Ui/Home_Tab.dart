import 'package:flutter/material.dart';
import 'package:gym/Ui/New_Registeration.dart';
import 'package:gym/Ui/View_Members.dart';
import 'package:gym/Widgets/Main_Screen_Cards.dart';

class Home_Page_Tab extends StatefulWidget {
  const Home_Page_Tab({super.key});

  @override
  State<Home_Page_Tab> createState() => _Home_Page_TabState();
}

class _Home_Page_TabState extends State<Home_Page_Tab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Main_Screen_Cards(
                  context,
                  Icons.person_add_alt_rounded,
                  'New Registeration',
                  'Register new gym members quickly and efficiently.',
                  'Register Now', () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => New_Registeration_Screen(
                          title: 'New Registration',
                        )));
              }, () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => New_Registeration_Screen(
                          title: 'New Registration',
                        )));
              }),
              const SizedBox(height: 15),
              Main_Screen_Cards(
                  context,
                  Icons.groups_rounded,
                  'Registered Users',
                  'Manage and view all registered gym members.',
                  'View Members', () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const View_Members_Screen()));
              }, () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const View_Members_Screen()));
              })
            ],
          ),
        ),
      ),
    );
  }
}
