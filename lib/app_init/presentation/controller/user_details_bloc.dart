import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_own/app_init/domain/usecase/sign_in_wtih_facebook_use_case.dart';
import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/core/utils/enums/sign_in_method.dart';
import 'package:uber_own/app_init/domain/usecase/send_phone_verification_code_use_case.dart';
import 'package:uber_own/app_init/domain/usecase/sign_in_with_google_use_case.dart';

import '../../../core/utils/enums/verification_enums.dart';
import '../../domain/usecase/add_user_shared_prefs_data_use_case.dart';
import '../../domain/usecase/verify_user_phone_use_case.dart';

part 'user_details_event.dart';

part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<BaseUserDetailsEvent, UserDetailsState> {
  final AddUserSharedPrefsDataUseCase addUserSharedPrefsDataUseCase;
  final VerifyUserPhoneUseCase verifyUserPhoneUseCase;
  final SendPhoneVerificationCodeUseCase sendPhoneVerificationCodeUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;

  String? _verificationId;

  String? get getVerificationId => _verificationId;

  set setVerificationId(String id) => _verificationId = id;

  UserDetailsBloc(
      this.addUserSharedPrefsDataUseCase,
      this.verifyUserPhoneUseCase,
      this.sendPhoneVerificationCodeUseCase,
      this.signInWithGoogleUseCase,
      this.signInWithFacebookUseCase,)
      : super(const UserDetailsState()) {
    on<VerifyPhoneNumberEvent>(_verifyPhoneNumberEvent);
    on<SendVerificationInfoEvent>(_sendVerificationInfoEvent);
    on<CacheDataEvent>(_cacheDataEvent);
    on<ReturnToFirstScreenEvent>(_returnToFirstScreenEvent);
    on<SignInWithGoogleEvent>(_signInWithGoogleEvent);
    on<SignInWithFacebookEvent>(_signInWithFacebookEvent);
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
        verificationState: VerificationState.awaitingAgreemnt,
      ));
    });
  }

  FutureOr<void> _cacheDataEvent(
      CacheDataEvent event, Emitter<UserDetailsState> emit) async {
    final result = await addUserSharedPrefsDataUseCase(
        SharedPrefsDataParams(false, true, state.phoneNum ?? "unknown"));
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

  Future<FutureOr<void>> _signInWithGoogleEvent(
      SignInWithGoogleEvent event, Emitter<UserDetailsState> emit) async {
    emit(state.copyWith(verificationState: VerificationState.awaitingUserInput, method: SignInMethod.google));
    final result = await signInWithGoogleUseCase(const NoParams());
    result.fold(
        (l) => emit(state.copyWith(
            verificationState: VerificationState.failed, message: l.message)),
        (r) => emit(state.copyWith(
            verificationState: VerificationState.awaitingAgreemnt, method: r.method)));
  }

  FutureOr<void> _signInWithFacebookEvent(event, Emitter<UserDetailsState> emit) async {
    emit(state.copyWith(verificationState: VerificationState.awaitingUserInput, method: SignInMethod.facebook));
    final result = await signInWithFacebookUseCase(const NoParams());
    result.fold(
            (l) => emit(state.copyWith(
            verificationState: VerificationState.failed, message: l.message)),
            (r) => emit(state.copyWith(
            verificationState: VerificationState.awaitingAgreemnt, method: r.method)));
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
  }
}