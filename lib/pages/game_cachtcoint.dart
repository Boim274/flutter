import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
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
  late Timer speedIncreaseTimer;
  late int score;
  late int coinCount;
  late int health;
  late TextComponent scoreText;
  late TextComponent coinCountText;
  late List<SpriteComponent> hearts;
  late ParallaxComponent background;

  double spawnInterval = 2.0;
  double collisionCooldown = 0;
  final void Function(int score, int coinCount) onGameOver;

  bool isPaused = false;
  late SpriteComponent pauseButton;
  late TextComponent pauseMessage;

  DinoRunGame({required this.onGameOver});

  @override
  Future<void> onLoad() async {
    // Background
    background = await loadParallaxComponent(
      [
        ParallaxImageData('Preview-taman.png'),
        ParallaxImageData('Taman2.png'),
        ParallaxImageData('Taman1.png'),
      ],
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(1.5, 1.0),
    );
    add(background);

    // Initialize variables
    score = 0;
    coinCount = 0;
    health = 3;

    ground = Ground();
    add(ground);

    await Future.delayed(Duration.zero);
    dino = Dino();
    dino.position = Vector2(50, ground.position.y - dino.size.y);
    add(dino);

    // UI: Score and Coins
    final textBackground = RectangleComponent(
      position: Vector2(0, size.y - 80),
      size: Vector2(size.x, 80),
      paint: Paint()..color = const Color(0x80000000),
    );
    add(textBackground);

    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(10, size.y - 70),
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 24, color: const Color(0xFFFFFFFF)),
      ),
    );
    add(scoreText);

    coinCountText = TextComponent(
      text: 'Coins: $coinCount',
      position: Vector2(size.x - 150, size.y - 70),
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 24, color: const Color(0xFFFFD700)),
      ),
    );
    add(coinCountText);

    // UI: Health (Hearts)
    hearts = [];
    for (int i = 0; i < health; i++) {
      final heart = SpriteComponent()
        ..sprite = await loadSprite('heart.png')
        ..size = Vector2(30, 30)
        ..position = Vector2(10 + i * 35, size.y - 120);
      hearts.add(heart);
      add(heart);
    }

    // Timers
    obstacleTimer = Timer(spawnInterval, onTick: spawnCactus, repeat: true);
    obstacleTimer.start();

    coinTimer = Timer(1.5, onTick: spawnCoin, repeat: true);
    coinTimer.start();

    speedIncreaseTimer = Timer(15.0, onTick: increaseSpeed, repeat: true);
    speedIncreaseTimer.start();

    FlameAudio.bgm.play('sound.wav');

    // Pause Button
    pauseButton = SpriteComponent()
      ..sprite = await loadSprite('pause.png')
      ..size = Vector2(50, 50)
      ..position = Vector2(size.x - 60, 50);
    add(pauseButton);

    // Pause Message
    pauseMessage = TextComponent(
      text: 'Game Paused',
      position: Vector2(size.x / 2 - 100, size.y / 2 - 15),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 30,
          color: const Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isPaused) return;

    obstacleTimer.update(dt);
    coinTimer.update(dt);
    speedIncreaseTimer.update(dt);

    score += 1;
    scoreText.text = 'Score: $score';

    if (collisionCooldown > 0) {
      collisionCooldown -= dt;
    }

    for (final cactus in children.whereType<Cactus>()) {
      if (dino.toRect().overlaps(cactus.toRect()) && collisionCooldown <= 0) {
        handleCollisionWithCactus();
        collisionCooldown = 1.0;
        break;
      }
    }

    for (final coin in children.whereType<Coin>()) {
      if (dino.toRect().overlaps(coin.toRect())) {
        handleCollisionWithCoin(coin);
      }
    }
  }

  @override
  void onTap() {
    if (isPaused) return;

    FlameAudio.play('jump14.wav');
    dino.jump();
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (pauseButton.toRect().contains(
        Offset(info.eventPosition.global.x, info.eventPosition.global.y))) {
      togglePause();
    }
  }

  void spawnCactus() {
    if (isPaused) return;
    add(Cactus());
  }

  void spawnCoin() {
    if (isPaused) return;
    add(Coin());
  }

  void handleCollisionWithCactus() {
    health--;
    updateHealthUI();
    FlameAudio.play('hurt7.wav');

    if (health <= 0) {
      gameOver();
    }
  }

  void handleCollisionWithCoin(Coin coin) {
    coinCount += 1;
    coin.removeFromParent();
    coinCountText.text = 'Coins: $coinCount';
    FlameAudio.play('coin.mp3');
  }

  void updateHealthUI() {
    if (health < hearts.length) {
      hearts.last.removeFromParent();
      hearts.removeLast();
    }
  }

  void gameOver() {
    FlameAudio.play('game_over.mp3');
    FlameAudio.bgm.stop();
    pauseEngine();
    Future.delayed(const Duration(seconds: 3), () {
      onGameOver(score, coinCount);
    });
  }

  void increaseSpeed() {
    if (spawnInterval > 0.5) {
      spawnInterval -= 0.1;
      obstacleTimer = Timer(spawnInterval, onTick: spawnCactus, repeat: true);
      obstacleTimer.start();
    }
  }

  void togglePause() async {
    if (isPaused) {
      resumeEngine();
      isPaused = false;
      pauseButton.sprite = await loadSprite('pause.png');
      pauseMessage.removeFromParent();
    } else {
      pauseEngine();
      isPaused = true;
      pauseButton.sprite = await loadSprite('play.png');
      if (!children.contains(pauseMessage)) {
        add(pauseMessage);
      }
    }
  }
}
