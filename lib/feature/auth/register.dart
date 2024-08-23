import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'FoodShare',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'CONNECT',
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phonecontroller,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Phone number',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addreesscontroller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Address',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'password',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    const Text(
                      'Are you a: ',
                      style: TextStyle(
                        color: Color(0xff989898),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                        child: Row(
                      children: [
                        Radio<UserType>(
                          value: UserType.donor,
                          groupValue: _character,
                          onChanged: (UserType? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        const Text(
                          'Donor',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: [
                        Radio<UserType>(
                          value: UserType.ngo,
                          groupValue: _character,
                          onChanged: (UserType? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        const Text(
                          'NGO',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passController.text);
                    await Future.delayed(Duration(seconds: 2));

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
                    print(userCredential.user!.uid);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xff038C8C),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text.rich(
                  TextSpan(
                    text: 'Already Registered? ',
                    style: TextStyle(color: Color(0xffFFFFFF)),
                    children: [
                      TextSpan(
                          text: 'Login',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
