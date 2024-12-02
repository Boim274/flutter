import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // For Google Fonts
import 'register_pages.dart';
import 'package:uts_game_catch_coin/routes/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_game_catch_coin/bloc/auth/auth_bloc.dart';
import 'package:uts_game_catch_coin/visibility_cubit.dart'; // Import VisibilityCubit

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF176),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF176),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate to the home page
            GoRouter.of(context).go('/');
          },
        ),
        title: Text(
          'Log In',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => AuthBloc(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              _buildLogo(),
              const SizedBox(height: 10),
              _buildWelcomeText(),
              const SizedBox(height: 20),
              _emailField(),
              const SizedBox(height: 10),
              _passwordField(context),
              const SizedBox(height: 20),
              _loginButton(context),
              const SizedBox(height: 10),
              _signup(context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the logo image
  Widget _buildLogo() {
    return Image.asset(
      'assets/images/dinoCoin.png',
      width: 200,
      height: 200,
    );
  }

  // Welcome text widget
  Widget _buildWelcomeText() {
    return Text(
      'Selamat Datang, Silahkan Login!',
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
      ),
    );
  }

  // Email text field widget
  Widget _emailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFF9C4),
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
      listener: (context, state) {},
      builder: (context, isObscured) {
        return TextField(
          controller: _passwordController,
          obscureText: isObscured,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFF9C4),
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
                isObscured ? Icons.visibility_off : Icons.visibility,
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

  // Login button widget
  Widget _loginButton(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is AuthStateLoaded) {
          context.goNamed(Routes.home); // Navigate to home page on success
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is! AuthStateLoading
              ? () {
                  if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    context.read<AuthBloc>().add(
                          AuthEventLogin(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email dan password harus diisi')),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5D4037),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: Colors.black.withOpacity(0.3),
            elevation: 5,
          ),
          child: state is AuthStateLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                ) // Show loading indicator when logging in
              : Text(
                  'Log In',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
        );
      },
    );
  }

  // Sign-up link widget
  Widget _signup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Buat akun? ",
              style: TextStyle(
                color: Color.fromARGB(255, 49, 49, 49),
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: "Create Account",
              style: const TextStyle(
                color: Color(0xff1A1D1E),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
