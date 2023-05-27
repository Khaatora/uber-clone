import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uber_own/app_init/data/models/my_user_model.dart';

import '../../app_init/data/models/user_shared_prefs_data_model.dart';
import '../errors/failures/failures.dart';
import '../utils/enums/sign_in_method.dart';
import '../utils/enums/verification_enums.dart';

abstract class IUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

class SharedPrefsDataParams extends UserSharedPreferenceDataModel {
  const SharedPrefsDataParams(
      [super.isFirstTime = true,
      super.addedPhone = false,
      super.phoneNumber = '']);
}

class PhoneNumberDetailsParams extends Equatable {
  final String phoneNumber;
  final String verificationId;
  final String smsCode;
  void Function(String verificationId, int? forceResendingToken)? codeSent;
  void Function(String verificationId)? codeAutoRetrievalTimeout;

  PhoneNumberDetailsParams(this.phoneNumber,
      {this.verificationId = '',
      this.smsCode = '',
      this.codeSent,
      this.codeAutoRetrievalTimeout});

  @override
  List<Object?> get props => [
        phoneNumber,
        verificationId,
        smsCode,
        codeSent,
        codeAutoRetrievalTimeout
      ];

   @override
  String toString() {
    return "codeSent: $codeSent, Timeout: $codeAutoRetrievalTimeout";
  }
}

class GoogleDetailsParams extends MyUserModel {
  const GoogleDetailsParams([
    super.phoneNumber = "unknown",
    super.verificationState = VerificationState.init,
    super.verificationCode = '',
    super.email = '',
    super.method = SignInMethod.google,
  ]);

  @override
  List<Object?> get props => [
        phoneNumber,
        verificationState,
        method,
      ];
}
