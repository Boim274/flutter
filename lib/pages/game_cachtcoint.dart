import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';

import 'package:uts_game_catch_coin/models/cactus.dart';
import 'package:uts_game_catch_coin/models/coin.dart';
import 'package:uts_game_catch_coin/models/dino.dart';
import 'package:uts_game_catch_coin/models/ground.dart';

class DinoRunGame extends FlameGame with TapDetector {
  late Dino dino;
  late Ground ground;
  late Timer obstacleTimer;
  late Timer coinTimer;
  late int score;
  late int coinCount;
  late int health; // Health variable
  late TextComponent scoreText;
  late TextComponent coinCountText;
  late SpriteComponent background;
  late SpriteComponent heart; // Single heart component

  double spawnInterval = 2.0;
  final VoidCallback onGameOver;

  DinoRunGame({required this.onGameOver});

  @override
  Future<void> onLoad() async {
    background = SpriteComponent()
      ..sprite = await loadSprite('bag1.jpg')
      ..size = size;
    add(background);

    score = 0;
    coinCount = 0;
    health = 3; // Start with 3 hearts

    dino = Dino();
    add(dino);

    ground = Ground();
    add(ground);

    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(10, 10),
      textRenderer: TextPaint(style: TextStyle(fontSize: 24)),
    );
    add(scoreText);

    coinCountText = TextComponent(
      text: 'Coins: $coinCount',
      position: Vector2(size.x - 120, 10),
      textRenderer: TextPaint(style: TextStyle(fontSize: 24)),
    );
    add(coinCountText);

    // Only one heart to represent health
    heart = SpriteComponent()
      ..sprite = await loadSprite('heart.png')
      ..size = Vector2(30, 30)
      ..position = Vector2(size.x - 120, 40);
    add(heart);

    obstacleTimer = Timer(spawnInterval, onTick: spawnCactus, repeat: true);
    obstacleTimer.start();

    coinTimer = Timer(1.5, onTick: spawnCoin, repeat: true);
    coinTimer.start();

    // Play background sound when the game starts
    FlameAudio.bgm.play(
        'sound.wav'); // Replace 'sound.wav' with the correct path if needed
  }

  @override
  void update(double dt) {
    super.update(dt);
    obstacleTimer.update(dt);
    coinTimer.update(dt);

    // Update score
    score += 1;
    scoreText.text = 'Score: $score';

    // Increase difficulty
    if (score % 100 == 0 && spawnInterval > 0.5) {
      spawnInterval -= 0.1;
      obstacleTimer = Timer(spawnInterval, onTick: spawnCactus, repeat: true);
      obstacleTimer.start();
    }

    // Check for collisions with obstacles (cactus)
    for (final cactus in children.whereType<Cactus>()) {
      if (dino.toRect().overlaps(cactus.toRect())) {
        if (health > 1) {
          // If there are still hearts left, reduce health
          health--;
          // Shrink heart based on health (make it smaller as health decreases)
          heart.size = Vector2(30 * health / 3, 30);
        } else {
          // Play hurt sound
          FlameAudio.play('hurt7.wav'); // Play sound on death
          // Game over when no hearts are left
          scoreText.text = 'Game Over! Score: $score';
          pauseEngine(); // Pauses the game
          Future.delayed(const Duration(seconds: 2),
              onGameOver); // Trigger game over after a delay
        }
      }
    }

    // Check for collisions with coins
    for (final coin in children.whereType<Coin>()) {
      if (dino.toRect().overlaps(coin.toRect())) {
        coinCount += 1;
        coin.removeFromParent();
        coinCountText.text = 'Coins: $coinCount';
      }
    }
  }

  @override
  void onTap() {
    // Play jump sound
    FlameAudio.play('jump14.wav'); // Play sound when dino jumps
    dino.jump();
  }

  void spawnCactus() {
    add(Cactus());
  }

  void spawnCoin() {
    add(Coin());
  }
}
