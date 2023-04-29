 import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_own/core/errors/exceptions/exceptions.dart';
import 'package:uber_own/core/usecase/base_usecase.dart';
import 'package:uber_own/home/data/models/user_shared_prefs_data_model.dart';

import '../../../core/services/services_locator.dart';

 abstract class SharedPrefsSource{
   bool isReady = false;
  Future<UserSharedPreferenceDataModel> getData();
  Future<void> addData(SharedPrefsDataParams params);
}

class SharedPrefsDataSource extends SharedPrefsSource{
   final String cachedUserDataKey = "CachedUserData";
  @override
  Future<UserSharedPreferenceDataModel> getData() async{
    if(!isReady) await _slIsReady();
    final prefs = sl<SharedPreferences>();
    final keys = prefs.getKeys();
    if(keys.isEmpty) {
     throw const CacheException("prefs is empty");
    }
    final prefsMap = <String, dynamic>{};
    for(String key in keys) {
      prefsMap[key] = prefs.get(key);
    }
    return UserSharedPreferenceDataModel.fromJson(prefsMap);
  }

  @override
  Future<void> addData(SharedPrefsDataParams params) async {
    if(!isReady) await _slIsReady();
    final prefs = sl<SharedPreferences>();
    prefs.setString(cachedUserDataKey, json.encode(params.toJson()));

  }

  Future<void> _slIsReady(){
     return sl.isReady<SharedPreferences>().then((value) => isReady = true);
  }

}