import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/home/matchedpage.dart';
import '../auth/login.dart';
import 'ngo_model.dart';

List<Map<String, dynamic>> checkedFoodNGO = []; // Updated to include quantity
int quantity = 0;

final List<Map<String, String>> foodItems = [
  {
    "name": "RICE",
    "imageUrl":
        "https://static.vecteezy.com/system/resources/previews/041/051/304/non_2x/rice-in-bag-with-ears-of-grain-basmati-harvest-national-asian-dish-vector.jpg"
  },
  {
    "name": "PULSES",
    "imageUrl":
        "https://static.vecteezy.com/system/resources/thumbnails/048/917/545/small_2x/beans-and-beans-in-a-bowl-vector.jpg"
  },
  {
    "name": "WHEAT",
    "imageUrl":
        "https://static.vecteezy.com/system/resources/previews/047/311/467/non_2x/wheat-crop-cartoon-graphic-free-png.png"
  },
  {
    "name": "SNACKS",
    "imageUrl":
        "https://www.shutterstock.com/image-vector/potato-chips-package-bag-sticker-600nw-2331155791.jpg"
  },
  {
    "name": "CANNED FOOD",
    "imageUrl":
        "https://t4.ftcdn.net/jpg/01/90/91/99/360_F_190919999_MewBbMjoyAeJbEXxE3ioafIzCqUGboLo.jpg"
  },
  {
    "name": "FRUITS",
    "imageUrl":
        "https://png.pngtree.com/png-clipart/20201223/ourmid/pngtree-fruit-combination-illustration-illustration-png-image_2604329.jpg"
  },
  {
    "name": "VEGETABLES",
    "imageUrl":
        "https://thumbs.dreamstime.com/b/colorful-cartoon-vegetables-illustration-healthy-eating-nutrition-vector-shows-338397591.jpg"
  },
  {
    "name": "SUGAR",
    "imageUrl":
        "https://t3.ftcdn.net/jpg/04/14/63/68/360_F_414636826_vRTX4F3xS16nzRwll8OYpLHtG17Vrohc.jpg"
  },
];

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

  List<Map<String, String>> getDisplayedItems() {
    switch (currentTab) {
      case "CLOTHING":
        return [
          {
            "name": "CLOTHING",
            "imageUrl":
                "https://media.istockphoto.com/id/1283154274/photo/woman-holding-cardboard-donation-box-full-with-folded-clothes.jpg?s=612x612&w=0&k=20&c=bqJFhv_hRXV3Milqrmuh54eyIiScjgqP6z0iwnnT84I="
          },
          {
            "name": "BLANKETS/SCARVES",
            "imageUrl":
                "https://media.istockphoto.com/id/1388313478/photo/close-up-of-woman-preparing-box-of-clothing-for-charity.jpg?s=612x612&w=0&k=20&c=Q2p2gwaisW3jBJDgpgDPlehAT_HFCN6datyJtSWYDdA="
          },
          {
            "name": "GLOVES",
            "imageUrl":
                "https://media.istockphoto.com/id/481044365/photo/warm-woolen-knitted-gloves.jpg?s=612x612&w=0&k=20&c=boqQOwOmlBGuwvVujKKeN022Zp1GAcyZLiiB-Z5LX5Q="
          },
          {
            "name": "HAT",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvEd6Z5K0paqS-ATqtzYPLlZ3oiNyuLkSovQ&s"
          },
          {
            "name": "SOCKS",
            "imageUrl":
                "https://m.media-amazon.com/images/I/5170dK9d6cL._AC_UY1100_.jpg"
          },
        ];
      case "ESSENTIALS":
        return [
          {
            "name": "SOAP",
            "imageUrl":
                "https://media.istockphoto.com/id/964808824/vector/soap-flat-icon-soap-bubbles-vector-illustration.jpg?s=612x612&w=0&k=20&c=iGZSLnmm2KZVL349BMz0HdVsPwE6_GqJUGKDTjJXEds="
          },
          {
            "name": "SHAMPOO",
            "imageUrl":
                "https://as1.ftcdn.net/v2/jpg/04/61/58/50/1000_F_461585096_ubs4jj8neihfsTZNLcnNTLrvQoQ8iyju.jpg"
          },
          {
            "name": "TOOTHPASTE",
            "imageUrl":
                "https://t4.ftcdn.net/jpg/01/70/61/27/360_F_170612790_PZdBIX7NfHvZC6RO1EaAxyKWLf7lEMlU.jpg"
          },
          {
            "name": "TOILET PAPER",
            "imageUrl":
                "https://static.vecteezy.com/system/resources/previews/002/383/145/non_2x/cartoon-illustration-of-toilet-paper-free-vector.jpg"
          },
          {
            "name": "HAND SANITIZER",
            "imageUrl":
                "https://static.vecteezy.com/system/resources/previews/006/921/737/non_2x/washing-hand-with-hand-sanitizer-cartoon-icon-illustration-people-medical-icon-concept-isolated-premium-flat-cartoon-style-vector.jpg"
          },
          {
            "name": "DETERGENT",
            "imageUrl":
                "https://cdn-icons-png.flaticon.com/512/9619/9619872.png"
          },
          {
            "name": "TOWEL",
            "imageUrl":
                "https://www.shutterstock.com/image-vector/vector-illustration-blue-towels-terry-600nw-496523932.jpg"
          },
          {
            "name": "FIRST AID KIT ITEMS",
            "imageUrl":
                "https://cdn-icons-png.flaticon.com/512/12322/12322000.png"
          },
        ];
      default:
        return foodItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("User is not authenticated.")));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please select some items to request!")));
            }
          },
          backgroundColor: const Color(0xff03DAC5),
          child: const Icon(Icons.check, color: Colors.black87),
        ),
        appBar: AppBar(
          title: const Text("NGO Home Page"),
          backgroundColor: const Color(0xff03DAC5),
          foregroundColor: Colors.black87,
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
          physics: NeverScrollableScrollPhysics(),
          children: [
            buildGrid(getDisplayedItems()),
            buildGrid(getDisplayedItems()),
            buildGrid(getDisplayedItems()),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(List<Map<String, String>> items) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
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
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff1E1E1E),
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
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xffF7D18E),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: quantity > 1
                    ? () {
                        setState(() {
                          quantity--;
                        });
                      }
                    : null,
              ),
              Text(
                "$quantity ${widget.currentTab == "FOOD" ? "kg" : "pcs"}",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
              ),
            ],
          ),
          CheckboxListTile(
            title: const Text(
              "Select",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
                String unit = widget.currentTab == "FOOD"
                    ? "kg"
                    : "pcs"; // Determine unit
                if (isChecked) {
                  checkedFoodNGO.add({
                    'name': widget.title,
                    'quantity': quantity,
                    'unit': unit, // Add unit for each item
                  });
                } else {
                  checkedFoodNGO
                      .removeWhere((item) => item['name'] == widget.title);
                }
              });
            },
            activeColor: const Color(0xff03DAC5),
          ),
        ],
      ),
    );
  }
}
