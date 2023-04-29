import 'package:dartz/dartz.dart';
import 'package:uber_own/home/domain/entity/user.dart';
import 'package:uber_own/home/domain/entity/user_shared_prefs_data.dart';
import '../../../core/errors/failures/failures.dart';
import '../../../core/usecase/base_usecase.dart';


abstract class IUserRepository{

  Future<Either<Failure, UserSharedPreferencesData>> getSharedPrefsData();

  Future<Either<Failure, void>> verifyUserPhone(PhoneNumberDetailsParams params);

  Future<Either<Failure, MyUser>> sendPhoneVerificationCode(PhoneNumberDetailsParams params);


  Future<Either<Failure, void>> addUserSharedPrefsData(SharedPrefsDataParams params);


}