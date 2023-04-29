import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../home/data/models/user_shared_prefs_data_model.dart';
import '../errors/failures/failures.dart';



abstract class IUseCase<Type, Params>{
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

class SharedPrefsDataParams extends UserSharedPreferenceDataModel{

  const SharedPrefsDataParams([super.isFirstTime = true, super.addedPhone = false, super.phoneNumber = '']);

}

class PhoneNumberDetailsParams extends Equatable{
  final String phoneNumber;
  final String verificationId;
  final String smsCode;

  const PhoneNumberDetailsParams(this.phoneNumber, [this.verificationId ='', this.smsCode= '']);

  @override
  List<Object?> get props => [phoneNumber];

}