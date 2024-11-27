import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_game_catch_coin/bloc/auth/auth_bloc.dart';
import 'package:uts_game_catch_coin/firebase_options.dart';
import 'package:uts_game_catch_coin/visibility_cubit.dart';
import 'package:uts_game_catch_coin/routes/router.dart'; // Ensure router.dart is properly imported

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CathCoin());
}

class CathCoin extends StatelessWidget {
  const CathCoin({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()), // Provides AuthBloc to the app
        BlocProvider<VisibilityCubit>(
          create: (context) =>
              VisibilityCubit(), // Provides VisibilityCubit to the app
        ),
      ],
      child: MaterialApp.router(
        routerConfig:
            router, // Ensure 'router' is properly configured in router.dart
        debugShowCheckedModeBanner:
            false, // Disable the debug banner in production
      ),
    );
  }
}
