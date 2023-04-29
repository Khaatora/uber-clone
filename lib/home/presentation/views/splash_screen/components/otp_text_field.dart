import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/global/color_utils.dart';
import '../../../controller/user_details_bloc.dart';

class OTPTextField extends StatefulWidget {
   const OTPTextField({Key? key}) : super(key: key);


  @override
  State<OTPTextField> createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  String _comingSms = 'Unknown';
  late TextEditingController _codeController;


  @override
  void initState() {
    _codeController = TextEditingController();
    super.initState();
    initSmsListener();
  }

  @override
  void dispose() {
    _codeController.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: Theme.of(context).textTheme.bodySmall,
      autoDisposeControllers: false,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 50,
          fieldWidth: 40,
          inactiveFillColor: Colors.white,
          inactiveColor: ColorUtils.grey,
          selectedColor: ColorUtils.grey,
          selectedFillColor: Colors.white,
          activeFillColor: Colors.white,
          activeColor: ColorUtils.grey
      ),
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      controller: _codeController,
      keyboardType: TextInputType.number,
      boxShadows: const [
        BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
      onCompleted: (code) async{
        //do something or move to next screen when code complete
        var bloc = UserDetailsBloc.get(context);
        log("onComplted ${bloc.state.phoneNum!}, verification ID: ${await bloc.getVerificationIdStreamController.stream.last}");
        bloc.add(SendVerificationInfoEvent(bloc.state.phoneNum!, code));
      },
      onChanged: (value) {
        log(value);
        setState(() {
          log(value);
        });
      },
    );
  }

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms!;
      log("====>Message: $_comingSms");
      log(_comingSms[32]);
      _codeController.text = _comingSms[0] + _comingSms[1] + _comingSms[2] + _comingSms[3]
          + _comingSms[4] + _comingSms[5]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }
}
