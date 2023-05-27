import 'package:dartz/dartz.dart';
import 'package:uber_own/core/errors/failures/failures.dart';
import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/app_init/domain/entity/user.dart';

import '../repository/i_user_repository.dart';

class SignInWithGoogleUseCase extends IUseCase<MyUser, NoParams>{
  final IUserRepository userRepository;

  SignInWithGoogleUseCase(this.userRepository);
  @override
  Future<Either<Failure, MyUser>> call(NoParams params) {
    return userRepository.signInWithGoogle(params);
  }

}