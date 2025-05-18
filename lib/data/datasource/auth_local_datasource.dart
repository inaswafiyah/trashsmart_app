import 'package:trashsmart/data/model/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  static const String keyAuthData = 'auth_data';
  static const String keyAvatarUrl = 'avatar_url';
  static const String keyAvatarId = 'avatar_id';

  Future<void> saveAuthData(AuthResponseModel data) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data', data.toJson());
    await pref.setString('token', data.token ?? ''); // Menyimpan token secara eksplisit jika diperlukan

    // Tambahan untuk menyimpan avatar
    if (data.user?.avatar?.imagePath != null) {
      await pref.setString(keyAvatarUrl, data.user!.avatar!.imagePath!);
    }
    if (data.user?.avatarId != null) {
      await pref.setInt(keyAvatarId, data.user!.avatarId!);
    }
  }

  Future<void> removeAuthData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('auth_data');
    await pref.remove(keyAvatarUrl);
    await pref.remove(keyAvatarId);
  }

  Future<AuthResponseModel> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    if (data != null) {
      return AuthResponseModel.fromJson(data); // Mengambil dan mengkonversi data JSON
    } else {
      throw Exception('Data tidak ada');
    }
  }

  Future<bool> isLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey('auth_data');
  }

  // Tambahan untuk ambil avatar
  Future<String?> getAvatarUrl() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(keyAvatarUrl);
  }

  Future<int?> getAvatarId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt(keyAvatarId);
  }
}
