import 'package:flutter/material.dart';
import 'package:trashsmart/data/datasource/auth_local_datasource.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';
import 'package:trashsmart/data/model/request/register_request_model.dart';
import 'package:trashsmart/presentation/auth/pages/login.dart';
import 'package:trashsmart/widget/bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _allFieldsFilled = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_checkAllFieldsFilled);
    _phoneController.addListener(_checkAllFieldsFilled);
    _emailController.addListener(_checkAllFieldsFilled);
    _passwordController.addListener(_checkAllFieldsFilled);
    _confirmPasswordController.addListener(_checkAllFieldsFilled);
  }

  void _checkAllFieldsFilled() {
    setState(() {
      _allFieldsFilled =
          _usernameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan kata sandi saat registrasi
  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);  // Menyimpan kata sandi
  }

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await AuthRemoteDatasource().register(
          RegisterRequestModel(
            username: _usernameController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        );

        result.fold(
          (l) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pendaftaran gagal: $l'), backgroundColor: Colors.red),
              );
            }
          },
          (r) {
            AuthLocalDatasource().saveAuthData(r);

            // Simpan kata sandi di SharedPreferences
            savePassword(_passwordController.text); // Menyimpan kata sandi

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pendaftaran berhasil'), backgroundColor: Color(0xFF207A3E)),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Bottom()),
              );
            }
          },
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pendaftaran gagal: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Daftar akunmu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/images/logo.png', height: 55),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  _buildValidatedField(
                    controller: _usernameController,
                    hint: 'Nama Lengkap',
                    errorText: 'Nama lengkap wajib diisi',
                  ),
                  const SizedBox(height: 17),
                  _buildValidatedField(
                    controller: _phoneController,
                    hint: 'Masukan No Telephone',
                    errorText: 'Nomor telepon wajib diisi',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 17),
                  _buildValidatedField(
                    controller: _emailController,
                    hint: 'Email',
                    errorText: 'Email wajib diisi',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 17),
                  _buildPasswordField(
                    controller: _passwordController,
                    hint: 'Masukkan Kata Sandi',
                    isConfirm: false,
                    errorText: 'Kata sandi wajib diisi',
                  ),
                  const SizedBox(height: 17),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    hint: 'Konfirmasi Kata Sandi',
                    isConfirm: true,
                    errorText: 'Konfirmasi kata sandi wajib diisi',
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _allFieldsFilled && !_isLoading
                                  ? const Color(0xFF207A3E)
                                  : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: _isLoading 
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Daftar',
                                style: TextStyle(
                                  color: _allFieldsFilled
                                      ? Colors.white
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'Sudah memiliki akun? ',
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Masuk',
                              style: const TextStyle(
                                color: Color(0xFF207A3E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidatedField({
    required TextEditingController controller,
    required String hint,
    required String errorText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final bool isFilled = value.text.isNotEmpty;
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14),
            filled: true,
            fillColor: isFilled ? Colors.white : Colors.grey[300],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  isFilled
                      ? const BorderSide(color: Colors.black, width: 1)
                      : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  isFilled
                      ? const BorderSide(color: Colors.black, width: 1)
                      : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isConfirm,
    required String errorText,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final bool isFilled = value.text.isNotEmpty;
        return TextFormField(
          controller: controller,
          obscureText: isConfirm ? _obscureConfirm : _obscurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            if (isConfirm && value != _passwordController.text) {
              return 'Kata sandi tidak cocok';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14),
            filled: true,
            fillColor: isFilled ? Colors.white : Colors.grey[300],
            suffixIcon: IconButton(
              icon: Icon(
                (isConfirm ? _obscureConfirm : _obscurePassword)
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  if (isConfirm) {
                    _obscureConfirm = !_obscureConfirm;
                  } else {
                    _obscurePassword = !_obscurePassword;
                  }
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  isFilled
                      ? const BorderSide(color: Colors.black, width: 1)
                      : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  isFilled
                      ? const BorderSide(color: Colors.black, width: 1)
                      : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        );
      },
    );
  }
}
