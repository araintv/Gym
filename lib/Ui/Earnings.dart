// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/Components/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package

class Earning_Tab extends StatefulWidget {
  const Earning_Tab({super.key});

  @override
  State<Earning_Tab> createState() => _Earning_TabState();
}

class _Earning_TabState extends State<Earning_Tab> {
  late Future<List<Map<String, dynamic>>> _earningsFuture;

  @override
  void initState() {
    super.initState();
    _earningsFuture = fetchEarnings();
  }

  Future<List<Map<String, dynamic>>> fetchEarnings() async {
    List<Map<String, dynamic>> earningsList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('earnings').get();

    for (var doc in querySnapshot.docs) {
      earningsList.add(doc.data() as Map<String, dynamic>);
    }

    return earningsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Earnings',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 0,
                color: AppColors().greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Earnings',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _earningsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                '\$0.00',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 30),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 30),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text(
                                '\$0.00',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 30),
                              );
                            } else {
                              // Calculate total earnings here
                              double totalEarnings =
                                  snapshot.data!.fold(0.0, (sum, earning) {
                                // Extract the fee value directly from the 'fees' field
                                final feeString = earning['fees'] ?? '0.0';
                                double fee = double.tryParse(feeString) ??
                                    0.0; // Convert string to double
                                return sum + fee; // Add fee to sum
                              });

                              return Text(
                                '\$${totalEarnings.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 25),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending Payments',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        Text(
                          '\$00.00', // Replace with actual pending payments
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Past Transactions',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 0,
                color: AppColors().greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _earningsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No transactions found.'));
                    } else {
                      // Display earnings data in a ListView
                      return Column(
                        children: snapshot.data!.map((earning) {
                          return transaction_View(
                            date: formatDate(earning['created_at']),
                            membershipType: earning['membership'] ?? 'N/A',
                            amount:
                                earning['fees'] ?? 'N/A', // Display fees here
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to format the date
  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy').format(date); // Format the date
  }

  Widget transaction_View({
    required String date,
    required String membershipType,
    required String amount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date, // Display the formatted transaction date
                style: GoogleFonts.poppins(),
              ),
              Text(
                membershipType, // Display the membership type
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            '\$$amount', // Display the amount as fees
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }
}
