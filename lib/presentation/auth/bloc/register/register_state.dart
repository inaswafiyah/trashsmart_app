import 'package:equatable/equatable.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final AuthResponseModel response;

  const RegisterSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}
