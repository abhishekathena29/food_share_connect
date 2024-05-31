import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum UserType { donor, ngo }

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passController = TextEditingController();

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
                    hintText: 'Username',
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
              Container(
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
