import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchedPage extends StatefulWidget {
  final List<String> checkedFoodItems;

  const MatchedPage({super.key, required this.checkedFoodItems});

  @override
  _MatchedPageState createState() => _MatchedPageState();
}

class _MatchedPageState extends State<MatchedPage> {
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

      List<MatchedModel> tempMatchedDetail = [];
      for (var doc in donorSnapshot.docs) {
        List<String> donorFoodItems = (doc['foodName'] as String?)
                ?.split(',')
                .map((item) => item.trim().toUpperCase())
                .toList() ??
            [];

        List<String> temp = [];
        for (var item in widget.checkedFoodItems) {
          for (var donorItem in donorFoodItems) {
            if (item.trim().toUpperCase() == donorItem) {
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
            tempMatchedDetail.add(MatchedModel(
              donorId: doc['donorId'],
              matchedIttem: temp,
              email: donorDetails['email'],
              phone: donorDetails['phone'],
              address: donorDetails['address'],
            ));
          }
        }
      }

      setState(() {
        matchedDetail = tempMatchedDetail;
        loading = false;
      });

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
        backgroundColor: const Color(0xff03DAC5), // Cyan color for AppBar
        foregroundColor: Colors.black87, // Ensure text is visible
      ),
      backgroundColor: const Color(0xff121212), // Dark background
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xff03DAC5)), // Cyan progress indicator
            ))
          : matchedDetail.isEmpty
              ? const Center(
                  child: Text(
                    "No matched donors found",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: matchedDetail.length,
                  itemBuilder: (context, index) {
                    var match = matchedDetail[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: const Color(
                          0xff1E1E1E), // Dark gray background for card
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Matched Items: ${match.matchedIttem.join(', ')}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // White text for contrast
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.email,
                                    color: Color(0xff03DAC5), // Cyan icon color
                                    size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    match.email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors
                                          .white70, // Slightly lighter text
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Color(0xff03DAC5), // Cyan icon color
                                    size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  match.phone,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xff03DAC5), // Cyan icon color
                                    size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    match.address,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
