import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Lapisan semi-transparan
            Container(
              color: Colors.black
                  .withOpacity(0.5), // Transparansi untuk efek gelap
            ),
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  toolbarHeight: 80,
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  centerTitle: true,
                  title: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (auth.currentUser == null)
                          const Text(
                            'Hello, Welcome user',
                            style: TextStyle(
                              color: Color.fromARGB(
                                  255, 255, 255, 255), // Warna teks putih
                              fontSize: 18,
                            ),
                          )
                        else
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(auth.currentUser?.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError ||
                                  !snapshot.hasData) {
                                return const Text('Error loading name');
                              } else {
                                var userData = snapshot.data?.data()
                                    as Map<String, dynamic>;
                                String name = userData['name'] ?? 'User';
                                return Text(
                                  'Hello, $name',
                                  style: const TextStyle(
                                    color: Color.fromARGB(
                                        255, 255, 255, 255), // Warna teks putih
                                    fontSize: 18,
                                  ),
                                );
                              }
                            },
                          ),
                        _profileMenu(context),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildyourcoin(),
                        const SizedBox(height: 20),
                        _buildLeaderboard(),
                        const SizedBox(height: 30),
                        _buildHome(context),
                        const SizedBox(height: 20),
                        _playButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Row(
      children: [
        Text(
          'Leaderboard',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white, // Warna teks putih
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildyourcoin() {
    return Row(
      children: [
        Text(
          'Your Coin: ',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white, // Warna teks putih
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const Icon(
          Icons.monetization_on,
          color: Colors.white, // Warna ikon putih
          size: 30,
        )
      ],
    );
  }

  Widget _profileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.login,
        color: Colors.white, // Warna ikon putih
        size: 30,
      ),
      onSelected: (value) {
        if (value == 'login') {
          context.goNamed('login');
        } else if (value == 'logout') {
          FirebaseAuth.instance.signOut();
          context.goNamed('login');
        }
      },
      itemBuilder: (context) {
        if (auth.currentUser == null) {
          return [
            PopupMenuItem(
              value: 'login',
              child: Row(
                children: const [
                  Icon(Icons.login, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Login'),
                ],
              ),
            ),
          ];
        } else {
          return [
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ];
        }
      },
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, 50),
      padding: const EdgeInsets.all(8),
    );
  }

  Widget _buildHome(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/dinoCoin.png',
            width: 200,
            height: 200,
          ),
        ],
      ),
    );
  }

  Widget _playButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: () {
          context.go('/game');
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            const Color(0xFFFF0000),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 25, horizontal: 70),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.3)),
          elevation: WidgetStateProperty.all(6),
        ),
        child: const Text(
          'Play',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
