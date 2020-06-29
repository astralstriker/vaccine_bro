import 'dart:async';

import 'package:covid_fighters/characters/doctor/doctor.dart';
import 'package:covid_fighters/covid_game.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/flame.dart';
import 'package:flame/flame_audio.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setLandscape();

  Flame.audio.loopLongAudio('background_.mp3');

  final size = await flameUtil.initialDimensions();
  final MyBox2D box = MyBox2D();
  startGame(box, size);
}

startGame(MyBox2D box, Size size) {
  CovidGame game = CovidGame(box, size);
  runApp(MyApp(game: game));
  game.start();
}

class MyApp extends StatefulWidget {
  final CovidGame game;

  const MyApp({Key key, this.game}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virus Destroyer',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              widget.game.widget,
              Align(
                  alignment: Alignment.center,
                  child: Controls(
                    game: widget.game,
                  )),
              if (!widget.game.isGameRunning) Menu()
            ],
          ),
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ModalBarrier(
          dismissible: false,
          color: Colors.black45,
        ),
        Center(
          child: MaterialButton(
              child: Icon(Icons.refresh),
              enableFeedback: false,
              onPressed: () {
                main();
              }),
        ),
      ],
    );
  }
}

class Score extends StatefulWidget {
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Controls extends StatefulWidget {
  final CovidGame game;

  const Controls({Key key, this.game}) : super(key: key);
  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Opacity(
        opacity: 0.3,
        child: Row(
          children: <Widget>[
            Container(
                height: 64,
                child: MaterialButton(
                  enableFeedback: false,
                  shape: CircleBorder(),
                  onPressed: widget.game.doctor.moveLeft,
                  color: Colors.black,
                  child: Icon(Icons.arrow_left, color: Colors.white),
                )),
            Container(
                height: 64,
                child: MaterialButton(
                  enableFeedback: false,
                  shape: CircleBorder(),
                  onPressed: widget.game.doctor.moveRight,
                  color: Colors.black,
                  child: Icon(Icons.arrow_right, color: Colors.white),
                )),
            Spacer(),
            Container(
                height: 64,
                child: MaterialButton(
                  enableFeedback: false,
                  shape: CircleBorder(),
                  onPressed: () {
                    final particle = widget.game.doctor.doAttack();
                    if (particle != null) {
                        FlameAudio().play('attack.mp3');

                      widget.game.attackParticles.add(
                          particle..id = widget.game.attackParticleIdCounter);
                      widget.game.attackParticleIdCounter++;
                    }
                  },
                  color: Colors.black,
                  child: Icon(Icons.my_location, color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}

class MyBox2D extends Box2DComponent {
  MyBox2D() : super(scale: 4.0, gravity: -10.0);

  @override
  void initializeWorld() {}
}
