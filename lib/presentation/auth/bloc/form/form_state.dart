import 'package:equatable/equatable.dart';

abstract class FormState extends Equatable {
  @override
  List<Object> get props => [];
}

class FormInitial extends FormState {}

class FormSubmitting extends FormState {}

class FormSuccess extends FormState {}

class FormFailure extends FormState {
  final String error;

  FormFailure(this.error);

  @override
  List<Object> get props => [error];
}
