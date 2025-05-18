import 'package:equatable/equatable.dart';
import 'package:trashsmart/data/model/request/register_request_model.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class SubmitRegister extends RegisterEvent {
  final RegisterRequestModel request;

  const SubmitRegister(this.request);

  @override
  List<Object?> get props => [request];
}
