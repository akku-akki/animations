import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
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
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Container(
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
      : animatePadding = EdgeInsetsTween(
          begin: EdgeInsets.all(0),
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
        rotate = Tween<double>(
          begin: 0.0,
          end: math.pi * 2,
        ).animate(CurvedAnimation(
            parent: animatedController,
            curve: Interval(
              0.0,
              0.3,
              curve: Curves.ease,
            ))),
        animateWidth = Tween<double>(
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
        animateHeight = Tween<double>(
          begin: 50.0,
          end: 200.0,
        ).animate(
          CurvedAnimation(
            parent: animatedController,
            curve: Interval(
              0.4,
              0.6,
              curve: Curves.easeOutSine,
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
        animateColor = ColorTween(begin: Colors.blue, end: Colors.yellow)
            .animate(CurvedAnimation(
                parent: animatedController,
                curve: Interval(
                  0.0,
                  1.0,
                  curve: Curves.linear,
                ))),
        super(key: key);

  final AnimationController animatedController;
  final Animation<double> rotate;
  final Animation<EdgeInsets> animatePadding;
  final Animation<BorderRadius> animateRadius;
  final Animation<double> animateWidth;
  final Animation<double> animateHeight;
  final Animation<Color> animateColor;

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    return AnimatedBuilder(
      animation: animatedController,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: [
            Positioned(
              left: animateHeight.value,
              child: new Container(
                alignment: Alignment.center,
                padding: animatePadding.value,
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
