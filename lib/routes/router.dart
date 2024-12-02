import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:uts_game_catch_coin/pages/GameOverScreen.dart';
import 'package:uts_game_catch_coin/pages/game_cachtcoint.dart';

import 'package:uts_game_catch_coin/pages/home_pages.dart';
import 'package:uts_game_catch_coin/pages/login_page.dart';
import 'package:uts_game_catch_coin/pages/register_pages.dart';
import 'package:uts_game_catch_coin/splash_screen.dart';

final GoRouter router = GoRouter(
  // Set the initial location to '/splash'
  initialLocation: '/splash',

  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    final isLoggedIn = currentUser != null;

    // If the user is not logged in and the current route is not splash, redirect to login
    if (!isLoggedIn) {
      return state.namedLocation('splash') == '/splash' ? null : '/login';
    }

    // If the user is logged in, prevent them from going back to login or splash
    return state.namedLocation('login') == '/login' ||
            state.namedLocation('splash') == '/splash'
        ? '/'
        : null;
  },
  routes: [
    // Login route
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return Login();
      },
    ),

    // Home route
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return Home();
      },
    ),

    // Register route
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) {
        return Signup();
      },
    ),

    // Splash screen route
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/gameover',
      name: 'gameover',
      builder: (context, state) {
        return const GameOverScreen();
      },
    ),
    // Game route
    GoRoute(
      path: '/game',
      name: 'game',
      builder: (context, state) {
        return GameWidget(
          game: DinoRunGame(
            onGameOver: () {
              context.go(
                  '/gameover'); // Navigate to game over screen when game ends
            },
          ),
        );
      },
    ),
  ],
);
