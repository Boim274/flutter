import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int coins;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000428), Color(0xFF004e92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Game Over!",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(3, 3),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "Score: $score",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Coins: $coins",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  context.go('/'); // Navigate back to home
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
