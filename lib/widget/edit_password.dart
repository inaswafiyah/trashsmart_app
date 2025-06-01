import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/core/constants/variable.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';
import 'package:trashsmart/message/popup_pass_success.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({Key? key}) : super(key: key);

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String _userInitial = '';
  String? _avatarUrl;

  bool get _allFieldsFilled =>
      _currentPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadCurrentPassword();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');
    final avatar = prefs.getString('avatar_url');
    if (authData != null) {
      final user = AuthResponseModel.fromJson(authData).user;
      final username = user?.username ?? 'User';
      setState(() {
        _userInitial = username.isNotEmpty ? username[0].toUpperCase() : '';
        _avatarUrl = avatar;
      });
    }
  }

  Future<void> _loadCurrentPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('password') ?? '';
    setState(() {
      _currentPasswordController.text = savedPassword;
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final currentPass = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (!_allFieldsFilled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua kolom harus diisi')));
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password baru dan konfirmasi tidak sama'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final authDataString = prefs.getString('auth_data');
    if (authDataString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User tidak ditemukan, silakan login ulang'),
        ),
      );
      return;
    }

    final authData = AuthResponseModel.fromJson(authDataString);
    final user = authData.user;
    if (user == null || user.id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User tidak valid')));
      return;
    }

    final url = Uri.parse('${Variable.baseUrl}/api/update-password/${user.id}');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: jsonEncode({
        'current_password': currentPass,
        'new_password': newPass,
        'new_password_confirmation': confirmPass,
      }),
    );

    if (response.statusCode == 200) {
      await prefs.setString('password', newPass);
      setState(() {
        _currentPasswordController.text = newPass;
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });
      if (mounted) {
        await PopSuccessPassword(context);
        _safePop();
      }
    } else {
      String errorMsg =
          'Gagal mengubah password. Periksa password lama dan coba lagi.';
      try {
        final resBody = jsonDecode(response.body);
        if (resBody['message'] != null) {
          errorMsg = resBody['message'];
        } else if (resBody['errors'] != null) {
          errorMsg = resBody['errors'].values
              .map((e) => e.join(', '))
              .join('\n');
        }
      } catch (_) {}
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    }
  }

  void _safePop() {
    FocusScope.of(context).unfocus();
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      return MediaQuery.of(context).viewInsets.bottom > 0;
    }).then((_) {
      Navigator.pop(context);
    });
  }

  void showExitConfirmationPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Batal Ubah Kata Sandi?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Perubahan belum disimpan.\nYakin mau keluar?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _safePop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00973A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hintText,
    bool obscureText,
    VoidCallback toggleVisibility,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: controller.text.isEmpty ? Colors.grey.shade300 : Colors.white,
        border:
            controller.text.isEmpty ? null : Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade700),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _safePop,
        ),
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                          ? NetworkImage(_avatarUrl!)
                          : null,
                  child:
                      (_avatarUrl == null || _avatarUrl!.isEmpty)
                          ? Text(
                            _userInitial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : null,
                ),
              ),
              const Text(
                'Kata Sandi Saat Ini',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPasswordField(
                _currentPasswordController,
                'Kata Sandi Saat Ini',
                _obscureCurrentPassword,
                () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),
              const SizedBox(height: 25),
              const Text(
                'Kata Sandi Baru',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPasswordField(
                _newPasswordController,
                'Kata Sandi Baru',
                _obscureNewPassword,
                () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
              const SizedBox(height: 25),
              const Text(
                'Tulis Ulang Kata Sandi Baru',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPasswordField(
                _confirmPasswordController,
                'Tulis Ulang Kata Sandi Baru',
                _obscureConfirmPassword,
                () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 120),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => showExitConfirmationPassword(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF207A3E),
                        elevation: 0,
                        side: const BorderSide(color: Color(0xFF207A3E)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _allFieldsFilled ? _handleSave : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _allFieldsFilled
                                ? const Color(0xFF00AB41)
                                : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
