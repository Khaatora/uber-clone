part of 'init_app_bloc.dart';

class InitAppState extends Equatable {

  final LoadingState initAppState;
  final UserSharedPreferencesData? userSharedPreferencesData;
  final String message ;

  const InitAppState({
    this.initAppState = LoadingState.init,
    this.userSharedPreferencesData,
    this.message = '',
});

  InitAppState copyWith({
    LoadingState? initAppState,
    UserSharedPreferencesData? userSharedPreferencesData,
    String? message,
}){
    return InitAppState(
      userSharedPreferencesData: userSharedPreferencesData ?? this.userSharedPreferencesData,
      initAppState: initAppState ?? this.initAppState,
      message: message ?? this.message
    );
  }

  @override
  List<Object?> get props => [
    initAppState,
    userSharedPreferencesData,
    message,
  ];
}

