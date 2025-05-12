import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/auth/login.dart';

class UtilityMethods {
  static onLogout(BuildContext context) {
    FirebaseAuth.instance.signOut().whenComplete(() =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false));
  }

  static List<Map<String, String>> getDisplayedItems(currentTab) {
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
        return UtilityMethods.foodItems;
    }
  }

  static final List<Map<String, String>> foodItems = [
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
}
