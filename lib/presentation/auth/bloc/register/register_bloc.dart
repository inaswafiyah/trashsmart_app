import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';
import 'package:trashsmart/presentation/auth/bloc/register/register_event.dart';
import 'package:trashsmart/presentation/auth/bloc/register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDatasource authDatasource;

  RegisterBloc({required this.authDatasource}) : super(RegisterInitial()) {
    on<SubmitRegister>((event, emit) async {
      emit(RegisterLoading());

      final result = await authDatasource.register(event.request);

      result.fold(
        (error) => emit(RegisterFailure(error)),
        (response) => emit(RegisterSuccess(response)),
      );
    });
  }
}
