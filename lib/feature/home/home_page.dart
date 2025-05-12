import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/auth/login.dart';
import 'package:food_share_connect/feature/home/donor_model.dart';
import 'package:food_share_connect/feature/home/matcheddonor.dart';
import 'package:food_share_connect/utils/colors.dart';
import 'package:food_share_connect/utils/utility_methods.dart';

Map<String, Map<String, dynamic>> checkedfoodMap = {}; // Persistent map

// Updated to include quantity and unit

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentTab = "FOOD";

  adddata(DonorModel data) async {
    try {
      await FirebaseFirestore.instance
          .collection('donorfood')
          .add(data.toMap());
      print("Data added successfully");
    } catch (e) {
      print("Failed to add data: $e");
    }
  }

  Future<void> onDonorSubmit() async {
    {
      if (checkedfoodMap.isNotEmpty) {
        // Convert map to list for saving
        List<Map<String, dynamic>> finalCheckedFood =
            checkedfoodMap.values.toList();

        // Format for saving
        String foodDetails = finalCheckedFood.map((item) {
          return "${item['name']} (${item['quantity']} ${item['unit']})";
        }).join(', ');

        DonorModel data1 = DonorModel(
          donorId: FirebaseAuth.instance.currentUser!.uid,
          foodName: foodDetails,
          addeddate: Timestamp.fromDate(DateTime.now()),
        );

        var result = await FirebaseFirestore.instance
            .collection("donorfood")
            .where("donorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (result.docs.isNotEmpty && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("You can make only one request at a time! ")));
        }

        if (context.mounted) {
          adddata(data1);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Thank you for submitting! An NGO will contact you shortly!")));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchedDonorPage(
                  donorFoodItems: finalCheckedFood.map((item) {
                    return "${item['name']} (${item['quantity']} ${item['unit']})";
                  }).toList(),
                ),
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select some items")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: onDonorSubmit,
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.check, color: AppColors.contrastTextColor),
        ),
        appBar: AppBar(
          title: const Text("FoodShare",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textColor,
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().whenComplete(() =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false));
              },
              icon: const Icon(Icons.logout, color: AppColors.textColor),
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.textColor,
            labelColor: AppColors.textColor,
            indicatorWeight: 1,
            onTap: (index) {
              setState(() {
                currentTab = index == 0
                    ? "FOOD"
                    : index == 1
                        ? "CLOTHING"
                        : "ESSENTIALS";
              });
            },
            tabs: const [
              Tab(text: "FOOD"),
              Tab(text: "CLOTHING"),
              Tab(text: "ESSENTIALS"),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: TabBarView(
            children: [
              buildGrid(UtilityMethods.getDisplayedItems(currentTab)),
              buildGrid(UtilityMethods.getDisplayedItems(currentTab)),
              buildGrid(UtilityMethods.getDisplayedItems(currentTab)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGrid(List<Map<String, String>> items) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 180,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return FoodCard(
          title: items[index]['name']!,
          imageUrl: items[index]['imageUrl']!,
          currentTab: currentTab,
        );
      },
    );
  }
}

class FoodCard extends StatefulWidget {
  const FoodCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.currentTab,
  });

  final String title;
  final String imageUrl;
  final String currentTab;

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  int quantity = 0;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: checkedfoodMap[widget.title] != null
              ? AppColors.primaryColor
              : AppColors.inputBoxColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust height to fit contents
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(widget.imageUrl,
                    fit: BoxFit.cover,
                    height: 120,
                    width: double.infinity,
                    color: Colors.black45,
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey,
                  );
                  // Icon(
                  //   Icons.broken_image,
                  //   size: 120,
                  //   fill: 1,
                  //   color: Colors.grey,
                  // );
                }),
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.contrastTextColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "$quantity ${widget.currentTab == "FOOD" ? "kg" : "Qty"}",
                style:
                    const TextStyle(fontSize: 16, color: AppColors.textColor),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.textColor),
                onPressed: () {
                  setState(() {
                    quantity++;
                    if (checkedfoodMap[widget.title] != null) {
                      // Update the quantity if the item already exists in the map
                      checkedfoodMap[widget.title]!['quantity'] = quantity;
                    } else {
                      // Add the item to the map if it doesn't exist
                      checkedfoodMap[widget.title] = {
                        'name': widget.title,
                        'quantity': quantity,
                        'unit': widget.currentTab == "FOOD" ? "kg" : "Qty",
                      };
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
