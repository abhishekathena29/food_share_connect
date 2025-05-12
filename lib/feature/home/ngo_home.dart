import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/home/matchedpage.dart';
import 'package:food_share_connect/utils/colors.dart';
import 'package:food_share_connect/utils/utility_methods.dart'
    show UtilityMethods;
import 'ngo_model.dart';

List<Map<String, dynamic>> checkedFoodNGO = []; // Updated to include quantity

class NGOHome extends StatefulWidget {
  const NGOHome({super.key});

  @override
  State<NGOHome> createState() => _NGOHomeState();
}

class _NGOHomeState extends State<NGOHome> {
  String currentTab = "FOOD"; // Tracks the selected tab

  Future<void> addDataForNGO(NGOModel data) async {
    try {
      await FirebaseFirestore.instance.collection('ngofood').add(data.toMap());
      print("Data added successfully with ngoId");
    } catch (e) {
      print("Failed to add data: $e");
    }
  }

  Future<void> onNGOSubmit() async {
    if (checkedFoodNGO.isNotEmpty) {
      String foodDetails = checkedFoodNGO.map((item) {
        return "${item['name']} (${item['quantity']} ${item['unit']})"; // Format item
      }).join(', ');

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        NGOModel data = NGOModel(
          ngoId: user.uid,
          foodName: foodDetails, // Save formatted food details
          addeddate: Timestamp.fromDate(DateTime.now()),
        );

        addDataForNGO(data);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Thank you for submitting your request! Donations will be matched soon!")));

        // Navigate to MatchedPage with the selected food items
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MatchedPage(
                    checkedFoodItems: checkedFoodNGO.map((item) {
                      return "${item['name']} (${item['quantity']} ${item['unit']})";
                    }).toList(),
                  )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User is not authenticated.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select some items to request!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: onNGOSubmit,
          backgroundColor: AppColors.backgroundColor,
          child: const Icon(Icons.check, color: Colors.black87),
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
              onPressed: UtilityMethods.onLogout(context),
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: TabBar(
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
        body: TabBarView(
          children: [
            buildGrid(UtilityMethods.getDisplayedItems(currentTab)),
            buildGrid(UtilityMethods.getDisplayedItems(currentTab)),
            buildGrid(UtilityMethods.getDisplayedItems(currentTab)),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(List<Map<String, String>> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 230, // Increased from 180 to ensure no overflow
        crossAxisSpacing: 20,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return FoodCardNGO(
          title: items[index]['name']!,
          imageUrl: items[index]['imageUrl']!,
          currentTab: currentTab,
        );
      },
    );
  }
}

class FoodCardNGO extends StatefulWidget {
  const FoodCardNGO({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.currentTab,
  });

  final String title;
  final String imageUrl;
  final String currentTab;

  @override
  State<FoodCardNGO> createState() => _FoodCardNGOState();
}

class _FoodCardNGOState extends State<FoodCardNGO> {
  int quantity = 0;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230, // Match the mainAxisExtent
      decoration: BoxDecoration(
        border: Border.all(
          color: checkedFoodNGO.any((item) => item['name'] == widget.title)
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
        children: [
          Expanded(
            flex: 3, // Give more space to the image section
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(widget.imageUrl,
                      fit: BoxFit.cover,
                      color: Colors.black45,
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                    );
                  }),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.contrastTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2, // Give less space to the controls section
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.remove, color: AppColors.textColor),
                      onPressed: quantity > 0
                          ? () {
                              setState(() {
                                quantity--;
                                if (quantity > 0) {
                                  var existingItem = checkedFoodNGO.firstWhere(
                                    (item) => item['name'] == widget.title,
                                    orElse: () => {},
                                  );
                                  if (existingItem.isNotEmpty) {
                                    existingItem['quantity'] = quantity;
                                  }
                                } else {
                                  checkedFoodNGO.removeWhere(
                                      (item) => item['name'] == widget.title);
                                }
                              });
                            }
                          : null,
                    ),
                    Text(
                      "$quantity ${widget.currentTab == "FOOD" ? "kg" : "Qty"}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColors.textColor),
                      onPressed: () {
                        setState(() {
                          quantity++;
                          var existingItem = checkedFoodNGO.firstWhere(
                            (item) => item['name'] == widget.title,
                            orElse: () => {},
                          );
                          if (existingItem.isNotEmpty) {
                            existingItem['quantity'] = quantity;
                          } else {
                            checkedFoodNGO.add({
                              'name': widget.title,
                              'quantity': quantity,
                              'unit':
                                  widget.currentTab == "FOOD" ? "kg" : "Qty",
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    dense: true,
                    title: const Text(
                      "Select",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                    ),
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                        String unit =
                            widget.currentTab == "FOOD" ? "kg" : "Qty";
                        if (isChecked) {
                          checkedFoodNGO.add({
                            'name': widget.title,
                            'quantity': quantity,
                            'unit': unit,
                          });
                        } else {
                          checkedFoodNGO.removeWhere(
                              (item) => item['name'] == widget.title);
                        }
                      });
                    },
                    activeColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
