import 'dart:async';

import 'package:flutter/material.dart';

class MultipleSmallBoxScreen extends StatelessWidget {
  const MultipleSmallBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int _interval = 30;

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Box(delayed: _interval * 24),
              Box(delayed: _interval * 23),
              Box(delayed: _interval * 22),
              Box(delayed: _interval * 21),
              Box(delayed: _interval * 20),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Box(delayed: _interval * 15),
              Box(delayed: _interval * 16),
              Box(delayed: _interval * 17),
              Box(delayed: _interval * 18),
              Box(delayed: _interval * 19),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Box(delayed: _interval * 14),
              Box(delayed: _interval * 13),
              Box(delayed: _interval * 12),
              Box(delayed: _interval * 11),
              Box(delayed: _interval * 10),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Box(delayed: _interval * 5),
              Box(delayed: _interval * 6),
              Box(delayed: _interval * 7),
              Box(delayed: _interval * 8),
              Box(delayed: _interval * 9),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Box(delayed: _interval * 4),
              Box(delayed: _interval * 3),
              Box(delayed: _interval * 2),
              Box(delayed: _interval),
              Box(delayed: 0),
            ],
          )
        ],
      ),
    );
  }
}

class Box extends StatefulWidget {
  const Box({
    super.key,
    required int delayed,
  }) : _delayed = delayed;

  final int _delayed;

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
    reverseDuration: const Duration(milliseconds: 300),
  );

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: const BoxDecoration(
      color: Colors.black,
    ),
    end: BoxDecoration(
      color: const Color(0xFFE80000),
      borderRadius: BorderRadius.circular(5),
    ),
  ).animate(_curve);

  late final Animation<double> _scale = Tween(
    begin: 0.5,
    end: 1.0,
  ).animate(_curve);

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: const Interval(
      0.5,
      0.75,
      curve: Curves.bounceOut,
    ),
    reverseCurve: const Interval(
      0.0,
      0.25,
      curve: Curves.bounceIn,
    ),
  );

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: widget._delayed), () {
      _animationController.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: DecoratedBoxTransition(
        decoration: _decoration,
        child: const SizedBox(
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
