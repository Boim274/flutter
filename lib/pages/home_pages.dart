import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int score = 0;
  int coinCount = 0;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _retrieveQueryParams();
    });
  }

  // Method to retrieve query parameters after the frame is built
  void _retrieveQueryParams() {
    final Map<String, String> queryParams =
        GoRouterState.of(context).uri.queryParameters;
    if (queryParams.isNotEmpty) {
      setState(() {
        score = int.tryParse(queryParams['score'] ?? '0') ?? 0;
        coinCount = int.tryParse(queryParams['coins'] ?? '0') ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bag1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Lapisan semi-transparan
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            SingleChildScrollView(
              child: Column(
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
                                color: Color.fromARGB(255, 255, 255, 255),
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
                                    // ignore: unnecessary_string_interpolations
                                    '$name',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildyourcoin(),
                        const SizedBox(height: 20),
                        _buildScore(),
                        const SizedBox(height: 10),
                        _buildHome(context),
                        const SizedBox(height: 10),
                        _playButton(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'by Ibrahim',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScore() {
    return Row(
      children: [
        Text(
          'Score: $score',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
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
          'Your Coin: $coinCount',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const Icon(
          Icons.monetization_on,
          color: Colors.white,
          size: 30,
        )
      ],
    );
  }

  Widget _profileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.login,
        color: Colors.white,
        size: 30,
      ),
      onSelected: (value) async {
        if (value == 'login') {
          context.goNamed('login');
        } else if (value == 'logout') {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
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
            'assets/images/dinocoinwhite.png',
            width: 200,
            height: 200,
          ),
        ],
      ),
    );
  }

  Widget _playButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {
          context.go('/game');
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            const Color(0xFFFF0000),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 18, horizontal: 80),
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
