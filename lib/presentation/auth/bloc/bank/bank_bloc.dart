import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashsmart/data/datasource/bank_remote_datasource.dart';
import 'package:trashsmart/data/model/response/bank_response_model.dart';
import 'bank_event.dart';
import 'bank_state.dart';
import 'package:dartz/dartz.dart';


class BankBloc extends Bloc<BankEvent, BankState> {
  final BankRemoteDataSource remoteDataSource;

  BankBloc(this.remoteDataSource) : super(const BankState(bankList: [])) {
    on<LoadBankSampah>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final Either<String, List<Data>> result = await remoteDataSource.getBankSampahList();

      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure, isLoading: false)),
        (data) => emit(state.copyWith(bankList: data, isLoading: false)),
      );
    });
  }
}
