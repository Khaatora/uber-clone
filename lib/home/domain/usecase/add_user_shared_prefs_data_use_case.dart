import 'package:dartz/dartz.dart';

import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/home/domain/repository/i_user_repository.dart';
import '../../../core/errors/failures/failures.dart';

class AddUserSharedPrefsDataUseCase extends IUseCase<void, SharedPrefsDataParams>{
  final IUserRepository userRepository;

  AddUserSharedPrefsDataUseCase(this.userRepository);

  @override
  Future<Either<Failure, void>> call(SharedPrefsDataParams params) {
    return userRepository.addUserSharedPrefsData(params);
  }

}