// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/home/matchedpage.dart';
import 'package:food_share_connect/feature/home/ngo_model.dart';
import '../auth/login.dart';

List<String> checkedFoodNGO = [];

final List<Map<String, String>> foodItems = [
  {
    "name": "RICE",
    "imageUrl":
        "https://media.istockphoto.com/id/153737841/photo/rice.jpg?s=612x612&w=0&k=20&c=lfO7iLT0UsDDzra0uBOsN1rvr2d5OEtrG2uwbts33_c="
  },
  {
    "name": "DAL",
    "imageUrl":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/3_types_of_lentil.png/300px-3_types_of_lentil.png"
  },
  {
    "name": "WHEAT",
    "imageUrl":
        "https://t3.ftcdn.net/jpg/07/56/66/28/360_F_756662819_M4cJj07c4o4CWRpP07vH41nG3uhuz5jA.jpg"
  },
  {"name": "BEANS", "imageUrl": "https://example.com/beans-image.jpg"},
  {
    "name": "OATS",
    "imageUrl":
        "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQk7xl1AQDWi1caZ-vEBLPfKTPuSHE_HGV1wNum6wlFuajYjwfc"
  },
  {
    "name": "FRUITS",
    "imageUrl":
        "https://t4.ftcdn.net/jpg/00/65/70/65/360_F_65706597_uNm2SwlPIuNUDuMwo6stBd81e25Y8K8s.jpg"
  },
  {
    "name": "VEGETABLES",
    "imageUrl":
        "https://t3.ftcdn.net/jpg/03/98/61/96/360_F_398619615_g8iqFtDWH5gsKjE16H6iNQ6h8BhywuFS.jpg"
  },
  {
    "name": "SUGAR",
    "imageUrl":
        "https://t3.ftcdn.net/jpg/02/22/41/82/360_F_222418209_hfwPSMzDi7pZWmCTn9NGdCJ3sijCGuQo.jpg"
  },
];

class NGOHome extends StatefulWidget {
  const NGOHome({super.key});

  @override
  State<NGOHome> createState() => _NGOHomeState();
}

class _NGOHomeState extends State<NGOHome> {
  // Function to add NGO data to Firestore
  addDataForNGO(NGOModel data) async {
    try {
      await FirebaseFirestore.instance.collection('ngofood').add(data.toMap());
      print("Data added successfully");
    } catch (e) {
      print("Failed to add data: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Check if there are selected items
          if (checkedFoodNGO.isNotEmpty) {
            NGOModel data = NGOModel(
              ngoId: FirebaseAuth.instance.currentUser!.uid,
              foodName: checkedFoodNGO.join(','),
              addeddate: Timestamp.fromDate(DateTime.now()),
            );

            // Add data to Firestore
            addDataForNGO(data);

            // Show confirmation message
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Thank you for accepting the donations!")));

            // Navigate to MatchedPage after data is added
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MatchedPage(checkedFoodItems: checkedFoodNGO)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Please select some food items.")));
          }
        },
        backgroundColor: const Color(0xff03DAC5), // Same cyan theme
        child: const Icon(Icons.check, color: Colors.black87),
      ),
      backgroundColor:
          const Color(0xff121212), // Updated to match Login Page theme
      appBar: AppBar(
        title: const Text("NGO Home Page"),
        backgroundColor: const Color(0xff03DAC5), // Cyan AppBar
        foregroundColor: Colors.black87, // Ensures text visibility,
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
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: foodItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 300,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return FoodCardNGO(
              title: foodItems[index]['name']!,
              imageUrl: foodItems[index]['imageUrl']!,
            );
          },
        ),
      ),
    );
  }
}

class FoodCardNGO extends StatefulWidget {
  const FoodCardNGO({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;

  @override
  State<FoodCardNGO> createState() => _FoodCardNGOState();
}

class _FoodCardNGOState extends State<FoodCardNGO> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff1E1E1E), // Dark gray background for card
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.red),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 8,
                          color: Colors.black45,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Transform.scale(
                      scale: 1.4,
                      child: Checkbox(
                        value: checkedFoodNGO.contains(widget.title),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              checkedFoodNGO.add(widget.title);
                            } else {
                              checkedFoodNGO.remove(widget.title);
                            }
                          });
                        },
                        activeColor: const Color(0xff03DAC5),
                        checkColor: Colors.black,
                        side: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
