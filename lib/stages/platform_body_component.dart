import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:covid_fighters/stages/elements.dart';
import 'package:flame/anchor.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/box2d/viewport.dart';
import 'package:flame/palette.dart';

abstract class PlatformBodyComponent extends BodyComponent {
  Size _size;
  Vector2 _position;

  @override
  int priority() => 10;

  Size get size => _size;
  Vector2 get position => _position;
  PlatformBodyComponent(Box2DComponent box, Vector2 p1, Vector2 p2)
      : super(box) {
    Vector2 v1 = box.viewport.getScreenToWorld(p1),
        v2 = box.viewport.getScreenToWorld(p2);
    _createBody(v1, v2);
  }

  @override
  void renderPolygon(Canvas canvas, List<Offset> coordinates) {
    final start = coordinates[0];
    final end = coordinates[1];
    canvas.drawLine(start, end, paint);
  }

  Paint paint = BasicPalette.black.paint;
  void _createBody(Vector2 p1, Vector2 p2) {
    PolygonShape shape = PolygonShape();
    shape.setAsEdge(p2, p1);
    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 0.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
      ..setUserData(this) // To be able to determine object in collision
      ..position = Vector2.zero()
      ..type = BodyType.STATIC;

    body = box.world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  PlatformComponent toPlatformComponent(
      final Vector2 spritePosition, final Size size);
}

class LeftPlatformBodyComponent extends PlatformBodyComponent {
  LeftPlatformBodyComponent(Box2DComponent box, Size size, Vector2 position)
      : super(
          box,
          Vector2(position.x, position.y - 18),
          Vector2(position.x + size.width, position.y - 18),
        ) {
    _size = size;
    _position = position;
  }

  @override
  PlatformComponent toPlatformComponent(Vector2 spritePosition, Size size) {
    return LeftPlatformComponent(this, size, spritePosition);
  }
}

class RightPlatformBodyComponent extends PlatformBodyComponent {
  RightPlatformBodyComponent(Box2DComponent box, Size size, Vector2 position)
      : super(
          box,
          Vector2(position.x - size.width, position.y - 18),
          Vector2(position.x, position.y - 18),
        ) {
    _size = size;
    _position = position;
  }

  @override
  PlatformComponent toPlatformComponent(Vector2 spritePosition, Size size) {
    return RightPlatformComponent(this, size, spritePosition);
  }
}

class MiddlePlatformBodyComponent extends PlatformBodyComponent {
  MiddlePlatformBodyComponent(Box2DComponent box, Size size, Vector2 position)
      : super(
          box,
          Vector2(position.x - size.width / 2, position.y - 18),
          Vector2(position.x + size.width / 2, position.y - 18),
        ) {
    _size = size;
    _position = position;
  }
  @override
  PlatformComponent toPlatformComponent(Vector2 spritePosition, Size size) {
    return MiddlePlatformComponent(this, size, spritePosition);
  }
}

extension _ on Vector2 {
  Vector2 toWorldVector(Viewport v) => v.getScreenToWorld(this);
}
