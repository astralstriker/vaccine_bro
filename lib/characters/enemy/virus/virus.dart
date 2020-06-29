import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Position;
import 'package:flame/anchor.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/palette.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

class Virus extends SpriteComponent {
  CoatingStage stage;
  Sprite get idleSprite => Sprite('virus/ranged_virus.png');

  final int id;

  final VirusBodyComponent bodyComponent;

  Virus(double tileSize, this.bodyComponent, this.id) {
    width = tileSize;
    height = tileSize;
    sprite = idleSprite;
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final position =
        bodyComponent.viewport.getWorldToScreen(bodyComponent.center);
    canvas.save();
    canvas.translate(position.x, position.y);
    super.render(canvas);
    canvas.restore();
  }
}

class MeleeVirus extends Virus {
  @override
  Sprite get idleSprite => Sprite('virus/melee_virus.png');
  MeleeVirus(double tileSize, VirusBodyComponent component, int id)
      : super(tileSize, component, id);
}

@override
class RangedVirus extends Virus {
  Sprite get idleSprite => Sprite('virus/ranged_virus.png');

  RangedVirus(double tileSize, VirusBodyComponent bodyComponent, int id)
      : super(tileSize, bodyComponent, id);
}

class VirusBodyComponent extends BodyComponent {
  VirusBodyComponent(
    Box2DComponent box,
    Vector2 position,
    this.id,
  ) : super(box) {
    _createBody(position);
  }

  final int id;
  bool markForDestroy = false;

  Paint paint = BasicPalette.white.paint;

  _createBody(Vector2 position) {
    CircleShape shape = CircleShape();
    shape.radius = 3;
    final fixtureDef = FixtureDef()
      ..shape = shape
      ..density = 1.0
      ..restitution = 1.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
      ..setUserData(this) // To be able to determine object in collision
      ..position = position
      ..linearVelocity = Vector2(-10, 0)
      ..type = BodyType.DYNAMIC;

    body = world.createBody(bodyDef)..createFixtureFromFixtureDef(fixtureDef);
  }

  @override
  bool destroy() {
    return markForDestroy;
  }

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, paint);
    super.renderCircle(canvas, center, radius);
  }
}

enum CoatingStage {
  Stage_0,
  Stage_1,
  Stage_2,
  Stage_3,
  Stage_4,
}
