import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Position;
import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/box2d/viewport.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/palette.dart';
import 'package:flame/particles/accelerated_particle.dart';
import 'package:flame/particles/circle_particle.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Animation;

/* 
World Origin - Screen Center
SCreen Origin - Top Left of Screen
*/

class AttackParticle extends BodyComponent {
  bool markForDestroy = false;
  double duration = 0;
  int id = 0;
  final double lifespan;
  AttackParticle(
      Box2DComponent box, Vector2 position, bool isLeft, this.lifespan)
      : super(box) {
    CircleShape shape = CircleShape();
    shape.radius = 3.5;
    final fixtureDef = FixtureDef()
      ..shape = shape
      ..density = 0.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
      ..setUserData(this) // To be able to determine object in collision
      ..position = position
      ..type = BodyType.DYNAMIC
      ..gravityScale = 0
      ..bullet = true
      ..linearVelocity = Vector2(isLeft ? -80 : 80, 0);

    body = world.createBody(bodyDef)..createFixtureFromFixtureDef(fixtureDef);
  }
  @override
  bool destroy() {
    return markForDestroy;
  }

  @override
  void update(double t) {
    if(markForDestroy){
      world.destroyBody(body);
    }
    duration += t;
    super.update(t);
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = Colors.red);
  }
}

class DoctorComponent extends SpriteComponent {
  Sprite get idleSprite => Sprite('doctor/idle.png');
  Sprite get attackSprite1 => Sprite('doctor/attack_1.png');
  Sprite get attackSprite2 => Sprite('doctor/attack_2.png');
  Sprite get idleSpriteRight => Sprite('doctor/idle_right.png');
  Sprite get attackSprite1Right => Sprite('doctor/attack_1_right.png');
  Sprite get attackSprite2Right => Sprite('doctor/attack_2_right.png');

  final DoctorBodyComponent bodyComponent;
  final Box2DComponent box;

  bool isAttacking = false;
  bool isFacingLeft = true;

  Animation leftAnim;
  Animation rightAnim;

  DoctorComponent(double tileSize, this.bodyComponent, this.box) {
    width = tileSize * 0.8;
    height = tileSize;
    sprite = idleSprite;
    anchor = Anchor.center;
    leftAnim = Animation.spriteList(
        [idleSprite, attackSprite1, attackSprite2, idleSprite],
        stepTime: 0.08, loop: false);
    rightAnim = Animation.spriteList([
      idleSpriteRight,
      attackSprite1Right,
      attackSprite2Right,
      idleSpriteRight
    ], stepTime: 0.08, loop: false);
  }

  @override
  void update(double dt) {
    if (isFacingLeft) {
      if (isAttacking) {
        leftAnim.update(dt);
        sprite = leftAnim.getSprite();
        if (leftAnim.done()) {
          isAttacking = false;
        }
      } else {
        sprite = idleSprite;
      }
    } else {
      if (isAttacking) {
        rightAnim.update(dt);
        sprite = rightAnim.getSprite();
        if (rightAnim.done()) {
          isAttacking = false;
        }
      } else {
        sprite = idleSpriteRight;
      }
    }
    super.update(dt);
  }

  void moveLeft() {
    isFacingLeft = true;
    Vector2 force = new Vector2(-40, 0)..scale(100.0);
    bodyComponent.body.applyLinearImpulse(force, bodyComponent.center, true);
  }

  void moveRight() {
    isFacingLeft = false;
    Vector2 force = new Vector2(40, 0)..scale(100.0);
    bodyComponent.body.applyLinearImpulse(force, bodyComponent.center, true);
  }

  AttackParticle doAttack() {
    if (!isAttacking) {
      leftAnim.reset();
      rightAnim.reset();
      isAttacking = true;

      final center = bodyComponent.body.position;
      if (isFacingLeft) {
        return AttackParticle(box, center - Vector2(8.0, y), true, 3.0);
      } else {
        return AttackParticle(box, center - Vector2(-8.0, y), false, 3.0);
      }
    }
    return null;
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

class DoctorBodyComponent extends BodyComponent {
  DoctorBodyComponent(Box2DComponent box, Vector2 position) : super(box) {
    _createBody(position);
  }

  Paint paint = BasicPalette.white.paint;

  _createBody(Vector2 position) {
    PolygonShape shape = PolygonShape();
    shape.setAsBoxXY(3.5, 7.5);
    final fixtureDef = FixtureDef()
      ..shape = shape
      ..density = 1.0
      ..restitution = 0.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
      ..setUserData(this) // To be able to determine object in collision
      ..position = position
      ..gravityScale = 10
      ..fixedRotation = true
      ..linearDamping = 5
      ..type = BodyType.DYNAMIC;

    body = world.createBody(bodyDef)..createFixtureFromFixtureDef(fixtureDef);
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, paint);
    super.renderCircle(canvas, center, radius);
  }
}

extension _ on Vector2 {
  Offset toOffset() => Offset(this.x, this.y);
}
