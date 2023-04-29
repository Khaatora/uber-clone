import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class UserSharedPreferencesData  extends Equatable{
  final bool showGreeting;
  final bool addedPhone;
  final String phoneNumber;
  const UserSharedPreferencesData(this.showGreeting, this.addedPhone, [this.phoneNumber = '']);

  @override
  List<Object?> get props => [showGreeting, addedPhone];
}