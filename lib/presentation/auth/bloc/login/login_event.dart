part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = LoginStarted;
  
  // Perbaiki login event dengan email dan password
  const factory LoginEvent.login({
    required String email,
    required String password,
  }) = LoginSubmitted;
}