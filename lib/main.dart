import 'package:flutter/material.dart';
import 'package:uber_own/core/constants/routes.dart';
import 'package:uber_own/home/presentation/views/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone',
      routes: {
        Routes.splash : (context) => const SplashScreen(),
        Routes.home : (context) => const SplashScreen(),
      },
    );
  }
}

