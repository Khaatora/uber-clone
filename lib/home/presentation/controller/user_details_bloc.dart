import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/home/domain/usecase/send_phone_verification_code_use_case.dart';

import '../../../core/utils/enums/verification_enums.dart';
import '../../domain/usecase/add_user_shared_prefs_data_use_case.dart';
import '../../domain/usecase/verify_user_phone_use_case.dart';

part 'user_details_event.dart';

part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<BaseUserDetailsEvent, UserDetailsState> {
  final AddUserSharedPrefsDataUseCase addUserSharedPrefsDataUseCase;
  final VerifyUserPhoneUseCase verifyUserPhoneUseCase;
  final SendPhoneVerificationCodeUseCase sendPhoneVerificationCodeUseCase;

  String? _verificationId;

  String? get getVerificationId => _verificationId;

  set setVerificationId(String id) => _verificationId = id;

  UserDetailsBloc(this.addUserSharedPrefsDataUseCase,
      this.verifyUserPhoneUseCase, this.sendPhoneVerificationCodeUseCase)
      : super(const UserDetailsState()) {
    on<VerifyPhoneNumberEvent>(_verifyPhoneNumberEvent);
    on<SendVerificationInfoEvent>(_sendVerificationInfoEvent);
    on<CacheDataEvent>(_cacheDataEvent);
    on<ReturnToFirstScreenEvent>(_returnToFirstScreenEvent);
  }

  static UserDetailsBloc get(context) => BlocProvider.of(context);

  FutureOr<void> _verifyPhoneNumberEvent(
      VerifyPhoneNumberEvent event, Emitter<UserDetailsState> emit) async {
    final result = await verifyUserPhoneUseCase(PhoneNumberDetailsParams(
        event.phoneNum,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout));
    result.fold(
        (l) => emit(state.copyWith(
            verificationState: VerificationState.error,
            message: l.message)), (r) {
      log("awaiting verification id");

      emit(state.copyWith(
        phoneNum: event.phoneNum,
        verificationState: VerificationState.awaitingVerificationId,
      ));
    });
  }

  Future<FutureOr<void>> _sendVerificationInfoEvent(
      SendVerificationInfoEvent event, Emitter<UserDetailsState> emit) async {
    log(_verificationId ?? "null");
    final result = await sendPhoneVerificationCodeUseCase(
        PhoneNumberDetailsParams(event.phoneNum,
            verificationId: _verificationId!, smsCode: event.smsCode));
    result.fold(
        (l) => emit(state.copyWith(
            verificationState: VerificationState.error,
            message: l.message)), (r) {
      log("${event.runtimeType}: ${r.toString()}");
      emit(state.copyWith(
        phoneNum: r.phoneNumber,
        verificationState: VerificationState.caching,
      ));
    });
  }

  FutureOr<void> _cacheDataEvent(
      CacheDataEvent event, Emitter<UserDetailsState> emit) async {
    final result = await addUserSharedPrefsDataUseCase(
        SharedPrefsDataParams(false, true, state.phoneNum!));
    result.fold(
        (l) => emit(state.copyWith(
            verificationState: VerificationState.error, message: l.message)),
        (r) => emit(state.copyWith(
              phoneNum: state.phoneNum,
              verificationState: VerificationState.completed,
            )));
  }

  FutureOr<void> _returnToFirstScreenEvent(
      ReturnToFirstScreenEvent event, Emitter<UserDetailsState> emit) {
    emit(state.copyWith(
      message: "",
      verificationState: VerificationState.init,
      phoneNum: "",
      smsCode: "",
    ));
  }

  void dispose() {}

  void _codeSent(String verificationId, int? forceResendingToken) {
    //code is sent
    setVerificationId = verificationId;
    log("myVerificationId: $verificationId, verification ID: $verificationId");
    emit(
        state.copyWith(verificationState: VerificationState.awaitingUserInput));
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    setVerificationId = verificationId;
    log("myVerificationId: $verificationId, verification ID: $verificationId");
    emit(
        state.copyWith(verificationState: VerificationState.awaitingUserInput));
  }
}
