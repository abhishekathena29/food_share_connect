import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/utils/colors.dart';

enum UserType { donor, ngo }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phonecontroller = TextEditingController();
  final addreesscontroller = TextEditingController();
  UserType? _character = UserType.donor;

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Dark background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'FoodShare',
                  style: TextStyle(
                    color: AppColors.primaryColor, // Vibrant accent color
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'CONNECT',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 28,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: AppColors.textColor,),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: const TextStyle(color:AppColors.textColor,),
                    filled: true,
                    fillColor: AppColors.inputBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: AppColors.textColor,),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: AppColors.textColor,),
                    filled: true,
                    fillColor: AppColors.inputBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phonecontroller,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppColors.textColor),
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    hintStyle: const TextStyle(color : AppColors.textColor,),
                    filled: true,
                    fillColor: AppColors.inputBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: addreesscontroller,
                  style: const TextStyle(color: AppColors.textColor,),
                  decoration: InputDecoration(
                    hintText: 'Address',
                    hintStyle: const TextStyle(color: AppColors.textColor,),
                    filled: true,
                    fillColor: AppColors.inputBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passController,
                  obscureText: true,
                  style: const TextStyle(color: AppColors.textColor,),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: AppColors.textColor,),
                    filled: true,
                    fillColor: AppColors.inputBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Join as a :',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: const Text(
                          'Donor',
                          style: TextStyle(color: AppColors.textColor,),
                        ),
                        horizontalTitleGap: 0,
                        leading: Radio<UserType>(
                          value: UserType.donor,
                          groupValue: _character,
                          activeColor:  AppColors.primaryColor,
                          onChanged: (UserType? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: const Text(
                          'NGO',
                          style: TextStyle(color: AppColors.textColor,),
                        ),
                        horizontalTitleGap: 0,
                        leading: Radio<UserType>(
                          value: UserType.ngo,
                          groupValue: _character,
                          activeColor: AppColors.primaryColor,
                          onChanged: (UserType? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _isloading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isloading = true;
                          });
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passController.text);
                            await Future.delayed(const Duration(seconds: 2));

                            await FirebaseFirestore.instance
                                .collection("user")
                                .doc(userCredential.user!.uid)
                                .set({
                              "email": emailController.text,
                              "userType": _character.toString(),
                              "phone": phonecontroller.text,
                              "address": addreesscontroller.text,
                              "name": usernameController.text,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Registration is Completed. Now you can login.')));
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.code)));
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.code)));
                              print(
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Some Error. Try again later.")));
                            print(e);
                          }
                          setState(() {
                            _isloading = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          decoration: BoxDecoration(
                           color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 20, color: AppColors.contrastTextColor),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already Registered? ',
                      style: TextStyle(color: AppColors.textColor),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
