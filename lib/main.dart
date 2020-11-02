import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

enum CurrentAnimationState { CLOSED, OPENING, OPEN, CLOSING }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animatedController;
  CurrentAnimationState _state;

  @override
  void initState() {
    _state = CurrentAnimationState.CLOSED;
    _animatedController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = CurrentAnimationState.OPENING;
            break;
          case AnimationStatus.completed:
            _state = CurrentAnimationState.OPEN;
            break;
          case AnimationStatus.reverse:
            _state = CurrentAnimationState.CLOSING;
            break;
          case AnimationStatus.dismissed:
            _state = CurrentAnimationState.CLOSED;
            break;
        }
      });
    super.initState();
  }

  void toggle() {
    if (_state == CurrentAnimationState.CLOSED) {
      _animatedController.forward();
      _state = CurrentAnimationState.OPENING;
    } else if (_state == CurrentAnimationState.OPEN) {
      _animatedController.reverse();
      _state = CurrentAnimationState.CLOSING;
    } else {
      _animatedController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.ac_unit), onPressed: toggle )
        ],
        title: Text("Animate Toggle"),
      ),
      body: Stack(
        children: [
          Center(
            child: RaisedButton(
              onPressed: () {
                toggle();
              },
              child: Text("Toggle"),
            ),
          ),

          // translation:  METHOD ONE

          Align(
              alignment: Alignment.centerRight,
              child: AnimatedBuilder(
                animation: _animatedController,
                builder: (context, child) {
                  print(_animatedController.value);
                  return FractionalTranslation(
                    translation: Offset(1.0 - _animatedController.value, 0.0),
                    child: child,
                  );
                },
                child: Container(
                  width: 130,
                  height: double.infinity,
                  color: Colors.orange,
                  child: buildColumn(),
                ),
              )),

          //  METHOD TWO

          Align(
            alignment: Alignment.centerRight,
            child: AnimatedBuilder(
              animation: _animatedController,
              builder: (context, child) {
                print(_animatedController.value);
                return Transform.translate(
                  offset: Offset(_animatedController.value * 150, 0.0),
                  child: child,
                );
              },
              child: Container(
                width: 130,
                color: Colors.orange,
                child: buildColumn(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BuildListButtons(
          icon: Icons.settings,
          txt: "Settings",
          fun: () => _animatedController.reverse(),
        ),
        BuildListButtons(
          icon: Icons.supervised_user_circle,
          txt: "Friends",
          fun: () => _animatedController.reverse(),
        ),
        BuildListButtons(
          icon: Icons.folder,
          txt: "Directory",
          fun: () => _animatedController.reverse(),
        ),
        BuildListButtons(
          icon: Icons.security,
          txt: "Security",
          fun: () => _animatedController.reverse(),
        ),
        BuildListButtons(
          icon: Icons.notifications,
          txt: "Notifications",
          fun: () => _animatedController.reverse(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animatedController.dispose();
    super.dispose();
  }
}

class BuildListButtons extends StatelessWidget {
  const BuildListButtons({
    Key key,
    this.icon,
    this.txt,
    this.fun,
  }) : super(key: key);

  final IconData icon;
  final String txt;
  final VoidCallback fun;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            txt,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
    );
  }
}
