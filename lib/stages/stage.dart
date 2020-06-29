import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:covid_fighters/stages/platform_body_component.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:flame/game/game.dart';

import 'elements.dart';

// class Stage extends BodyComponent {
//   final Size size;

//   Stage(Box2DComponent box, this.size, this.platforms) : super(box) {
//     groundComponent = GroundComponent(size);
//     _createBody();
//   }

//   _createBody() {
//     PolygonShape shape = PolygonShape();
//     shape.setAsBoxXY(viewport.width / 2, viewport.height / 2);
//     final fixtureDef = FixtureDef()
//       ..shape = shape
//       ..restitution = 0.0
//       ..friction = 0.0;

//     final bodyDef = BodyDef()
//       ..setUserData(this) 
//       ..position = Vector2.zero()
//       ..type = BodyType.STATIC;

//     body = world.createBody(bodyDef)..createFixtureFromFixtureDef(fixtureDef);
//   }

//   GroundComponent groundComponent;

//   final List<PlatformComponent> platforms;
//   @override
//   void renderPolygon(Canvas canvas, List<Offset> points) {
//     canvas.save();
//     groundComponent.render(canvas);
//     platforms.forEach((platform) => platform.render(canvas));
//     canvas.restore();
//   }

//   @override
//   void update(double t) {}
// }

class Stage extends BodyComponent {
  Stage(Box2DComponent box) : super(box);

  _createBody(){



  }

}

class PlatformPosition {
  Vector2 v1;
  Vector2 v2;
}

List<PlatformBodyComponent> createStage1Platforms(
    Box2DComponent box, Size size) {
  return [
    LeftPlatformBodyComponent(box, Size(size.width * 0.4, size.height),
        Vector2(0, size.height * 0.75)),
    MiddlePlatformBodyComponent(box, Size(size.width * 0.4, size.height),
        Vector2(size.width * 0.25, size.height * 0.55)),
    LeftPlatformBodyComponent(box, Size(size.width * 0.4, size.height),
        Vector2(0, size.height * 0.35)),
    RightPlatformBodyComponent(box, Size(size.width * 0.4, size.height),
        Vector2(size.width, size.height * 0.6)),
    RightPlatformBodyComponent(box, Size(size.width * 0.4, size.height),
        Vector2(size.width, size.height * 0.55))
  ];
}
List<PlatformBodyComponent> createStage2Platforms(
    Box2DComponent box, Size size) {
  return [
      LeftPlatformBodyComponent(box, Size(size.width * 0.25, size.height),
          Vector2(0, size.height * 0.75)),
      MiddlePlatformBodyComponent(box, Size(size.width * 0.25, size.height),
          Vector2(size.width / 2, size.height * 0.75)),
      RightPlatformBodyComponent(box, Size(size.width * 0.25, size.height),
          Vector2(size.width, size.height * 0.75)),
      MiddlePlatformBodyComponent(box, Size(size.width * 0.35, size.height),
          Vector2(size.width * 0.25, size.height * 0.55)),
      MiddlePlatformBodyComponent(box, Size(size.width * 0.35, size.height),
          Vector2(size.width * 0.75, size.height * 0.55)),
      MiddlePlatformBodyComponent(box, Size(size.width * 0.6, size.height),
          Vector2(size.width * 0.5, size.height * 0.35)),
      MiddlePlatformBodyComponent(box, Size(size.width * 0.35, size.height),
          Vector2(size.width * 0.5, size.height * 0.27)),
    ];
}
