import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Container(
              color: Colors.white.withOpacity(0.2),
              width: double.infinity,
              height: 300,
              child: AnimatedBox(
                animatedController: _controller,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  onPressed: () => _controller.forward(),
                  child: Text('Forward'),
                ),
                RaisedButton(
                  onPressed: () => _controller.reverse(),
                  child: Text('Reverse'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedBox extends StatelessWidget {
  AnimatedBox({Key key, this.animatedController})
      : rotate = Tween<double>(
          begin: 0.0,
          end: 3.141 * 2,
        ).animate(CurvedAnimation(
            parent: animatedController,
            curve: Interval(
              0.1,
              0.3,
              curve: Curves.ease,
            ))),
        animateMovement = EdgeInsetsTween(
          begin: EdgeInsets.only(bottom: 0.0, left: 0.0),
          end: EdgeInsets.only(top: 100.0, left: 10.0),
        ).animate(
          CurvedAnimation(
            parent: animatedController,
            curve: Interval(
              0.2,
              0.4,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        animateWidth = Tween<double>(
          begin: 50.0,
          end: 200.0,
        ).animate(
          CurvedAnimation(
            parent: animatedController,
            curve: Interval(
              0.3,
              0.6,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        animateHeight = Tween<double>(
          begin: 50.0,
          end: 200.0,
        ).animate(
          CurvedAnimation(
            parent: animatedController,
            curve: Interval(
              0.4,
              0.6,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        animateRadius = BorderRadiusTween(
          begin: BorderRadius.circular(0.0),
          end: BorderRadius.circular(50.0),
        ).animate(
          CurvedAnimation(
            parent: animatedController,
            curve: Interval(
              0.1,
              0.5,
              curve: Curves.ease,
            ),
          ),
        ),
        animateColor = ColorTween(
          begin: Colors.yellow,
          end: Colors.orange,
        ).animate(CurvedAnimation(
            parent: animatedController,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.linear,
            ))),
        super(key: key);

  final Animation<double> animatedController;
  final Animation<double> animateWidth;
  final Animation<double> animateHeight;
  final Animation<EdgeInsets> animateMovement;
  final Animation<BorderRadius> animateRadius;
  final Animation<Color> animateColor;
  final Animation<double> rotate;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animatedController,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: [
            Positioned(
              left: animateHeight.value,
              child: new Container(
                alignment: Alignment.center,
                padding: animateMovement.value,
                transform: Matrix4.identity()..rotateZ(rotate.value),
                child: Container(
                  width: animateWidth.value,
                  height: animateHeight.value,
                  decoration: BoxDecoration(
                    color: animateColor.value,
                    borderRadius: animateRadius.value,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
