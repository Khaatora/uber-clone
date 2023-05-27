import 'package:dartz/dartz.dart';
import 'package:uber_own/app_init/domain/entity/user.dart';
import 'package:uber_own/app_init/domain/entity/user_shared_prefs_data.dart';
import '../../../core/errors/failures/failures.dart';
import '../../../core/usecase/base_usecase.dart';


abstract class IUserRepository{

  Future<Either<Failure, UserSharedPreferencesData>> getSharedPrefsData();

  Future<Either<Failure, void>> verifyUserPhone(PhoneNumberDetailsParams params);

  Future<Either<Failure, MyUser>> sendPhoneVerificationCode(PhoneNumberDetailsParams params);

  Future<Either<Failure, MyUser>> signInWithGoogle(NoParams params);

  Future<Either<Failure, MyUser>> signInWithFacebook(NoParams params);

  Future<Either<Failure, void>> addUserSharedPrefsData(SharedPrefsDataParams params);



}