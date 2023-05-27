import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber_own/core/utils/enums/sign_in_method.dart';
import 'package:uber_own/app_init/domain/entity/user.dart';

import '../../../core/utils/enums/verification_enums.dart';

class MyUserModel extends MyUser {
  const MyUserModel([
    super.phoneNumber = "unknown",
    super.verificationState = VerificationState.init,
    super.verificationCode = '',
    super.email = '',
    super.method = SignInMethod.phoneNumber,
  ]);

  factory MyUserModel.fromCredential(UserCredential credential, SignInMethod method){
    return MyUserModel(
      "unknown",
      VerificationState.awaitingAgreemnt,
      '',
      credential.user?.email,
      method,
    );
  }
}
