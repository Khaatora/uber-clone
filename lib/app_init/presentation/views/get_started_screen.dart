import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:uber_own/app_init/presentation/controller/user_details_bloc.dart';
import 'package:uber_own/app_init/presentation/views/splash_screen/components/otp_text_field.dart';
import 'package:uber_own/app_init/presentation/views/splash_screen/components/primary_elevated_button.dart';
import 'package:uber_own/app_init/presentation/views/splash_screen/components/secondary_elevated_button.dart';
import 'package:uber_own/core/constants/firebase_constants.dart';
import 'package:uber_own/core/constants/routes.dart';
import 'package:uber_own/core/global/localization.dart';
import 'package:uber_own/core/utils/enums/verification_enums.dart';
import 'package:uber_own/core/utils/general_utils.dart';

import '../../../core/global/size_config.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/enums/sign_in_method.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late TextEditingController _phoneNumberController;
  late PageController _pageController;
  late bool enabled;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late final TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _pageController = PageController();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _onTap;
    enabled = true;
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _pageController.dispose();
    sl<UserDetailsBloc>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => sl<UserDetailsBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<UserDetailsBloc, UserDetailsState>(
            listener: (listenerContext, state) {
              log("State : ${state.runtimeType} with values : ${state.toString()}");
              switch (state.verificationState) {
                case VerificationState.init:
                  break;
                case VerificationState.caching:
                  UserDetailsBloc.get(listenerContext)
                      .add(CacheDataEvent(state.phoneNum ?? "unknown"));
                  break;
                case VerificationState.completed:
                  Navigator.pushReplacementNamed(listenerContext, Routes.home);
                  break;
                case VerificationState.awaitingUserInput:
                  context.unFocusKeyboardFromScope();
                  if (state.method == SignInMethod.phoneNumber) {
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn);
                  }
                  break;
                case VerificationState.awaitingVerificationId:
                  break;
                case VerificationState.failed:
                case VerificationState.verifying:
                case VerificationState.error:
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message!)));
                  });
                  break;
                case VerificationState.awaitingAgreemnt:
                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn);
                  break;
              }
            },
            child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(EnglishLocalization.enterYourMobileNumber),
                            const SizedBox(
                              height: 16,
                            ),
                            InternationalPhoneNumberInput(
                              onInputChanged: (value) {
                                final int currentOffset =
                                    _phoneNumberController.selection.base.offset;
                                _phoneNumberController.value = TextEditingValue(
                                    text: value.phoneNumber ?? '',
                                    selection: TextSelection.fromPosition(
                                        TextPosition(offset: currentOffset)));
                              },
                              initialValue: PhoneNumber(isoCode: "EG"),
                              countries: FirebaseConstants.supportedCountryCodes,
                              inputBorder: const OutlineInputBorder(),
                              selectorConfig: const SelectorConfig(
                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            BlocBuilder<UserDetailsBloc, UserDetailsState>(
                              builder: (context, UserDetailsState state) {
                                switch (state.verificationState) {
                                  case VerificationState.init:
                                  case VerificationState.completed:
                                  case VerificationState.failed:
                                  case VerificationState.error:
                                  case VerificationState.awaitingUserInput:
                                    return PrimaryElevatedButton(
                                      onPressed: () {
                                        log(_phoneNumberController.text);
                                        _validateAndSendCode(context);
                                      },
                                      text: EnglishLocalization.next,
                                    );
                                  case VerificationState.awaitingVerificationId:
                                  case VerificationState.verifying:
                                  case VerificationState.awaitingAgreemnt:
                                  case VerificationState.caching:
                                    return const Center(
                                        child:
                                            CircularProgressIndicator.adaptive());
                                }
                              },
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            const Text(EnglishLocalization.loginMainText),
                            const SizedBox(
                              height: 32,
                            ),
                            Row(
                              children: const [
                                Expanded(
                                    child: Divider(
                                  thickness: 2,
                                  endIndent: 8,
                                  color: Colors.black,
                                )),
                                Text(EnglishLocalization.or),
                                Expanded(
                                    child: Divider(
                                  thickness: 2,
                                  indent: 8,
                                  color: Colors.black,
                                )),
                              ],
                            ),
                            BlocBuilder<UserDetailsBloc, UserDetailsState>(
                              builder: (context, UserDetailsState state) {
                                switch (state.verificationState) {
                                  case VerificationState.init:
                                  case VerificationState.completed:
                                  case VerificationState.failed:
                                  case VerificationState.error:
                                    enabled = true;
                                    break;
                                  case VerificationState.awaitingUserInput:
                                  case VerificationState.awaitingVerificationId:
                                  case VerificationState.verifying:
                                  case VerificationState.caching:
                                  case VerificationState.awaitingAgreemnt:
                                    enabled = false;
                                    break;
                                }
                                return SecondaryElevatedButton(
                                  onPressed: () {
                                    UserDetailsBloc.get(context)
                                        .add(SignInWithFacebookEvent());
                                    enabled = false;
                                  },
                                  text: EnglishLocalization.continueWithFacebook,
                                  isEnabled: enabled,
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                          backgroundColor:
                                              const MaterialStatePropertyAll<
                                                  Color>(Colors.white),
                                          foregroundColor:
                                              const MaterialStatePropertyAll<
                                                  Color>(Colors.black),
                                          side: const MaterialStatePropertyAll(
                                              BorderSide(color: Colors.black)),
                                          overlayColor:
                                              const MaterialStatePropertyAll<
                                                  Color>(Colors.black12)),
                                  prefixIcon: FontAwesomeIcons.facebook,
                                );
                              },
                            ),
                            BlocBuilder<UserDetailsBloc, UserDetailsState>(
                                builder: (context, UserDetailsState state) {
                              switch (state.verificationState) {
                                case VerificationState.init:
                                case VerificationState.completed:
                                case VerificationState.failed:
                                case VerificationState.error:
                                  enabled = true;
                                  break;
                                case VerificationState.awaitingUserInput:
                                case VerificationState.awaitingVerificationId:
                                case VerificationState.verifying:
                                case VerificationState.caching:
                                case VerificationState.awaitingAgreemnt:
                                  enabled = false;
                                  break;
                              }
                              return SecondaryElevatedButton(
                                onPressed: () {
                                  UserDetailsBloc.get(context)
                                      .add(SignInWithGoogleEvent());
                                  enabled = false;
                                },
                                isEnabled: enabled,
                                text: EnglishLocalization.continueWithGoogle,
                                style: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style
                                    ?.copyWith(
                                      backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.white),
                                      foregroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.black),
                                      side: const MaterialStatePropertyAll(
                                          BorderSide(color: Colors.black)),
                                      overlayColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.black12),
                                    ),
                                prefixIcon: FontAwesomeIcons.google,
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
                              buildWhen: (previous, current) =>
                                  current.verificationState ==
                                  VerificationState.awaitingUserInput,
                              builder: (context, state) {
                                return Text(
                                  "${EnglishLocalization.otpMainText} \n${state.phoneNum}",
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<UserDetailsBloc, UserDetailsState>(
                            buildWhen: (previous, current) =>
                                current.method == SignInMethod.phoneNumber,
                            builder: (context, state) {
                              final bool enabled;
                              switch (state.verificationState) {
                                case VerificationState.awaitingUserInput:
                                case VerificationState.error:
                                  enabled = true;
                                  break;
                                default:
                                  enabled = false;
                              }
                              return OTPTextField(
                                enabled: enabled,
                              );
                            },
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              style: Theme.of(context)
                                  .elevatedButtonTheme
                                  .style
                                  ?.copyWith(
                                      backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.black12),
                                      foregroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.black),
                                      overlayColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.black12),
                                      textStyle: MaterialStatePropertyAll(
                                          Theme.of(context).textTheme.bodySmall)),
                              child: const Text(
                                  EnglishLocalization.iDidntReceiveCode)),
                          ElevatedButton(
                              onPressed: () {},
                              style: Theme.of(context)
                                  .elevatedButtonTheme
                                  .style
                                  ?.copyWith(
                                      backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.black12),
                                      foregroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.black),
                                      overlayColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.black12),
                                      textStyle: MaterialStatePropertyAll(
                                          Theme.of(context).textTheme.bodySmall)),
                              child: const Text(
                                  EnglishLocalization.loginWithPassword)),
                          const Expanded(flex: 7, child: SizedBox()),
                          Builder(builder: (context) {
                            return IconButton(
                              onPressed: () {
                                UserDetailsBloc.get(context)
                                    .add(ReturnToFirstScreenEvent());
                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn);
                              },
                              icon: const Icon(Icons.arrow_back),
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.black12),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            "assets/images/safety_alert_img.png",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            onPressed: _exitApp,
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          EnglishLocalization.uberCommunityGuidelines,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          EnglishLocalization.safetyAndRespectForAll,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          EnglishLocalization.weAreCommited,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Center(heightFactor: 1.5, widthFactor: 1,child: Text("\u2714   ", textAlign: TextAlign.center,)),
                          Flexible(child: Align(alignment: Alignment.centerLeft,child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(EnglishLocalization.treatEveryoneWithRespect),
                          ))),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Center(heightFactor: 1.5, widthFactor: 1,child: Text("\u2714   ", textAlign: TextAlign.center,)),
                          Flexible(child: Align(alignment: Alignment.centerLeft,child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(EnglishLocalization.helpKeepOneAnotherSafe),
                          ))),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Center(heightFactor: 1.5, widthFactor: 1,child: Text("\u2714   ", textAlign: TextAlign.center,)),
                          Flexible(child: Align(alignment: Alignment.centerLeft,child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(EnglishLocalization.followTheLaw),
                          ))),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          EnglishLocalization.everyOneWhoUsesUberAppsIs,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text.rich(
                          TextSpan(
                            text: EnglishLocalization.youCanReadAboutOur,
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              TextSpan(
                                text: EnglishLocalization.communityGuidelinesHere,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: _tapGestureRecognizer,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      BlocBuilder<UserDetailsBloc, UserDetailsState>(
                        buildWhen: (previous, current) => false,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                            child: PrimaryElevatedButton(
                                onPressed: () {
                                  _cacheAgreementAndData(state.phoneNum!, context);
                                },
                                text: EnglishLocalization.iUnderstand),
                          );
                        },
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void _validateAndSendCode(BuildContext context) {

    if (_formKey1.currentState!.validate()) {
      final bloc = UserDetailsBloc.get(context);
      bloc.add(VerifyPhoneNumberEvent(_phoneNumberController.text));
    }
  }

  void _exitApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  void _cacheAgreementAndData(String phoneNum, BuildContext context) {
    UserDetailsBloc.get(context).add(CacheDataEvent(phoneNum));
  }

  void _onTap() {
    context.showCustomSnackBar("Community Guidelines Text Pressed!", const Duration(
      seconds: 1
    ));
  }
}
