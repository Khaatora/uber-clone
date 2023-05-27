part of 'init_app_bloc.dart';

abstract class BaseAppEvent extends Equatable {
  const BaseAppEvent();
  @override
  List<Object?> get props => [];
}

class InitAppEvent extends BaseAppEvent{

}

class GetSharedPrefsDataEvent extends BaseAppEvent{

}

class VerifyPhoneNumberEvent extends BaseAppEvent{

}