import 'package:flutter/material.dart';
import 'package:uber_own/core/constants/routes.dart';
import 'package:uber_own/core/global/theme.dart';
import 'package:uber_own/core/services/services_locator.dart';
import 'package:uber_own/app_init/presentation/views/get_started_screen.dart';
import 'package:uber_own/app_init/presentation/views/greeting_screen.dart';
import 'package:uber_own/app_init/presentation/views/home_screen.dart';
import 'package:uber_own/app_init/presentation/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ServicesLocator().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone',
      initialRoute: Routes.splash,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routes: {
        Routes.splash : (context) => const SplashScreen(),
        Routes.greeting : (context) => const GreetingScreen(),
        Routes.getStarted : (context) => const GetStartedScreen(),
        Routes.home : (context) => const HomeScreen(),
      },
    );
  }
}

