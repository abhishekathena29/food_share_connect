import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/home/matchedpage.dart';

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

        print("Fetching data for NGO ID: ${doc.id}");
        print("NGO Requested Items: $ngoRequestedItems");
        print("Donor Selected Items: ${widget.donorFoodItems}");

        List<String> temp = [];
        for (var item in widget.donorFoodItems) {
          for (var ngoItem in ngoRequestedItems) {
            // Updated logic to ignore quantities and units for matching
            if (item.split('(')[0].trim().toUpperCase() ==
                ngoItem.split('(')[0].trim().toUpperCase()) {
              temp.add(item); // Add matching donor item
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
            print("Matched Items for NGO ${doc['ngoId']}: $temp");
          } else {
            print("No matching user document found for ngoId: ${doc['ngoId']}");
          }
        }
      }

      setState(() {
        matchedDetail = tempMatchedDetail;
        loading = false;
      });

      print('UI should now update with matchedDetail: $matchedDetail');
    } catch (e) {
      print("Error fetching NGOs: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Matched NGOs',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff2A9D8F), // Elegant teal color
        foregroundColor: Colors.white, // White text for better visibility
        elevation: 5,
      ),
      backgroundColor: const Color(0xffF4F4F4), // Light background for contrast
      body: Column(
        children: [
          // Donor Food Section
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Contributions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff264653), // Dark teal for section title
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.donorFoodItems.join(', '),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff555555), // Muted dark gray for items
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Matched NGOs",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff264653), // Dark teal for section title
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // NGO Matched Items Section
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff2A9D8F)), // Matching teal color
                    ),
                  )
                : matchedDetail.isEmpty
                    ? const Center(
                        child: Text(
                          "No matched NGOs found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff555555), // Subtle dark gray text
                          ),
                        ),
                      )
                    : ListView.builder(
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
                                    Color(
                                        0xffE9F5F2), // Light teal for contrast
                                    Color(0xffFFFFFF), // White
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Donor's Selected Items
                                    Text(
                                      "Donor's Selected Items:",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(
                                            0xff264653), // Deep teal for visibility
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.donorFoodItems.join(', '),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(
                                            0xff555555), // Subtle dark gray
                                      ),
                                    ),
                                    const Divider(
                                      color:
                                          Color(0xff264653), // Subtle divider
                                      thickness: 1.0,
                                      height: 20,
                                    ),

                                    // Matched Items
                                    Text(
                                      "Matched Items with NGO:",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(
                                            0xff2A9D8F), // Teal for emphasis
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: match.matchedIttem.map((item) {
                                        var donorItem = widget.donorFoodItems
                                            .firstWhere(
                                                (donorFood) =>
                                                    donorFood
                                                        .split('(')[0]
                                                        .trim()
                                                        .toUpperCase() ==
                                                    item
                                                        .split('(')[0]
                                                        .trim()
                                                        .toUpperCase(),
                                                orElse: () => '');

                                        String donorQuantity =
                                            donorItem.isNotEmpty
                                                ? donorItem
                                                    .split('(')[1]
                                                    .split(' ')[0]
                                                : "0";
                                        String ngoQuantity =
                                            item.split('(')[1].split(' ')[0];

                                        return Text(
                                          "$item (NGO Requested: $ngoQuantity, Donor Provided: $donorQuantity)",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors
                                                .black87, // Black for better readability
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const Divider(
                                      color: Color(0xff264653),
                                      thickness: 1.0,
                                      height: 20,
                                    ),

                                    // NGO Details
                                    Row(
                                      children: [
                                        const Icon(Icons.email,
                                            color: Color(0xff555555), size: 20),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            match.email,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff555555),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            color: Color(0xff555555), size: 20),
                                        const SizedBox(width: 10),
                                        Text(
                                          match.phone,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff555555),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            color: Color(0xff555555), size: 20),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            match.address,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff555555),
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
  List<String> matchedIttem; // Includes formatted item names with quantity
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
