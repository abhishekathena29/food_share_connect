import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchedDonorPage extends StatefulWidget {
  final List<String> donorFoodItems;

  const MatchedDonorPage({super.key, required this.donorFoodItems});

  @override
  _MatchedDonorPageState createState() => _MatchedDonorPageState();
}

class _MatchedDonorPageState extends State<MatchedDonorPage> {
  List<MatchedModel> matchedDetail = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchNGOs();
  }

  fetchNGOs() async {
    setState(() {
      loading = true;
    });
    try {
      QuerySnapshot ngoSnapshot =
          await FirebaseFirestore.instance.collection('ngofood').get();

      List<MatchedModel> tempMatchedDetail = [];
      for (var doc in ngoSnapshot.docs) {
        List<String> ngoRequestedItems = (doc['foodName'] as String?)
                ?.split(',')
                .map((item) => item.trim().toUpperCase())
                .toList() ??
            [];

        // Debugging logs
        print("Fetching data for NGO ID: ${doc.id}");
        print("NGO Requested Items: $ngoRequestedItems");
        print("Donor Selected Items: ${widget.donorFoodItems}");

        List<String> temp = [];
        for (var item in widget.donorFoodItems) {
          for (var ngoItem in ngoRequestedItems) {
            if (item.trim().toUpperCase() == ngoItem) {
              temp.add(item);
            }
          }
        }

        if (temp.isNotEmpty) {
          var ngoDetails = await FirebaseFirestore.instance
              .collection('user')
              .doc(doc['ngoId'])
              .get();
          if (ngoDetails.exists) {
            tempMatchedDetail.add(MatchedModel(
              donorId: doc['ngoId'],
              matchedIttem: temp,
              email: ngoDetails['email'],
              phone: ngoDetails['phone'],
              address: ngoDetails['address'],
            ));
          } else {
            print("No matching user document found for ngoId: ${doc['ngoId']}");
          }
        }
      }

      setState(() {
        matchedDetail = tempMatchedDetail;
        loading = false;
      });

      print('Matched NGOs retrieved: $matchedDetail');
    } catch (e) {
      print("Error fetching NGOs: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matched NGOs'),
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
                    "No matched NGOs found",
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
