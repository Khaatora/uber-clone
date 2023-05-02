import 'package:equatable/equatable.dart';
import 'package:uber_own/core/utils/enums/sign_in_method.dart';
import 'package:uber_own/core/utils/enums/verification_enums.dart';

class MyUser extends Equatable {
  final String? phoneNumber;
  final VerificationState verificationState;
  final String? verificationCode;
  final String? email;
  final SignInMethod method;

  const MyUser([
    this.phoneNumber = "unknown",
    this.verificationState = VerificationState.init,
    this.verificationCode = '',
    this.email = 'unknown',
    this.method = SignInMethod.phoneNumber,
  ]);

  @override
  List<Object?> get props => [
        phoneNumber,
        verificationState,
        email,
        method,
      ];
}
