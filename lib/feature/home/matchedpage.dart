import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      // Debug: Print the checked food items passed to the page
      print("Checked Food Items: ${widget.checkedFoodItems}");

      QuerySnapshot donorSnapshot =
          await FirebaseFirestore.instance.collection('donorfood').get();

      List<Map<String, dynamic>> tempDonors = [];

      for (var doc in donorSnapshot.docs) {
        // Split and trim the donor's food items from the Firestore document
        List<String> donorFoodItems = (doc['foodName'] as String?)
                ?.split(',')
                .map((item) => item.trim().toUpperCase())
                .toList() ??
            [];

        // Debug: Print the donor's food items
        print("Donor Food Items: $donorFoodItems");

        // Check if all the checked food items from the NGO are in the donor's food items
        bool matches = widget.checkedFoodItems
            .map((item) => item.trim().toUpperCase())
            .every((item) => donorFoodItems.contains(item));

        // Debug: Print whether there's a match
        print("Does it match? $matches");

        if (matches) {
          var donorDetails = await FirebaseFirestore.instance
              .collection('user')
              .doc(doc['donorId'])
              .get();

          if (donorDetails.exists) {
            tempDonors.add({
              'email': donorDetails.data()?['email'] ?? 'Unknown Email',
              'phone': donorDetails.data()?['phone'] ?? 'Unknown Phone',
              'address': donorDetails.data()?['address'] ?? 'Unknown Address',
              'userType':
                  donorDetails.data()?['userType'] ?? 'Unknown UserType',
            });
          }
        }
      }

      // Debug: Print the final list of matched donors
      print("Matched Donors: $tempDonors");

      setState(() {
        donors = tempDonors;
      });
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
