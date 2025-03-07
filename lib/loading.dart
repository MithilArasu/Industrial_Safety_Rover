import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'login.dart';
import 'package:lottie/lottie.dart';
class StartAnimation extends StatelessWidget {
  const StartAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash:SizedBox(height: 300,width: 300,child:Center(child: Lottie.asset("assets/loading.json")),
      ),
      nextScreen: LoginPage(),duration:4000,splashIconSize: 600,);
  }
}
