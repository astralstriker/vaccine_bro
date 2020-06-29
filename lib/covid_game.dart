import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Position;
import 'package:covid_fighters/characters/doctor/doctor.dart';
import 'package:covid_fighters/characters/enemy/virus/virus.dart';
import 'package:covid_fighters/components/boundaries.dart';
import 'package:covid_fighters/stages/elements.dart';
import 'package:covid_fighters/stages/platform_body_component.dart';
import 'package:covid_fighters/stages/stage.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/box2d/box2d_game.dart';
import 'package:flame/box2d/contact_callbacks.dart';
import 'package:flame/flame_audio.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

class CovidGame extends Box2DGame with TapDetector {
 

  Random rnd = Random();
  List<BodyComponent> walls;
  bool isGameRunning = true;
  List<Virus> viruses = [];
  List<AttackParticle> attackParticles = [];
  CovidGame(Box2DComponent box, Size screenSize) : super(box) {
    size = screenSize;
    startGame();
  }

  startGame() {
    isGameRunning = true;
    walls = List<BodyComponent>();
    walls.addAll(createBoundaries(box));
    walls.addAll(createStage2Platforms(box, size));
    doctorBoxComponent = DoctorBodyComponent(box, Vector2(0, 0));
    doctor = DoctorComponent(64, doctorBoxComponent, box);
    groundComponent = GroundComponent(size);
    addContactCallback(DoctorVirusCallback(this));
    addContactCallback(WallParticleContactCallback(this));
    addContactCallback(AttackVirusCallback(this));
    spawnVirus();
    add(doctor);
    spawner = VirusSpawner(this);
  }

  DoctorComponent doctor;
  DoctorBodyComponent doctorBoxComponent;
  VirusBodyComponent virusBodyComponent;
  GroundComponent groundComponent;

  List<PlatformBodyComponent> platformBodyComponents;
  List<PlatformComponent> platformComponents;
  Size get screenSize => size;
  Size get tileSize => size / 9;
  VirusSpawner spawner;

  int virusIdCounter = 0;
  int attackParticleIdCounter = 0;

  void spawnVirus() {
    double x = rnd.nextDouble() * (screenSize.width - 96);
    double y = 96;

    final _virusBodyComponent = VirusBodyComponent(
        box, box.viewport.getScreenToWorld(Vector2(x, y)), virusIdCounter);

    switch (rnd.nextInt(2)) {
      case 0:
        viruses.add(MeleeVirus(64, _virusBodyComponent, virusIdCounter));
        break;
      case 1:
        viruses.add(RangedVirus(96, _virusBodyComponent, virusIdCounter));
        break;
    }

    virusIdCounter++;
  }

  void start() {}

  @override
  void render(Canvas canvas) {
    canvas.drawPaint(Paint()..color = Colors.grey[100]);
    groundComponent.render(canvas);
    viruses.forEach((Virus virus) => virus.render(canvas));
    attackParticles.forEach((p) => p.render(canvas));
    super.render(canvas);
  }

  @override
  void update(double t) {
    spawner.update(t);
    super.update(t);
  }
}

class VirusSpawner {
  final CovidGame game;
  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 250;
  final int intervalChange = 3;
  final int maxFliesOnScreen = 7;
  int currentInterval;
  int nextSpawn;

  VirusSpawner(this.game) {
    start();
    game.spawnVirus();
  }

  void start() {
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAll() {}

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int virusesOnScreen = game.viruses.length;

    if (nowTimestamp >= nextSpawn && virusesOnScreen < maxFliesOnScreen) {
      game.spawnVirus();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }
}

class AttackVirusCallback
    extends ContactCallback<AttackParticle, VirusBodyComponent> {
  final CovidGame game;

  AttackVirusCallback(this.game);
  @override
  void begin(AttackParticle attackParticle, VirusBodyComponent virus,
      Contact contact) {
    game.viruses.removeWhere((v) => v.id == virus.id);
    game.attackParticles.removeWhere((v) => v.id == attackParticle.id);
    virus.markForDestroy = true;
    attackParticle.markForDestroy = true;
  }

  @override
  void end(AttackParticle a, VirusBodyComponent b, Contact contact) {}
}

class WallParticleContactCallback
    extends ContactCallback<AttackParticle, Wall> {
  final CovidGame game;

  WallParticleContactCallback(this.game);
  @override
  void begin(AttackParticle p, Wall w, Contact contact) {
    game.attackParticles.removeWhere((v) => v.id == p.id);
    p.markForDestroy = true;
  }

  @override
  void end(AttackParticle a, Wall b, Contact contact) {}
}

class DoctorVirusCallback
    extends ContactCallback<DoctorBodyComponent, VirusBodyComponent> {
  final CovidGame game;

  DoctorVirusCallback(this.game);
  @override
  void begin(DoctorBodyComponent doc, VirusBodyComponent w, Contact contact) {
    if (game.isGameRunning) {
      FlameAudio().play('death.mp3');
    }
    game.isGameRunning = false;

    game.pauseEngine();
  }

  @override
  void end(DoctorBodyComponent a, VirusBodyComponent b, Contact contact) {}
}
