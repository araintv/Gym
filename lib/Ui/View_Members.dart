import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Components/snackBar.dart';
import 'package:gym/Ui/New_Registeration.dart';
import 'package:gym/Ui/Update_Infor.dart';
import 'package:gym/Widgets/Registered_View.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class View_Members_Screen extends StatefulWidget {
  const View_Members_Screen({super.key});

  @override
  State<View_Members_Screen> createState() => _View_Members_ScreenState();
}

class _View_Members_ScreenState extends State<View_Members_Screen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> members = []; // Store all member data here
  List<Map<String, dynamic>> filteredMembers = []; // Store filtered data here
  bool isLoading = true; // Track loading state
  TextEditingController searchController =
      TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    fetchMembers(); // Fetch members when the widget is initialized
    searchController.addListener(() {
      filterMembers(); // Call filter when the text changes
    });
  }

  Future<void> fetchMembers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('customers').get();
      List<Map<String, dynamic>> tempMembers = [];

      for (var doc in snapshot.docs) {
        // Include the document ID in the member data
        var memberData = doc.data() as Map<String, dynamic>;
        memberData['document_id'] = doc.id; // Add document ID to member data
        tempMembers.add(memberData);
      }

      setState(() {
        members = tempMembers; // Update the members list
        filteredMembers =
            tempMembers; // Initially, the filtered list is the same as all members
        isLoading = false; // Data fetch completed
      });
    } catch (e) {
      print('Error fetching members: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  void filterMembers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMembers = members.where((member) {
        return member['name'] != null && member['phone_number'] != null
            ? member['name'].toLowerCase().contains(query) ||
                member['phone_number'].toString().contains(query)
            : false;
      }).toList();
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date =
        timestamp.toDate(); // Convert Firestore Timestamp to DateTime
    return DateFormat('MMMM d, yyyy')
        .format(date); // Format date as "September 24, 2024"
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
          'Already Registered',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller:
                          searchController, // Set controller to capture input
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none),
                        filled: true,
                        hintText: 'Search members/numbers ..',
                        fillColor: Colors.grey[100],
                        hoverColor: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  ListView.builder(
                    itemCount: filteredMembers.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // Get filtered member data from the list
                      var member = filteredMembers[index];
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
                        status: member['membership_type'] ?? 'N/A',
                        statusColor: member['membership_type'] == 'Expired'
                            ? Colors.red
                            : Colors.greenAccent,
                        onClick: () {
                          CustomSnackBar(
                              context, Text('Clicked on ${member['name']}'));
                        },
                        renue: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => New_Registeration_Screen(
                                    title: 'Membership Renewal',
                                    phone: member['phone_number'],
                                    name: member['name'],
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
