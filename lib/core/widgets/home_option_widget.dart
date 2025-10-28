import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {

  const GradientBorderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          // Background gradient
          gradient: const RadialGradient(
            colors: [
              Color(0xFFA5EFFF), // Light cyan
              Color(0xFF6EBFF4), // Mid blue (22.4%)
              Color(0xFF4690D4), // Deep blue
            ],
            radius: 1.0,
            center: Alignment.center,
          ),

          // Border with gradient
          border: Border.all(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.transparent, // needed for ShaderMask
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const RadialGradient(
              colors: [
                Color(0xFF98F9FF), // Cyan glow
                Color(0xFFFFFFFF), // White fade
                Color(0xFFEABFFF), // Light purple
                Color(0xFF8726B7), // Deep purple
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
              radius: 1.2,
            ).createShader(bounds);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1,
                color: Colors.white, // Shader will override this
              ),
            ),
          ),
        ),
      ),
    );
  }
}
