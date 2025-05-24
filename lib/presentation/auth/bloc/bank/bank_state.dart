import 'package:equatable/equatable.dart';
import 'package:trashsmart/data/model/response/bank_response_model.dart';

class BankState extends Equatable {
  final List<Data> bankList;
  final bool isLoading;
  final String? errorMessage;

  const BankState({
    required this.bankList,
    this.isLoading = false,
    this.errorMessage,
  });

  BankState copyWith({
    List<Data>? bankList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BankState(
      bankList: bankList ?? this.bankList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [bankList, isLoading, errorMessage];
}
