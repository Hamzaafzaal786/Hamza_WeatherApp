import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedWeatherCard extends StatelessWidget {
  final Widget child;
  final int index;

  const AnimatedWeatherCard({
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}