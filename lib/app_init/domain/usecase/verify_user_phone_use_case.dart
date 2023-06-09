import 'package:dartz/dartz.dart';
import 'package:uber_own/core/errors/failures/failures.dart';
import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/app_init/domain/repository/i_user_repository.dart';



class VerifyUserPhoneUseCase extends IUseCase<void, PhoneNumberDetailsParams>{
  final IUserRepository userRepository;

  VerifyUserPhoneUseCase(this.userRepository);

  @override
  Future<Either<Failure, void>> call(PhoneNumberDetailsParams params) {
    return userRepository.verifyUserPhone(params);
  }

}

