import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_own/core/constants/routes.dart';
import 'package:uber_own/core/global/localization.dart';
import 'package:uber_own/core/global/size_config.dart';
import 'package:uber_own/home/presentation/views/splash_screen/components/primary_elevated_button.dart';

class GreetingScreen extends StatelessWidget {
  const GreetingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: HexColor("276EF1"),
      body: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.statusBarHeight+16,
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Image.asset("assets/images/onboard_uber_img.png")),
            Expanded(
              flex: 2,
              child: Image.asset("assets/images/onboard_img.png"),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  EnglishLocalization.movieWithSafety,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
            PrimaryElevatedButton(onPressed: (){
              Navigator.pushReplacementNamed(context, Routes.getStarted);
            }, text: EnglishLocalization.getStarted, suffixIcon: Icons.arrow_forward)
          ],
        ),
      ),
    );
  }

  Future<void> getSharedPrefInstance() async {
    await SharedPreferences.getInstance();
  }
}
