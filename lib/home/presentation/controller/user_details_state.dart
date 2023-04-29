part of 'user_details_bloc.dart';

class UserDetailsState extends Equatable {

  final VerificationState verificationState;
  final String? phoneNum;
  final String? smsCode;
  final String? message;

  const UserDetailsState(
      {this.verificationState = VerificationState.init,
      this.smsCode,
      this.phoneNum,
      this.message =''});



  UserDetailsState copyWith({
    VerificationState? verificationState,
    String? phoneNum,
    String? smsCode,
    String? message,
  }){
    return UserDetailsState(
      phoneNum: phoneNum ?? this.phoneNum,
      smsCode: smsCode ?? this.smsCode,
      verificationState: verificationState ?? this.verificationState,
      message: message
    );
  }

  @override
  List<Object?> get props => [
    verificationState,
    phoneNum,
    smsCode,
    message,
  ];

  @override
  String toString() {
    return "Verification State: $verificationState, Phone Number: $phoneNum, Message: $message";
  }
}
