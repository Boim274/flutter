import 'package:flame/components.dart';
import 'dart:math'; // For randomization

class Coin extends SpriteComponent with HasGameRef {
  static final Random _random = Random(); // Random object for randomization

  Coin() : super(size: Vector2(50, 50)); // Size of the coin

  @override
  Future<void> onLoad() async {
    // Load the coin sprite (make sure the sprite image is in assets/images/)
    sprite = await gameRef.loadSprite('coin.png');

    // Randomize the horizontal position (left to right) of the coin
    position = Vector2(
      _random.nextDouble() *
          gameRef.size.x, // Random x position within screen width
      gameRef.size.y -
          300, // Set it to spawn near the bottom (adjust as needed)
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Coins move horizontally like cactus
    position.x -= 200 * dt; // Horizontal movement (same speed as cactus)

    // Remove the coin if it moves off the screen (left side of the screen)
    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}
