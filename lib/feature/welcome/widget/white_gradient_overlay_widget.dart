import 'package:flutter/material.dart';

class WhiteGradientOverlayWidget extends StatelessWidget {
  const WhiteGradientOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromARGB(246, 255, 255, 255),
            Color.fromARGB(41, 255, 255, 255),
            Color.fromARGB(0, 0, 0, 0),
          ],
          stops: [0.0, 0.3, 0.5, 1],
        ),
      ),
    );
  }
}
