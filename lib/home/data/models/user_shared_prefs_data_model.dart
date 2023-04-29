import 'package:uber_own/home/domain/entity/user_shared_prefs_data.dart';

class UserSharedPreferenceDataModel extends UserSharedPreferencesData {
  const UserSharedPreferenceDataModel([super.showGreeting = true, super.addedPhone = false, super.phoneNumber = '']);

  factory UserSharedPreferenceDataModel.fromJson(Map<String, dynamic> json) =>
      UserSharedPreferenceDataModel(
        json[JsonKeys.showHome],
        json[JsonKeys.addedPhone],
        json[JsonKeys.phoneNumber],
      );

  Map<String, dynamic> toJson(){
    return {
      JsonKeys.showHome : showGreeting,
      JsonKeys.addedPhone : addedPhone,
      JsonKeys.phoneNumber : phoneNumber,
    };
  }
}

class JsonKeys {
  static const String showHome = "showGreeting";
  static const String addedPhone = "addedPhone";
  static const String phoneNumber = "phoneNumber";
}
