import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_own/core/constants/routes.dart';

import '../../../../core/services/services_locator.dart';
import '../../../domain/entity/user_shared_prefs_data.dart';
import '../../controller/init_app_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InitAppBloc>()..add(InitAppEvent()),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocListener<InitAppBloc, InitAppState>(
            listener: (context, state) {
              final UserSharedPreferencesData? prefsData = state.userSharedPreferencesData;
              if(prefsData != null) {
                if(prefsData.showGreeting){
                  delayedPushReplacementNamedWithRoute(context, route: Routes.greeting, delayedSeconds: 1);
                }else{
                  //TODO: change duration to 3 seconds
                  if(prefsData.addedPhone){
                    delayedPushReplacementNamedWithRoute(context, route: Routes.home, delayedSeconds: 1);
                  }
                  else{
                    delayedPushReplacementNamedWithRoute(context, route: Routes.getStarted, delayedSeconds: 1);
                  }
                }
              }else{
                delayedPushReplacementNamedWithRoute(context, route: Routes.greeting, delayedSeconds: 1);
              }
            },
            child: Center(
          child: Image.asset("assets/images/splash_img.png", width: 400),
          )
          )
      ),
    );
  }

  void delayedPushReplacementNamedWithRoute(BuildContext context,{required String route, required int delayedSeconds,}){
    Future.delayed(Duration(seconds: delayedSeconds), () =>
        Navigator.pushNamedAndRemoveUntil(context, route, (route) => false),);
  }
}
