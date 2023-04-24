import 'package:equatable/equatable.dart';

abstract class IUseCase{

}

class NoParameter extends Equatable {
  const NoParameter();

  @override
  List<Object?> get props => [];
}