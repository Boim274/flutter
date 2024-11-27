import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // For Bloc
import 'package:uts_game_catch_coin/visibility_cubit.dart';
import 'package:uts_game_catch_coin/bloc/auth/auth_bloc.dart'; // Import AuthBloc
import 'register_pages.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF176), // Light yellow background
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
              const SizedBox(height: 8),
              Text(
                'Selamat Datang, Silahkan Login!',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              _emailField(),
              const SizedBox(height: 20),
              _passwordField(context), // Updated password field widget
              const SizedBox(height: 16),
              const SizedBox(height: 40),
              _loginButton(context),
              const SizedBox(height: 20),
              _signup(context), // Sign-up link
              const SizedBox(height: 20),
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

  // Password field with visibility toggle
  Widget _passwordField(BuildContext context) {
    return BlocConsumer<VisibilityCubit, bool>(
      listener: (context, state) {
        // Handle any side effects here if needed
      },
      builder: (context, isObscured) {
        return TextField(
          controller: _passwordController,
          obscureText: isObscured, // Toggle based on state
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
                    : Icons.visibility, // Toggle between visibility icons
              ),
              onPressed: () {
                context
                    .read<VisibilityCubit>()
                    .change(); // Toggle password visibility
              },
            ),
          ),
        );
      },
    );
  }

  // Login button
  Widget _loginButton(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          // Show loading indicator while authenticating
          showDialog(
            context: context,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccessState) {
          // Navigate to the home page on successful login
          Navigator.pop(context); // Close loading dialog
          Navigator.pushReplacementNamed(context, '/');
        } else if (state is AuthErrorState) {
          // Show error message if authentication fails
          Navigator.pop(context); // Close the loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: ElevatedButton(
        onPressed: () {
          // Trigger AuthSignInEvent when login button is pressed
          context.read<AuthBloc>().add(
                AuthSignInEvent(
                  email: _emailController.text,
                  password: _passwordController.text,
                ),
              );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5D4037), // Dark brown
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.black.withOpacity(0.3),
          elevation: 5,
        ),
        child: Text(
          'Log In',
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

  // Sign-up link widget
  Widget _signup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          const TextSpan(
            text: "buat akun? ",
            style: TextStyle(
                color: Color.fromARGB(255, 49, 49, 49),
                fontWeight: FontWeight.normal,
                fontSize: 16),
          ),
          TextSpan(
              text: "Create Account",
              style: const TextStyle(
                  color: Color(0xff1A1D1E),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                }),
        ]),
      ),
    );
  }
}
