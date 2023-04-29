import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:uber_own/core/constants/firebase_constants.dart';
import 'package:uber_own/core/constants/routes.dart';
import 'package:uber_own/core/global/localization.dart';
import 'package:uber_own/core/utils/enums/verification_enums.dart';
import 'package:uber_own/home/presentation/controller/user_details_bloc.dart';
import 'package:uber_own/home/presentation/views/splash_screen/components/otp_text_field.dart';
import 'package:uber_own/home/presentation/views/splash_screen/components/primary_elevated_button.dart';
import 'package:uber_own/home/presentation/views/splash_screen/components/secondary_elevated_button.dart';

import '../../../core/global/size_config.dart';
import '../../../core/services/services_locator.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late TextEditingController _phoneNumberController;
  late PageController _pageController;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _pageController = PageController();
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
        body: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.statusBarHeight+16,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          child: BlocListener<UserDetailsBloc, UserDetailsState>(
            listener: (listenerContext, state) {
              log("State : ${state.runtimeType} with values : ${state.toString()}");
              switch (state.verificationState) {
                case VerificationState.init:
                  break;
                case VerificationState.completed:
                  UserDetailsBloc.get(listenerContext)
                      .add(CacheDataEvent(state.phoneNum!));
                  Navigator.pushReplacementNamed(listenerContext, Routes.home);
                  break;
                case VerificationState.awaitingUserInput:
                  _pageController.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                  break;
                case VerificationState.failed:
                case VerificationState.verifying:
                case VerificationState.resendingCode:
                case VerificationState.error:
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message!),
                  ));
              }
            },
            child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
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
                            initialValue: PhoneNumber(
                                isoCode: "EG"),
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
                                    text: EnglishLocalization.Next,
                                  );
                                case VerificationState.resendingCode:
                                case VerificationState.verifying:
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
                          SecondaryElevatedButton(
                            onPressed: () {},
                            text: EnglishLocalization.continueWithFacebook,
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
                                            Colors.black12)),
                            prefixIcon: FontAwesomeIcons.facebook,
                          ),
                          SecondaryElevatedButton(
                            onPressed: () {},
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
                                            Colors.black12)),
                            prefixIcon: FontAwesomeIcons.google,
                          )
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: BlocBuilder<UserDetailsBloc,UserDetailsState>(
                            buildWhen: (previous, current) => current.verificationState == VerificationState.awaitingUserInput,
                            builder: (context, state) {
                              return  Text(
                                "${EnglishLocalization.otpMainText} \n${state.phoneNum}",
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const OTPTextField(),
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
                            textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall)),
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
                                textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall)),
                            child: const Text(
                                EnglishLocalization.loginWithPassword)),
                        const Expanded(flex: 7,child: SizedBox()),
                        Builder(
                          builder: (context) {
                            return IconButton(onPressed: () {
                              UserDetailsBloc.get(context).add(ReturnToFirstScreenEvent());
                              _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                            }, icon: const Icon(Icons.arrow_back), style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.black12),
                            ),);
                          }
                        )
                      ],
                    ),
                  ),
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
}
