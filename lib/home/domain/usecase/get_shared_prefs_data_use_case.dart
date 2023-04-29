import 'package:dartz/dartz.dart';

import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/home/domain/repository/i_user_repository.dart';
import '../../../core/errors/failures/failures.dart';
import '../entity/user_shared_prefs_data.dart';

class GetSharedPrefsDataUseCase extends IUseCase<UserSharedPreferencesData, NoParams>{
  final IUserRepository userRepository;

  GetSharedPrefsDataUseCase(this.userRepository);

  @override
  Future<Either<Failure, UserSharedPreferencesData>> call(NoParams params) {
    return userRepository.getSharedPrefsData();
  }

}