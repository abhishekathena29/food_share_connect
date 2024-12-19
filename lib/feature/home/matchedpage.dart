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

      Map<String, MatchedModel> donorMap = {}; // Group contributions by donorId

      for (var doc in donorSnapshot.docs) {
        String donorId = doc['donorId'];
        String isfulfilled = doc['isfulfilled'];

        // Parse donor's food items
        List<String> donorFoodItems = (doc['foodName'] as String?)
                ?.split(',')
                .map((item) => item.trim())
                .toList() ??
            [];

        // Aggregate donor contributions
        Map<String, int> aggregatedDonorItems = {};
        for (var item in donorFoodItems) {
          String itemName = item.split('(')[0].trim();
          int quantity = int.tryParse(
                  item.split('(')[1].split(' ')[0].replaceAll(')', '')) ??
              0;

          aggregatedDonorItems[itemName] =
              (aggregatedDonorItems[itemName] ?? 0) + quantity;
        }

        // Match donor contributions with NGO's request
        Map<String, String> matchedItems = {};
        for (var ngoItem in widget.checkedFoodItems) {
          String ngoItemName = ngoItem.split('(')[0].trim();
          int ngoQuantity = int.tryParse(
                  ngoItem.split('(')[1].split(' ')[0].replaceAll(')', '')) ??
              0;

          if (aggregatedDonorItems.containsKey(ngoItemName)) {
            int donorQuantity = aggregatedDonorItems[ngoItemName]!;

            // Determine the fulfilled quantity
            int fulfilledQuantity =
                donorQuantity > ngoQuantity ? ngoQuantity : donorQuantity;

            matchedItems[ngoItemName] =
                "$fulfilledQuantity of $ngoQuantity kg/pcs";
          }
        }

        if (matchedItems.isNotEmpty) {
          var donorDetails = await FirebaseFirestore.instance
              .collection('user')
              .doc(donorId)
              .get();

          if (donorDetails.exists) {
            if (donorMap.containsKey(donorId)) {
              donorMap[donorId]!.matchedIttem.addAll(matchedItems);
            } else {
              donorMap[donorId] = MatchedModel(
                donorId: donorId,
                matchedIttem: matchedItems,
                email: donorDetails['email'],
                phone: donorDetails['phone'],
                address: donorDetails['address'],
              );
            }
          }
        }
      }

      setState(() {
        matchedDetail = donorMap.values.toList(); // Convert map to list
        loading = false;
      });

      print('UI updated with matched donors and quantities.');
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
        title: const Text(
          'Matched Donors',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff2A9D8F), // Teal for elegance
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      backgroundColor: const Color(0xffF4F4F4), // Light gray background
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xff2A9D8F)), // Matching teal color
              ),
            )
          : matchedDetail.isEmpty
              ? const Center(
                  child: Text(
                    "No matched donors found",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff555555)), // Subtle dark gray text
                  ),
                )
              : Column(
                  children: [
                    // Display NGO's request at the top
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff264653),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "NGO's Request:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.checkedFoodItems.join(', '),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Matched Donors List
                    Expanded(
                      child: ListView.builder(
                        itemCount: matchedDetail.length,
                        itemBuilder: (context, index) {
                          var match = matchedDetail[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff264653),
                                    Color(0xff2A9D8F)
                                  ], // Classy teal gradient
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Matched Donor",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Matched Items with Fulfilled Quantities
                                    const Text(
                                      "Matched Items:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    ...match.matchedIttem.entries.map((entry) {
                                      return Text(
                                        "- ${entry.key}: ${entry.value}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      );
                                    }).toList(),

                                    const SizedBox(height: 10),

                                    // Donor Details
                                    Row(
                                      children: [
                                        const Icon(Icons.email,
                                            color: Colors.white70, size: 20),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            match.email,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            color: Colors.white70, size: 20),
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
                                            color: Colors.white70, size: 20),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

class MatchedModel {
  String donorId;
  Map<String, String> matchedIttem;
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
