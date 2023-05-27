
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_own/core/network/network_info.dart';
import 'package:uber_own/app_init/data/datasource/shared_prefs_data_source.dart';
import 'package:uber_own/app_init/data/datasource/user_remote_data_source.dart';
import 'package:uber_own/app_init/data/repository/user_repository.dart';
import 'package:uber_own/app_init/domain/repository/i_user_repository.dart';
import 'package:uber_own/app_init/domain/usecase/add_user_shared_prefs_data_use_case.dart';
import 'package:uber_own/app_init/domain/usecase/get_shared_prefs_data_use_case.dart';
import 'package:uber_own/app_init/domain/usecase/send_phone_verification_code_use_case.dart';
import 'package:uber_own/app_init/domain/usecase/sign_in_with_google_use_case.dart';
import 'package:uber_own/app_init/domain/usecase/sign_in_wtih_facebook_use_case.dart';
import 'package:uber_own/app_init/domain/usecase/verify_user_phone_use_case.dart';
import 'package:uber_own/app_init/presentation/controller/init_app_bloc.dart';
import 'package:uber_own/app_init/presentation/controller/user_details_bloc.dart';

final sl = GetIt.instance;

class ServicesLocator{
  void init(){

    // Bloc
    sl.registerFactory<InitAppBloc>(() => InitAppBloc(sl(), sl()));
    sl.registerFactory<UserDetailsBloc>(() => UserDetailsBloc(sl(), sl(), sl(), sl(), sl()));

    // Data Source
    sl.registerLazySingleton<SharedPrefsSource>(() => SharedPrefsDataSource());
    sl.registerLazySingleton<UserDataSource>(() => UserRemoteDataSource());

    // Repository
    sl.registerLazySingleton<IUserRepository>(() => UserRepository(sl(), sl(),sl()));

    // UseCase
    sl.registerLazySingleton<GetSharedPrefsDataUseCase>(() => GetSharedPrefsDataUseCase(sl()));
    sl.registerLazySingleton<VerifyUserPhoneUseCase>(() => VerifyUserPhoneUseCase(sl()));
    sl.registerLazySingleton<SendPhoneVerificationCodeUseCase>(() => SendPhoneVerificationCodeUseCase(sl()));
    sl.registerLazySingleton<AddUserSharedPrefsDataUseCase>(() => AddUserSharedPrefsDataUseCase(sl()));
    sl.registerLazySingleton<SignInWithGoogleUseCase>(() => SignInWithGoogleUseCase(sl()));
    sl.registerLazySingleton<SignInWithFacebookUseCase>(() => SignInWithFacebookUseCase(sl()));

    // SharedPrefs
    sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());


    // Internet Connection Checker
    sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker.createInstance());

    // NetworkImpl
    sl.registerLazySingleton<INetworkInfo>(() => ICCNetworkInfo(sl()));

    // GoogleSignIn Instance
    sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
    
    // FacebookSignIn instance
    sl.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);
  }
}