import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uber_own/core/errors/exceptions/exceptions.dart';
import 'package:uber_own/core/global/localization.dart';
import 'package:uber_own/core/utils/enums/sign_in_method.dart';
import 'package:uber_own/core/utils/enums/verification_enums.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/usecase/base_usecase.dart';
import '../models/my_user_model.dart';

abstract class UserDataSource {
  Future<void> getPhoneNumberCode(PhoneNumberDetailsParams params);

  Future<MyUserModel> verifyOTP(PhoneNumberDetailsParams params);

  Future<MyUserModel> googleSignIn();

  Future<MyUserModel> facebookSignIn();
}

class UserRemoteDataSource extends UserDataSource {
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;

  @override
  Future<void> getPhoneNumberCode(PhoneNumberDetailsParams params) async {
    final String phoneNumber = params.phoneNumber;
    await _firebaseAuthInstance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 40),
        verificationCompleted: (PhoneAuthCredential credential) async {
          //auto completes verification
          await _firebaseAuthInstance.signInWithCredential(credential);
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
              throw const GenericException(
                  EnglishLocalization.GenericFirebaseErrorMessage);
          }
        },
        codeSent: params.codeSent!,
        codeAutoRetrievalTimeout: params.codeAutoRetrievalTimeout!);
  }

  @override
  Future<MyUserModel> verifyOTP(PhoneNumberDetailsParams params) async {
    try {
      var credentials = await _firebaseAuthInstance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: params.verificationId, smsCode: params.smsCode));
      MyUserModel user;
      credentials.user == null
          ? throw const SignInFailedException()
          : user = MyUserModel(
              credentials.user!.phoneNumber, VerificationState.caching);
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
          throw const GenericException(
              EnglishLocalization.GenericFirebaseErrorMessage);
      }
    }
  }

  @override
  Future<MyUserModel> googleSignIn() async {
    try {
      final GoogleSignInAccount? gUser = await sl<GoogleSignIn>().signIn();
      if (gUser != null) {
        final GoogleSignInAuthentication gAuth = await gUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );
        final UserCredential userCredential =
            await _firebaseAuthInstance.signInWithCredential(credential);
        final user =
            MyUserModel.fromCredential(userCredential, SignInMethod.google);
        return user;
      }
      throw const SignInFailedException();
    } on FirebaseAuthException catch (e) {
      switch (e.message) {
        case "wrong-password":
          throw const SignInFailedException();
        default:
          throw const GenericException();
      }

      //**account-exists-with-different-credential**:
      // Thrown if there already exists an account with the email address asserted by the credential. Resolve this by calling fetchSignInMethodsForEmail and then asking the user to sign in using one of the returned providers. Once the user is signed in, the original credential can be linked to the user with linkWithCredential.
      // **invalid-credential**:
      // Thrown if the credential is malformed or has expired.
      // **operation-not-allowed**:
      // Thrown if the type of account corresponding to the credential is not enabled. Enable the account type in the Firebase Console, under the Auth tab.
      // **user-disabled**:
      // Thrown if the user corresponding to the given credential has been disabled.
      // **user-not-found**:
      // Thrown if signing in with a credential from EmailAuthProvider.credential and there is no user corresponding to the given email.
      // **wrong-password**:
      // Thrown if signing in with a credential from EmailAuthProvider.credential and the password is invalid for the given email, or if the account corresponding to the email does not have a password set.
      // **invalid-verification-code**:
      // Thrown if the credential is a PhoneAuthProvider.credential and the verification code of the credential is not valid.
      // **invalid-verification-id**:
      // Thrown if the credential is a PhoneAuthProvider.credential and the verification ID of the credential is not valid.id.
    }
  }

  @override
  Future<MyUserModel> facebookSignIn() async {
    try {
      LoginResult result = await sl<FacebookAuth>().login();
      final accessToken = result.accessToken?.token;
      switch (result.status) {
        case LoginStatus.success:
          final credential = FacebookAuthProvider.credential(
            accessToken!,
          );
          final UserCredential userCredential =
              await _firebaseAuthInstance.signInWithCredential(credential);
          final user =
              MyUserModel.fromCredential(userCredential, SignInMethod.facebook);
          return user;
        case LoginStatus.cancelled:
        case LoginStatus.failed:
        //TODO: check this case incase it does errors
        case LoginStatus.operationInProgress:
          throw const SignInFailedException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.message) {
        case "wrong-password":
          throw const SignInFailedException();
        case "invalid-credential":
          throw const InvalidCredentialsExceptions();
        default:
          throw const GenericException();
      }
    }
  }
}
