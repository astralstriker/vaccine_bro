import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:covid_fighters/stages/platform_body_component.dart';
import 'package:flame/anchor.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';

class GroundComponent extends SpriteComponent {
  Size _size;

  GroundComponent(Size size) {
    _size = size;
    this.height = 40;
    this.width = size.width;
    this.sprite = Sprite('stage/ground.png');
    this.anchor = Anchor.centerLeft;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(0, _size.height - 20);
    super.render(canvas);
    canvas.restore();
  }
}



class PlatformComponent extends SpriteComponent {
  Vector2 _position;

  final PlatformBodyComponent bodyComponent;

  PlatformComponent(this.bodyComponent, Sprite sprite, Size size, Anchor anchor,
      Vector2 position) {
    _position = position;
    this.height = 36;
    this.width = size.width;
    this.sprite = sprite;
    this.anchor = anchor;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(_position.x, _position.y);
    super.render(canvas);
    canvas.restore();
  }
}

class LeftPlatformComponent extends PlatformComponent {
  LeftPlatformComponent(LeftPlatformBodyComponent body, Size size, Vector2 position)
      : super(body, Sprite('stage/platform_left.png'),size, Anchor.centerLeft,
            position);
}

class RightPlatformComponent extends PlatformComponent {
  RightPlatformComponent(RightPlatformBodyComponent body, Size size, Vector2 position)
      : super(body,  Sprite('stage/platform_right.png'),size, Anchor.centerRight,
            position);
}

class MiddlePlatformComponent extends PlatformComponent {
  MiddlePlatformComponent(MiddlePlatformBodyComponent body, Size size, Vector2 position)
      : super(body, Sprite('stage/platform_middle.png'),size,  Anchor.center,
            position);
}
