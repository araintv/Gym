import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Components/snackBar.dart';
import 'package:gym/Ui/New_Registeration.dart';
import 'package:gym/Ui/Update_Infor.dart';
import 'package:gym/Widgets/Registered_View.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class Calendar_Tab extends StatefulWidget {
  const Calendar_Tab({super.key});

  @override
  State<Calendar_Tab> createState() => _Calendar_TabState();
}

class _Calendar_TabState extends State<Calendar_Tab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> members = []; // Store all member data here
  bool isLoading = true; // Track loading state
  DateTime? selectedDate; // To store selected date

  @override
  void initState() {
    super.initState();
    fetchMembers(); // Fetch members when the widget is initialized
  }

  Future<void> fetchMembers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('customers').get();
      List<Map<String, dynamic>> tempMembers = [];

      for (var doc in snapshot.docs) {
        var memberData = doc.data() as Map<String, dynamic>;
        memberData['document_id'] = doc.id;

        // Check if the membership is expired and add the status to the member data
        if (memberData['created_at'] != null &&
            memberData['membership_type'] != null) {
          bool isExpired = isMembershipExpired(
            memberData['created_at'],
            memberData['membership_type'],
          );
          memberData['status'] = isExpired ? 'Expired' : 'Active'; // Add status
          memberData['statusColor'] =
              isExpired ? Colors.red : Colors.greenAccent; // Add status color
        } else {
          memberData['status'] = 'N/A';
          memberData['statusColor'] = Colors.grey; // Default color for N/A
        }

        tempMembers.add(memberData);
      }

      setState(() {
        members = tempMembers; // Update the members list
        isLoading = false; // Data fetch completed
      });
    } catch (e) {
      print('Error fetching members: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('MMMM d, yyyy').format(date);
  }

  // Method to check if membership is expired based on creation date and membership type
  bool isMembershipExpired(Timestamp createdAt, String membershipType) {
    DateTime registrationDate = createdAt.toDate();
    int durationInMonths = int.parse(membershipType.split(' ')[0]);

    DateTime expiryDate = DateTime(
      registrationDate.year,
      registrationDate.month + durationInMonths,
      registrationDate.day,
    );

    return DateTime.now().isAfter(expiryDate); // True if expired
  }

  // Handler for date selection
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedDate = args.value; // Set selected date
    });
  }

  @override
  Widget build(BuildContext context) {
    // Separate members into expired and active lists
    List<Map<String, dynamic>> expiredMembers = [];
    List<Map<String, dynamic>> activeMembers = [];

    for (var member in members) {
      // Update expired status based on selected date
      if (selectedDate != null && member['created_at'] != null) {
        DateTime expiryDate = DateTime(
          member['created_at'].toDate().year,
          member['created_at'].toDate().month +
              int.parse(member['membership_type'].split(' ')[0]),
          member['created_at'].toDate().day,
        );

        member['status'] =
            selectedDate!.isAfter(expiryDate) ? 'Expired' : 'Active';
        member['statusColor'] =
            selectedDate!.isAfter(expiryDate) ? Colors.red : Colors.greenAccent;
      }

      // Sort members into expired and active lists
      if (member['status'] == 'Expired') {
        expiredMembers.add(member);
      } else {
        activeMembers.add(member);
      }
    }

    // Combine the lists, with expired members on top
    List<Map<String, dynamic>> sortedMembers = [
      ...expiredMembers,
      ...activeMembers
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged, // Handle date selection
              selectionMode: DateRangePickerSelectionMode.single,
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: sortedMembers.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var member = sortedMembers[index];

                      return Registered_Users(
                        update: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Update_Info(
                              name: member['name'],
                              phone: member['phone_number'],
                              image: member['image_url'],
                              documentId: member['document_id'],
                            ),
                          ));
                        },
                        title: member['name'] ?? 'Unknown',
                        image: member['image_url'] ??
                            'https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg',
                        heading: formatTimestamp(member['created_at']),
                        status: member['status'] ?? 'N/A', // Get status
                        statusColor: member['statusColor'] ??
                            Colors.grey, // Get status color
                        onClick: () {
                          CustomSnackBar(
                              context, Text('Clicked on ${member['name']}'));
                        },
                        renue: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => New_Registeration_Screen(
                                    title: 'Membership Renewal',
                                    phone: member['phone_number'],
                                  )));
                        },
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
