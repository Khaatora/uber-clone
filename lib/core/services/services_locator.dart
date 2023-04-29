
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_own/core/network/network_info.dart';
import 'package:uber_own/home/data/datasource/shared_prefs_data_source.dart';
import 'package:uber_own/home/data/datasource/user_remote_data_source.dart';
import 'package:uber_own/home/data/repository/user_repository.dart';
import 'package:uber_own/home/domain/repository/i_user_repository.dart';
import 'package:uber_own/home/domain/usecase/add_user_shared_prefs_data_use_case.dart';
import 'package:uber_own/home/domain/usecase/get_shared_prefs_data_use_case.dart';
import 'package:uber_own/home/domain/usecase/send_phone_verification_code_use_case.dart';
import 'package:uber_own/home/domain/usecase/verify_user_phone_use_case.dart';
import 'package:uber_own/home/presentation/controller/init_app_bloc.dart';
import 'package:uber_own/home/presentation/controller/user_details_bloc.dart';

final sl = GetIt.instance;

class ServicesLocator{
  void init(){

    // Bloc
    sl.registerFactory<InitAppBloc>(() => InitAppBloc(sl(), sl()));
    sl.registerFactory<UserDetailsBloc>(() => UserDetailsBloc(sl(), sl(), sl(),));

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

    // SharedPrefs
    sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());


    // Internet Connection Checker
    sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker.createInstance());

    // NetworkImpl
    sl.registerLazySingleton<INetworkInfo>(() => ICCNetworkInfo(sl()));
  }
}