import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uts_game_catch_coin/pages/home_pages.dart';
import 'package:uts_game_catch_coin/pages/login_page.dart';
import 'package:uts_game_catch_coin/pages/register_pages.dart';

final GoRouter router = GoRouter(
  //   initialLocation: '/login',
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return '/login';
    } else {
      return null;
    }
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return Login();
      },
    ),
    GoRoute(
      path: '/homepages',
      name: 'home',
      builder: (context, state) {
        return Home();
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) {
        return Signup();
      },
    )
  ],
);
