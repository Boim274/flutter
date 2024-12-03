import 'package:flame/components.dart';
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
  late int score;
  late int coinCount;
  late int health;
  late TextComponent scoreText;
  late TextComponent coinCountText;
  late List<SpriteComponent> hearts; // List untuk menyimpan ikon hati
  late ParallaxComponent background;

  double spawnInterval = 2.0;
  double collisionCooldown = 0; // Cooldown untuk tabrakan
  final void Function(int score, int coinCount) onGameOver;

  DinoRunGame({required this.onGameOver});

  @override
  Future<void> onLoad() async {
    // Menambahkan latar belakang parallax
    background = await loadParallaxComponent(
      [
        ParallaxImageData('Preview.png'),
        ParallaxImageData('Plan 1.png'),
        ParallaxImageData('Plan 2.png'),
        ParallaxImageData('Plan 3.png'),
        ParallaxImageData('Plan 4.png'),
      ],
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(1.5, 1.0),
    );
    add(background);

    // Inisialisasi variabel utama
    score = 0;
    coinCount = 0;
    health = 3;

    // Menambahkan ground
    ground = Ground();
    add(ground);

    // Menambahkan dino
    await Future.delayed(Duration.zero);
    dino = Dino();
    dino.position = Vector2(50, ground.position.y - dino.size.y);
    add(dino);

    // Menambahkan background untuk teks
    final textBackground = RectangleComponent(
      position: Vector2(0, size.y - 70),
      size: Vector2(size.x, 70),
      paint: Paint()..color = const Color(0x80000000),
    );
    add(textBackground);

    // Menambahkan teks skor
    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(10, size.y - 50),
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 24, color: const Color(0xFFFFFFFF)),
      ),
    );
    add(scoreText);

    // Menambahkan teks jumlah koin
    coinCountText = TextComponent(
      text: 'Coins: $coinCount',
      position: Vector2(size.x - 150, size.y - 50),
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 24, color: const Color(0xFFFFD700)),
      ),
    );
    add(coinCountText);

    // Menambahkan ikon hati
    hearts = [];
    for (int i = 0; i < health; i++) {
      final heart = SpriteComponent()
        ..sprite = await loadSprite('heart.png')
        ..size = Vector2(30, 30)
        ..position = Vector2(10 + i * 35, size.y - 100);
      hearts.add(heart);
      add(heart);
    }

    // Timer untuk spawn obstacle dan koin
    obstacleTimer = Timer(spawnInterval, onTick: spawnCactus, repeat: true);
    obstacleTimer.start();

    coinTimer = Timer(1.5, onTick: spawnCoin, repeat: true);
    coinTimer.start();

    // Memutar musik latar
    FlameAudio.bgm.play('sound.wav');
  }

  @override
  void update(double dt) {
    super.update(dt);
    obstacleTimer.update(dt);
    coinTimer.update(dt);

    score += 1;
    scoreText.text = 'Score: $score';

    // Update cooldown
    if (collisionCooldown > 0) {
      collisionCooldown -= dt;
    }

    // Meningkatkan kesulitan
    if (score % 100 == 0 && spawnInterval > 0.5) {
      spawnInterval -= 0.1;
      obstacleTimer = Timer(spawnInterval, onTick: spawnCactus, repeat: true);
      obstacleTimer.start();
    }

    // Tabrakan dengan kaktus
    for (final cactus in children.whereType<Cactus>()) {
      if (dino.toRect().overlaps(cactus.toRect()) && collisionCooldown <= 0) {
        handleCollisionWithCactus();
        collisionCooldown = 1.0; // Cooldown tabrakan
        break;
      }
    }

    // Tabrakan dengan koin
    for (final coin in children.whereType<Coin>()) {
      if (dino.toRect().overlaps(coin.toRect())) {
        handleCollisionWithCoin(coin);
      }
    }
  }

  @override
  void onTap() {
    FlameAudio.play('jump14.wav');
    dino.jump();
  }

  void spawnCactus() {
    add(Cactus());
  }

  void spawnCoin() {
    add(Coin());
  }

  void handleCollisionWithCactus() {
    health--;
    updateHealthUI();
    FlameAudio.play('hurt7.wav'); // Mainkan suara saat terkena kaktus

    if (health <= 0) {
      gameOver();
    }
  }

  void handleCollisionWithCoin(Coin coin) {
    coinCount += 1;
    coin.removeFromParent();
    coinCountText.text = 'Coins: $coinCount';
    FlameAudio.play('coin.mp3'); // Mainkan suara koin
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
    Future.delayed(const Duration(seconds: 2), () {
      onGameOver(score, coinCount);
    });
  }
}
