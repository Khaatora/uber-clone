import 'package:equatable/equatable.dart';
import 'package:uber_own/core/utils/enums/verification_enums.dart';

class MyUser extends Equatable {
  final String? phoneNumber;
  final VerificationState verificationState;
  final String? verificationCode;
  final String? email;



  const MyUser(this.phoneNumber, this.verificationState, [this.verificationCode = '', this.email = '']);

  @override
  List<Object?> get props => [
        phoneNumber,
        verificationState,

      ];
}
