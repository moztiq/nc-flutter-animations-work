import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  static int totalSeconds = 10;
  int progressSeconds = totalSeconds;
  bool isRunning = false;
  late Timer timer;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: totalSeconds),
    lowerBound: 0.005,
    upperBound: 2.0,
  );

  void onTick(Timer timer) {
    setState(() {
      if (progressSeconds == 0) {
        timer.cancel();
        isRunning = false;
        _animationController.reset();
        progressSeconds = totalSeconds;
      } else {
        progressSeconds = progressSeconds - 1;
      }
    });
  }

  void _onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
    _animationController.forward();
  }

  void _onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
    _animationController.stop();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    var digitMinutes = twoDigits(duration.inMinutes.remainder(60));
    var digitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$digitMinutes:$digitSeconds";
  }

  void _reset() {
    setState(() {
      timer.cancel();
      isRunning = false;
      _animationController.reset();
      progressSeconds = totalSeconds;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Pomodoro Animation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (BuildContext context, Widget? child) {
                      return CustomPaint(
                        painter: CirclePainter(
                          progress: _animationController.value,
                        ),
                        size: const Size(300, 300),
                      );
                    },
                  ),
                  Text(
                    format(progressSeconds),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _reset,
                    color: Colors.grey.shade500,
                    icon: const Icon(Icons.refresh),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.shade500,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: isRunning ? _onPausePressed : _onStartPressed,
                    color: Colors.grey.shade500,
                    icon: Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _reset,
                    color: Colors.grey.shade500,
                    icon: const Icon(
                      Icons.square,
                      size: 16,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final grayCircle = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      grayCircle,
    );

    final redArc = Rect.fromCircle(center: center, radius: size.width / 2);
    final redArcPaint = Paint()
      ..color = Colors.red.shade500
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(redArc, -0.5 * pi, progress * pi, false, redArcPaint);
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
