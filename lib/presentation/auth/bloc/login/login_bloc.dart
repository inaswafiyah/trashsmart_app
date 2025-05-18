import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';
import 'package:trashsmart/data/model/request/login_request_model.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource authRemoteDatasource;

  LoginBloc(this.authRemoteDatasource) : super(LoginState.initial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginState.loading());

      final dataRequest = LoginRequestModel(
        email: event.email, 
        password: event.password, 
      );

      final response = await authRemoteDatasource.login(dataRequest);

      response.fold(
        (error) => emit(LoginState.error(error)),
        (data) async {
          // Pastikan token tidak null
          if (data.token != null) {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', data.token!); // Simpan token jika tidak null

            emit(LoginState.success(data)); // Emit success dengan data
          } else {
            // Jika token null, tampilkan error
            emit(LoginState.error('Token is null'));
          }
        },
      );
    });
  }
}
