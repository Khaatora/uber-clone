import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber_own/core/constants/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    
    super.initState();
    //TODO: change duration to 3 seconds
    Future.delayed(const Duration(seconds: 1), () => Navigator.pushReplacementNamed(context, Routes.home),);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
      child: Image.asset("assets/images/splash_img.png", width: 400),
    )
    );
  }
}
