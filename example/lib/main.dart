import 'dart:math' as math show sin, pi;

import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_progress_button Example'),
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('type=Raised',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                Text('type=Flat',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                Text('type=Outline',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Text('List normal button:'),
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ProgressButton(
                defaultWidget: const Text('btn 1'),
                width: 114,
                onPressed: () {},
              ),
              ProgressButton(
                defaultWidget: const Text('btn 2'),
                width: 114,
                type: ProgressButtonType.Flat,
                onPressed: () {},
              ),
              ProgressButton(
                defaultWidget: const Text('btn 3'),
                width: 114,
                type: ProgressButtonType.Outline,
                onPressed: () {},
              ),
            ],
          ),
          // ... (rest of the code remains similar)
        ],
      ),
    );
  }
}

class ThreeSizeDot extends StatefulWidget {
  const ThreeSizeDot({
    Key? key,
    this.shape = BoxShape.circle,
    this.duration = const Duration(milliseconds: 1000),
    this.size = 8.0,
    this.color1,
    this.color2,
    this.color3,
    this.padding = const EdgeInsets.all(2),
  }) : super(key: key);

  final BoxShape shape;
  final Duration duration;
  final double size;
  final Color? color1;
  final Color? color2;
  final Color? color3;
  final EdgeInsetsGeometry padding;

  @override
  _ThreeSizeDotState createState() => _ThreeSizeDotState();
}

class _ThreeSizeDotState extends State<ThreeSizeDot>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    animation1 = DelayTween(begin: 0.0, end: 1.0, delay: 0.0)
        .animate(animationController);
    animation2 = DelayTween(begin: 0.0, end: 1.0, delay: 0.2)
        .animate(animationController);
    animation3 = DelayTween(begin: 0.0, end: 1.0, delay: 0.4)
        .animate(animationController);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ScaleTransition(
          scale: animation1,
          child: Padding(
            padding: widget.padding,
            child: Dot(
              shape: widget.shape,
              size: widget.size,
              color: widget.color1 ?? Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        ScaleTransition(
          scale: animation2,
          child: Padding(
            padding: widget.padding,
            child: Dot(
              shape: widget.shape,
              size: widget.size,
              color: widget.color2 ?? Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        ScaleTransition(
          scale: animation3,
          child: Padding(
            padding: widget.padding,
            child: Dot(
              shape: widget.shape,
              size: widget.size,
              color: widget.color3 ?? Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
