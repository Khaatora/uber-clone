import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber_own/core/errors/exceptions/exceptions.dart';
import 'package:uber_own/core/global/localization.dart';
import 'package:uber_own/core/utils/enums/verification_enums.dart';
import 'package:uber_own/home/presentation/controller/user_details_bloc.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/usecase/base_usecase.dart';
import '../models/MyUserModel.dart';

abstract class UserDataSource {
  Future<void> getPhoneNumberCode(PhoneNumberDetailsParams params);

  Future<MyUserModel> verifyOTP(PhoneNumberDetailsParams params);
}

class UserRemoteDataSource extends UserDataSource {
  FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

  @override
  Future<void> getPhoneNumberCode(PhoneNumberDetailsParams params) async {
    final String phoneNumber = params.phoneNumber;
    await firebaseAuthInstance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 40),
      verificationCompleted: (PhoneAuthCredential credential) async {
        //auto completes verification
        await firebaseAuthInstance.signInWithCredential(credential);
        return;
      },
      verificationFailed: (FirebaseAuthException e) {
        log(e.toString());
        switch (e.code) {
          case "network-request-failed":
            throw const InternetDisconnectedException();
          case "no-auth-event":
            throw const InternalException();
          default:
            log(e.toString());
            throw const PhoneVerificationException(
                EnglishLocalization.GenericFirebaseErrorMessage);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        //code is sent
        sl<UserDetailsBloc>().getVerificationIdStreamController.add(verificationId);
        log(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //retrieval timeout
        sl<UserDetailsBloc>().getVerificationIdStreamController.add(verificationId);
        log(verificationId);
      },
    );
  }

  @override
  Future<MyUserModel> verifyOTP(PhoneNumberDetailsParams params) async {
    try {
      var credentials = await firebaseAuthInstance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: params.verificationId, smsCode: params.smsCode));
      MyUserModel user;
      credentials.user == null
          ? throw const SignInFailedException()
          : user = MyUserModel(
              credentials.user!.phoneNumber, VerificationState.completed);
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-verification-code":
          throw const InvalidCodeException();
        // case "invalid-verification-id":
        case "network-request-failed":
          throw const InternetDisconnectedException();
        case "no-auth-event":
          throw const InternalException();
        case "invalid-phone-number":
          throw const InvalidPhoneNumberException();
        default:
          log(e.toString());
          throw const PhoneVerificationException(
              EnglishLocalization.GenericFirebaseErrorMessage);
      }
    }
  }
}
