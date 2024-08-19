import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/mainscreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    // Start the animation
    _controller.repeat(reverse: true);
    // Start the Timer to navigate or perform an action after 5 seconds
    Timer(const Duration(seconds: 5), () {
Navigator.push(context, MaterialPageRoute(builder: (context)=>const Mainscreen()));
_controller.stop(); // Optionally stop the animation
      // Navigate to another screen or perform any action
    });
  }
  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo.withBlue(53).withGreen(13).withRed(8),
        child: Center(
          // Use AnimatedBuilder to animate the Icon
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 35,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
