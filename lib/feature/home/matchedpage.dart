import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'donor_model.dart';

class MatchedPage extends StatefulWidget {
  final List<String> checkedFoodItems;

  const MatchedPage({super.key, required this.checkedFoodItems});

  @override
  _MatchedPageState createState() => _MatchedPageState();
}

class _MatchedPageState extends State<MatchedPage> {
  List<Map<String, dynamic>> donors = [];
  List<MatchedModel> matchedDetail = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchDonors();
  }

  fetchDonors() async {
    setState(() {
      loading = true;
    });
    try {
      QuerySnapshot donorSnapshot =
          await FirebaseFirestore.instance.collection('donorfood').get();

      List<MatchedModel> tempMatchedDeatil = [];
      for (var doc in donorSnapshot.docs) {
        List<String> donorFoodItems = (doc['foodName'] as String?)
                ?.split(',')
                .map((item) => item.trim().toUpperCase())
                .toList() ??
            [];

        // Debugging output
        print('Processing donor ID: ${doc['donorId']}');
        print('Donor Food Items: $donorFoodItems');
        print(
            'Checked Food Items: ${widget.checkedFoodItems.map((item) => item.trim().toUpperCase()).toList()}');

        // Check if the donor's food items match any of the selected food items
        // bool matches = widget.checkedFoodItems
        //     .map((item) => item.trim().toUpperCase())
        //     .any((item) => donorFoodItems.contains(item));

        // print('Does it match? $matches');

        List<String> temp = [];
        for (var item in widget.checkedFoodItems) {
          for (var donorItem in donorFoodItems) {
            if (item == donorItem) {
              temp.add(item);
            }
          }
        }
        if (temp.isNotEmpty) {
          var donorDetails = await FirebaseFirestore.instance
              .collection('user')
              .doc(doc['donorId'])
              .get();
          if (donorDetails.exists) {
            tempMatchedDeatil.add(MatchedModel(
                donorId: doc['donorId'],
                matchedIttem: temp,
                email: donorDetails['email'],
                phone: donorDetails['phone'],
                address: donorDetails['address']));
          } else {
            print('No donor details found for ID: ${doc['donorId']}');
          }
        }
      }

      // Final list debugging
      // print('Final matched donors list: $tempDonors');

      setState(() {
        // donors = tempDonors;
        matchedDetail = tempMatchedDeatil;
        loading = false;
      });

      // Ensure setState is triggered
      print('UI should now update with matched donors.');
    } catch (e) {
      print("Error fetching donors: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matched Donors'),
        backgroundColor: const Color(0xFF028090), // Dark Teal
      ),
      backgroundColor: const Color(0xFFF0F3BD), // Light Greenish Yellow
      body: !loading
          ? matchedDetail.isEmpty
              ? const Center(child: Text("No matched donors found"))
              : ListView.builder(
                  itemCount: matchedDetail.length,
                  itemBuilder: (context, index) {
                    // var donor = donors[index];
                    var match = matchedDetail[index];
                    // Ensure that each field is correctly handled and not null
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF99E1D9), // Light Teal
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(match.matchedIttem.join(',')),
                          Text(
                            // 'Email: ${donor['email'] ?? 'No Email Provided'}',
                            match.email,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Dark-colored text
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // 'Phone: ${donor['phone'] ?? 'No Phone Provided'}',
                            match.phone,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // 'Address: ${donor['address'] ?? 'No Address Provided'}',
                            'Address: ${match.address ?? 'No Address Provided'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          // Text(
                          //   'User Type: ${donor['userType'] ?? 'Unknown UserType'}',
                          //   style: const TextStyle(fontSize: 16),
                          // ),
                        ],
                      ),
                    );
                  },
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class MatchedModel {
  String donorId;
  List<String> matchedIttem;
  String email;
  String phone;
  String address;
  MatchedModel({
    required this.donorId,
    required this.matchedIttem,
    required this.email,
    required this.phone,
    required this.address,
  });
}
