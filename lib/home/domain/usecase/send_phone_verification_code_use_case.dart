import 'package:dartz/dartz.dart';
import 'package:uber_own/core/errors/failures/failures.dart';
import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/home/domain/entity/user.dart';
import 'package:uber_own/home/domain/repository/i_user_repository.dart';

class SendPhoneVerificationCodeUseCase extends IUseCase<MyUser, PhoneNumberDetailsParams>{
  IUserRepository userRepository;

  SendPhoneVerificationCodeUseCase(this.userRepository);

  @override
  Future<Either<Failure, MyUser>> call(PhoneNumberDetailsParams params) {
    return  userRepository.sendPhoneVerificationCode(params);
  }

}