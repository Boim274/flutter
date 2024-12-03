import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:uts_game_catch_coin/pages/GameOverScreen.dart';
import 'package:uts_game_catch_coin/pages/game_cachtcoint.dart';
import 'package:uts_game_catch_coin/pages/home_pages.dart';
import 'package:uts_game_catch_coin/pages/login_page.dart';
import 'package:uts_game_catch_coin/pages/register_pages.dart';
import 'package:uts_game_catch_coin/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash', // Set lokasi awal ke splash screen
  redirect: (context, state) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isLoggedIn = currentUser != null;

    // Debugging untuk memastikan lokasi URI
    if (kDebugMode) {
      print('Navigating to: ${state.uri}, User logged in: $isLoggedIn');
    }

    // Gunakan state.uri.toString() untuk mendapatkan lokasi
    if (state.uri.toString() == '/splash') {
      return isLoggedIn ? '/' : '/login';
    }
    if (!isLoggedIn && state.uri.toString() != '/login') {
      return '/login';
    }
    if (isLoggedIn && state.uri.toString() == '/login') {
      return '/';
    }

    // Tidak ada pengalihan
    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => Signup(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => Home(),
    ),
    GoRoute(
      path: '/game',
      name: 'game',
      builder: (context, state) {
        return GameWidget(
          game: DinoRunGame(
            onGameOver: () {
              Future.microtask(() {
                // ignore: use_build_context_synchronously
                context.go('/gameover'); // Menggunakan context dari builder
              });
            },
          ),
        );
      },
    ),
    GoRoute(
      path: '/gameover',
      name: 'gameover',
      builder: (context, state) => const GameOverScreen(),
    ),
  ],
);
