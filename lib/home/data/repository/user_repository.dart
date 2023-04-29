import 'package:dartz/dartz.dart';
import 'package:uber_own/core/errors/exceptions/exceptions.dart';
import 'package:uber_own/core/network/network_info.dart';
import 'package:uber_own/home/data/datasource/shared_prefs_data_source.dart';
import 'package:uber_own/home/domain/entity/user.dart';
import 'package:uber_own/home/domain/repository/i_user_repository.dart';

import '../../../core/errors/failures/failures.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../domain/entity/user_shared_prefs_data.dart';
import '../datasource/user_remote_data_source.dart';

class UserRepository extends IUserRepository{

  final SharedPrefsSource sharedPrefsSource;
  final UserDataSource userDataSource;
  final INetworkInfo networkInfo;

  UserRepository(this.sharedPrefsSource, this.userDataSource, this.networkInfo);

  @override
  Future<Either<Failure, UserSharedPreferencesData>> getSharedPrefsData() async{
    try {
      final result = await sharedPrefsSource.getData();
      return Right(result);
    } on CacheException catch (failure) {
      return left(CacheFailure(failure.message));
    }
  }

  @override
  Future<Either<Failure, void>> verifyUserPhone(PhoneNumberDetailsParams params) async{
    try{
      await _checkInternetConnection();
      var result =await userDataSource.getPhoneNumberCode(params);
      return Right(result);

    } on ServerException catch(failure){
        return Left(ServerFailure(failure.message));
    }
  }

  @override
  Future<Either<Failure, MyUser>> sendPhoneVerificationCode(PhoneNumberDetailsParams params) async {
    try{
      await _checkInternetConnection();
      var result =await userDataSource.verifyOTP(params);
      return Right(result);

    } on ServerException catch(failure){
      return Left(ServerFailure(failure.message));
    }
  }

  @override
  Future<Either<Failure, void>> addUserSharedPrefsData(SharedPrefsDataParams params) async {
    return Right(await sharedPrefsSource.addData(params));
  }


  Future<void> _checkInternetConnection() async {
    if(!await networkInfo.isConnected) throw const NoInternetException();
  }
}