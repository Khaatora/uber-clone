import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class UserSharedPreferencesData  extends Equatable{
  final bool showGreeting;
  final bool addedPhone;
  final String phoneNumber;
  final String uberCommunityGuidelinesAgreement;
  const UserSharedPreferencesData(this.showGreeting, this.addedPhone, this.uberCommunityGuidelinesAgreement, [this.phoneNumber = '']);

  @override
  List<Object?> get props => [showGreeting, addedPhone];
}