import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import '../login_screen/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: 'assets/images/logo.png',
      splashIconSize: 250,
      screenFunction: () async{
        return LoginScreen();
      },
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}
