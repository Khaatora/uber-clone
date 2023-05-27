import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/core/utils/enums/loading_enums.dart';
import 'package:uber_own/app_init/domain/entity/user_shared_prefs_data.dart';

import '../../domain/usecase/add_user_shared_prefs_data_use_case.dart';
import '../../domain/usecase/get_shared_prefs_data_use_case.dart';

part 'init_app_event.dart';

part 'init_app_state.dart';

class InitAppBloc extends Bloc<BaseAppEvent, InitAppState> {
  final GetSharedPrefsDataUseCase getSharedPrefsDataUseCase;
  final AddUserSharedPrefsDataUseCase addUserSharedPrefsDataUseCase;

  InitAppBloc(
      this.getSharedPrefsDataUseCase, this.addUserSharedPrefsDataUseCase)
      : super(const InitAppState()) {
    on<GetSharedPrefsDataEvent>(_getSharedPrefsDataEvent);
    on<InitAppEvent>(_initAppEvent);
  }

  FutureOr<void> _getSharedPrefsDataEvent(
      GetSharedPrefsDataEvent event, Emitter<InitAppState> emit) async {
    final result = await getSharedPrefsDataUseCase(const NoParams());
    result.fold(
        (l) => emit(state.copyWith(initAppState: LoadingState.error)),
        (r) => emit(state.copyWith(
            initAppState: LoadingState.loaded, userSharedPreferencesData: r)));
  }

  FutureOr<void> _initAppEvent(
      InitAppEvent event, Emitter<InitAppState> emit) async {
    // check if user exits, go to home if exits or go to get started if doesn't exist
    final result = await getSharedPrefsDataUseCase(const NoParams());
    result.fold(
        (l) {
          if(l.message == "prefs is empty") {
            emit(state.copyWith(initAppState: LoadingState.init));
          } else{
            emit(state.copyWith(initAppState: LoadingState.error, message: l.message));
          }

        },
        (r) => emit(state.copyWith(
            initAppState: LoadingState.loaded, userSharedPreferencesData: r)));
  }
}
