import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/auth/login.dart';
import 'package:food_share_connect/feature/home/donor_model.dart';
import 'package:food_share_connect/feature/home/matcheddonor.dart';

Map<String, Map<String, dynamic>> checkedfoodMap = {}; // Persistent map

// Updated to include quantity and unit

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

class DonorHome extends StatefulWidget {
  const DonorHome({super.key});

  @override
  State<DonorHome> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<DonorHome> {
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
            "name": "BLANCKETS/SCARVES",
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
          onPressed: () async {
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
                  .where("donorId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get();
              if (result.docs.isNotEmpty && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("You can make only one request at a time! ")));
              } else {
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
          },
          backgroundColor: const Color(0xff03DAC5),
          child: const Icon(Icons.check, color: Colors.black87),
        ),
        appBar: AppBar(
          title: const Text("Donor Home Page"),
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
              icon: const Icon(Icons.logout, color: Colors.black),
            ),
          ],
          bottom: TabBar(
            // isScrollable: false,
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
        mainAxisExtent: 360,
        crossAxisSpacing: 10,
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
  int quantity = 1;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
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
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 150,
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
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
            textAlign: TextAlign.center,
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
              // IconButton(
              //   icon: const Icon(Icons.add, color: Colors.white),
              //   onPressed: () {
              //     setState(() {
              //       quantity++;
              //       if (checkedfoodMap[widget.title] != null) {
              //         checkedfoodMap[widget.title]!['quantity'] = quantity;
              //       }
              //     });
              //   },
              // ),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: quantity > 1
                    ? () {
                        setState(() {
                          quantity--;
                          if (checkedfoodMap[widget.title] != null) {
                            checkedfoodMap[widget.title]!['quantity'] =
                                quantity;
                          }
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
            value: checkedfoodMap[widget.title] !=
                null, // Check if the item is in the map
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  // Add to map
                  checkedfoodMap[widget.title] = {
                    'name': widget.title,
                    'quantity': quantity,
                    'unit': widget.currentTab == "FOOD" ? "kg" : "pcs",
                  };
                } else {
                  // Remove from map
                  checkedfoodMap.remove(widget.title);
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
