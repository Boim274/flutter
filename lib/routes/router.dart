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
  initialLocation: '/splash', // Set '/splash' as the initial location
  redirect: (context, state) async {
    final auth = FirebaseAuth.instance;

    // Allow splash screen to display without redirect
    if (state.fullPath == '/splash') {
      return null; // Do not redirect from the splash screen
    }

    // Allow register page to be accessible without login
    if (state.fullPath == '/register') {
      return null; // Do not redirect from the register page
    }

    // Redirect to login if not authenticated and not on public pages
    if (auth.currentUser == null &&
        state.fullPath != '/login' &&
        state.fullPath != '/register') {
      return '/login'; // Redirect to login if not authenticated
    }

    return null;
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

    // Game Over route (handles score and coins)
    GoRoute(
      path: '/gameover',
      name: 'gameover',
      builder: (context, state) {
        final score =
            int.tryParse(state.uri.queryParameters['score'] ?? '0') ?? 0;
        final coins =
            int.tryParse(state.uri.queryParameters['coins'] ?? '0') ?? 0;
        return GameOverScreen(
          score: score,
          coins: coins,
        );
      },
    ),

    // Game route
    GoRoute(
      path: '/game',
      name: 'game',
      builder: (context, state) {
        return GameWidget(
          game: DinoRunGame(
            onGameOver: (score, coinCount) {
              // Navigate to gameover screen with score and coin count
              context.go('/gameover?score=$score&coins=$coinCount');
            },
          ),
        );
      },
    ),
  ],
);
