import 'package:uber_own/home/domain/entity/user.dart';

class MyUserModel extends MyUser {
  const MyUserModel(
    super.phoneNumber,
    super.verificationState, [
    super.verificationCode,
    super.email,
  ]);


}
