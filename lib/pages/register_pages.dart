import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // For Bloc
import 'package:uts_game_catch_coin/bloc/auth/auth_bloc.dart';
import 'package:uts_game_catch_coin/pages/login_page.dart';
import 'package:uts_game_catch_coin/visibility_cubit.dart'; // Import the VisibilityCubit

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF176), // Light yellow background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF176), // Sama dengan background
        elevation: 0, // Menghilangkan bayangan AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman login
          },
        ),
        title: Text(
          'Sign Up',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true, // Menengahkan judul AppBar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/dinoCoin.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 5),
              Text(
                'Buat akun baru, silahkan daftar!',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _emailField(),
              const SizedBox(height: 20),
              _passwordField(),
              const SizedBox(height: 20),
              _confirmPasswordField(),
              const SizedBox(height: 40),
              _signupButton(context),
              const SizedBox(height: 20),
              _signin(context),
            ],
          ),
        ),
      ),
    );
  }

  // Email text field
  Widget _emailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFF9C4), // Light yellow
        hintText: 'email@gmail.com',
        hintStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Password field
  Widget _passwordField() {
    return BlocConsumer<VisibilityCubit, bool>(
      listener: (context, state) {},
      builder: (context, isObscured) {
        return TextField(
          controller: _passwordController,
          obscureText: isObscured, // Toggle visibility
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFF9C4), // Light yellow
            hintText: 'Password',
            hintStyle: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured
                    ? Icons.visibility_off
                    : Icons.visibility, // Toggle visibility icons
              ),
              onPressed: () {
                context.read<VisibilityCubit>().change();
              },
            ),
          ),
        );
      },
    );
  }

  // Confirm Password field
  Widget _confirmPasswordField() {
    return BlocConsumer<VisibilityCubit, bool>(
      listener: (context, state) {},
      builder: (context, isObscured) {
        return TextField(
          controller: _confirmPasswordController,
          obscureText: isObscured,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFF9C4),
            hintText: 'Confirm Password',
            hintStyle: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured
                    ? Icons.visibility_off
                    : Icons.visibility, // Toggle visibility icons
              ),
              onPressed: () {
                context.read<VisibilityCubit>().change();
              },
            ),
          ),
        );
      },
    );
  }

  // Signup button
  Widget _signupButton(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        } else if (state is AuthSuccessState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5D4037), // Dark brown
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.black.withOpacity(0.3),
          elevation: 5,
        ),
        onPressed: () {
          if (_passwordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords do not match')),
            );
          } else {
            context.read<AuthBloc>().add(
                  AuthSignUpEvent(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
          }
        },
        child: Text(
          'Sign Up',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // Sign-in link
  Widget _signin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          const TextSpan(
            text: "Sudah punya akun? ",
            style: TextStyle(
              color: Color.fromARGB(255, 55, 55, 55),
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: "Log In",
            style: const TextStyle(
              color: Color(0xff1A1D1E),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
          ),
        ]),
      ),
    );
  }
}
