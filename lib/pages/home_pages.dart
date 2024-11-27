import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uts_game_catch_coin/bloc/auth/auth_bloc.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOutState) {
          // Navigate to login screen after sign out
          Navigator.pushReplacementNamed(context, '/login');
        }

        if (state is AuthErrorState) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }

          final user = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFFFF176),
              automaticallyImplyLeading: false,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 80,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              centerTitle: true,
              title: user != null
                  ? _buildUserTitle(user) // Display username if logged in
                  : const Text(
                      'Hello, Guest',
                      style: TextStyle(color: Colors.black),
                    ), // Display Guest if not logged in
              leading: IconButton(
                icon: const Icon(Icons.logout, color: Colors.black),
                onPressed: () {
                  // Trigger logout using AuthBloc
                  context.read<AuthBloc>().add(AuthSignOutEvent());
                },
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHome(context),
                    const SizedBox(height: 20),

                    if (user != null)
                      _logoutButton(context), // Optional: logout button in body
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHome(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/dinoCoin.png',
          width: 150,
          height: 150,
        ),
      ],
    );
  }

  // Build user title in AppBar
  Widget _buildUserTitle(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hello, ',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ),
        Text(
          user.email!,
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  // Optional: logout button in body
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
        // Trigger logout using AuthBloc
        context.read<AuthBloc>().add(AuthSignOutEvent());
      },
      child: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
