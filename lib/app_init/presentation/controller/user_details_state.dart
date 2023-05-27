part of 'user_details_bloc.dart';

class UserDetailsState extends Equatable {

  final VerificationState verificationState;
  final SignInMethod method;
  final String? phoneNum;
  final String? smsCode;
  final String? message;

  const UserDetailsState(
      {this.verificationState = VerificationState.init,
        this.method = SignInMethod.phoneNumber,
      this.smsCode,
      this.phoneNum,
      this.message =''});



  UserDetailsState copyWith({
    VerificationState? verificationState,
    SignInMethod? method,
    String? phoneNum,
    String? smsCode,
    String? message,
  }){
    return UserDetailsState(
      phoneNum: phoneNum ?? this.phoneNum,
      smsCode: smsCode ?? this.smsCode,
      verificationState: verificationState ?? this.verificationState,
      method: method ?? this.method,
      message: message
    );
  }

  @override
  List<Object?> get props => [
    verificationState,
    method,
    phoneNum,
    smsCode,
    message,
  ];

  @override
  String toString() {
    return "Verification State: $verificationState, Sign in Method: $method, Phone Number: $phoneNum, Message: $message";
  }
}
