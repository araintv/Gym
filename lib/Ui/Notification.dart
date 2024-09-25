import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';

class Notification_Tab extends StatefulWidget {
  const Notification_Tab({super.key});

  @override
  State<Notification_Tab> createState() => _Notification_TabState();
}

class _Notification_TabState extends State<Notification_Tab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> notifications = []; // Store notifications here
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchNotifications(); // Fetch notifications when the widget is initialized
  }

  Future<void> fetchNotifications() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('notifications').get();
      List<Map<String, dynamic>> tempNotifications = [];

      for (var doc in snapshot.docs) {
        var notificationData = doc.data() as Map<String, dynamic>;
        notificationData['document_id'] = doc.id; // Add document ID if needed
        tempNotifications.add(notificationData);
      }

      setState(() {
        notifications = tempNotifications; // Update notifications list
        isLoading = false; // Data fetch completed
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var notification = notifications[index];
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    elevation: 0,
                    color: AppColors().greyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title'] ?? 'Unknown Title',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              notification['header'] ?? 'Unknown Header',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              notification['content'] ??
                                  'No content available.',
                              style:
                                  GoogleFonts.poppins(color: Colors.redAccent),
                            ),
                            // You can add more fields as needed
                          ]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
