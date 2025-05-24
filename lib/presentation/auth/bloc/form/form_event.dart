import 'package:equatable/equatable.dart';

abstract class FormEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FormSubmitted extends FormEvent {
  final String name;
  final String phone;
  final String address;
  final List<String> categories;

  FormSubmitted({
    required this.name,
    required this.phone,
    required this.address,
    required this.categories,
  });

  @override
  List<Object> get props => [name, phone, address, categories];
}
