part of 'user_details_bloc.dart';

abstract class BaseUserDetailsEvent extends Equatable {
  const BaseUserDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetUsersDetailsEvent extends BaseUserDetailsEvent {

}

class VerifyPhoneNumberEvent extends BaseUserDetailsEvent {
  final String phoneNum;

  const VerifyPhoneNumberEvent(this.phoneNum);

  @override
  List<Object?> get props => [
        phoneNum,
      ];
}

class SendVerificationInfoEvent extends BaseUserDetailsEvent {
  final String phoneNum;
  final String smsCode;

  const SendVerificationInfoEvent(this.phoneNum, this.smsCode);

  @override
  List<Object?> get props => [
        phoneNum,
        smsCode,
      ];
}

class ReturnToFirstScreenEvent extends BaseUserDetailsEvent{

}

class CacheDataEvent extends BaseUserDetailsEvent{
  final String phoneNum;

  const CacheDataEvent(this.phoneNum);

  @override
  List<Object?> get props => [
    phoneNum,
  ];
}
