import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc() : super(const LogoutState.initial());

  @override
  Stream<LogoutState> mapEventToState(LogoutEvent event) async* {
    if (event is Logout) {
      yield const LogoutState.loading(); // Menampilkan loading saat logout

      try {
        // Hapus token dari SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token'); // Menghapus token

        yield const LogoutState.success(); // Emit success setelah logout berhasil
      } catch (e) {
        yield LogoutState.error('Logout gagal, coba lagi'); // Emit error jika gagal
      }
    }
  }
}
