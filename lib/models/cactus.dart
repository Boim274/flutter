import 'package:flame/components.dart';
import 'dart:math'; // For randomization

class Cactus extends SpriteComponent with HasGameRef {
  static final Random _random = Random(); // Random object for randomization
  static const List<String> _spriteList = [
    'snowy_rock1.png',
    'snowy_rock2.png',
    'snowy_rock3.png',
    'snowy_rock4.png',
  ];

  // Randomize the size between a set range (optional)
  static const double minCactusHeight = 30.0;
  static const double maxCactusHeight = 50.0;
  static const double minCactusWidth = 30.0;
  static const double maxCactusWidth = 50.0;

  Cactus() : super(size: Vector2.zero()); // Size will be set in onLoad

  @override
  Future<void> onLoad() async {
    // Randomly pick a sprite from the list
    final spriteName = _spriteList[_random.nextInt(_spriteList.length)];
    sprite = await gameRef.loadSprite(spriteName);

    // Randomize the size of the cactus within a range
    size = Vector2(
      _random.nextDouble() * (maxCactusWidth - minCactusWidth) + minCactusWidth,
      _random.nextDouble() * (maxCactusHeight - minCactusHeight) +
          minCactusHeight,
    );

    // Position the cactus at the right side of the screen (off-screen)
    position = Vector2(gameRef.size.x, gameRef.size.y - size.y - 20);

    // Optionally, add random vertical offset (randomize its height)
    // position.y -= _random.nextDouble() * 100; // Randomize cactus height slightly (optional)
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= 200 * dt; // Move to the left

    if (position.x < -size.x) {
      removeFromParent(); // Remove cactus if it moves off-screen
    }
  }
}
