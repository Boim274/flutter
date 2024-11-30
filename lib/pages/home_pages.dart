import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:uts_game_catch_coin/bloc/auth/auth_bloc.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF176),
        automaticallyImplyLeading: false,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 80,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Fetch name from Firestore
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading name');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('Hello');
                } else {
                  var userData = snapshot.data?.data() as Map<String, dynamic>;
                  String name = userData['name'] ?? 'User';
                  return Text(
                    'Hello, $name',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 27, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
            GestureDetector(
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(auth.currentUser?.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 30,
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 30,
                    );
                  } else {
                    var userData =
                        snapshot.data?.data() as Map<String, dynamic>;
                    String? photoUrl = userData['photoUrl'];
                    return CircleAvatar(
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl)
                          : const AssetImage('assets/images/dino.png')
                              as ImageProvider,
                      radius: 20,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHome(context),
            const SizedBox(height: 20),
            _logoutButton(context), // Optional: logout button in body
          ],
        ),
      ),
    );
  }

  // Home content widget
  Widget _buildHome(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/dinoCoin.png',
          width: 150,
          height: 150,
        ),
        // Add additional content here if necessary
      ],
    );
  }

  // Logout button widget
  Widget _logoutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        context.go('/login');
      },
      child: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
