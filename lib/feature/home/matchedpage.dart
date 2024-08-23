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

  @override
  void initState() {
    super.initState();
    fetchDonors();
  }

  fetchDonors() async {
    try {
      QuerySnapshot donorSnapshot =
          await FirebaseFirestore.instance.collection('donorfood').get();

      List<Map<String, dynamic>> tempDonors = [];

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
        bool matches = widget.checkedFoodItems
            .map((item) => item.trim().toUpperCase())
            .any((item) => donorFoodItems.contains(item));

        print('Does it match? $matches');

        if (matches) {
          var donorDetails = await FirebaseFirestore.instance
              .collection('user')
              .doc(doc['donorId'])
              .get();

          if (donorDetails.exists) {
            print('Donor details found for ID: ${doc['donorId']}');

            tempDonors.add({
              'email': donorDetails.data()?['email'] ?? 'Unknown Email',
              'phone': donorDetails.data()?['phone'] ?? 'Unknown Phone',
              'address': donorDetails.data()?['address'] ?? 'Unknown Address',
              'userType':
                  donorDetails.data()?['userType'] ?? 'Unknown UserType',
              // 'collected': collected, // Removed since it doesn't exist and causes issues
            });

            // Debugging output
            print('Added donor to list: ${donorDetails.data()}');
          } else {
            print('No donor details found for ID: ${doc['donorId']}');
          }
        }
      }

      // Final list debugging
      print('Final matched donors list: $tempDonors');

      setState(() {
        donors = tempDonors;
      });

      // Ensure setState is triggered
      print('UI should now update with matched donors.');
    } catch (e) {
      print("Error fetching donors: $e");
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
      body: donors.isEmpty
          ? const Center(child: Text("No matched donors found"))
          : ListView.builder(
              itemCount: donors.length,
              itemBuilder: (context, index) {
                var donor = donors[index];

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
                      Text(
                        'Email: ${donor['email'] ?? 'No Email Provided'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Dark-colored text
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone: ${donor['phone'] ?? 'No Phone Provided'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${donor['address'] ?? 'No Address Provided'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'User Type: ${donor['userType'] ?? 'Unknown UserType'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
