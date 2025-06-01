import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/data/datasource/auth_local_datasource.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';
import 'package:trashsmart/data/model/request/login_request_model.dart';
import 'package:trashsmart/data/model/request/register_request_model.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';
import 'package:trashsmart/presentation/auth/pages/register.dart';
import 'package:trashsmart/widget/bottom.dart';
import 'package:trashsmart/core/constants/variable.dart'; // Tambahkan import ini

// Import for Firebase & Google Sign-In
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false; 
  final _authRemote = AuthRemoteDatasource();

  final String baseUrl = Variable.baseUrl; // Ganti ke Variable.baseUrl

  bool get isFilled =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  void _login() async {
    setState(() {
      isLoading = true;
    });

    final email = emailController.text;
    final password = passwordController.text;

    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String token = data['token'];
      AuthResponseModel user = AuthResponseModel.fromJson(response.body);

      final authLocalDatasource = AuthLocalDatasource();
      await authLocalDatasource.saveAuthData(user);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('password', password);
      await prefs.setString('token', token);

      // Ambil avatar dari backend (dari response login)
      String? avatarPath = user.user?.avatar?.imagePath;
      if (avatarPath != null && avatarPath.isNotEmpty) {
        // Gabungkan baseUrl + path avatar
        String avatarUrl = baseUrl + avatarPath;
        await prefs.setString('avatar_url', avatarUrl);
      } else {
        await prefs.remove('avatar_url');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottom()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Gagal, periksa email dan password')),
      );
    }
  }

  // ----------------------
  // Google Sign In Method
  // ----------------------
  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user != null) {
        final loginResponse = await _authRemote.login(
          LoginRequestModel(
            email: user.email ?? '',
            password: 'google-${user.uid}',
          ),
        );

        loginResponse.fold(
          (loginError) async {
            final registerResponse = await _authRemote.register(
              RegisterRequestModel(
                email: user.email ?? '',
                password: 'google-${user.uid}',
                confirmPassword: 'google-${user.uid}',
                username: user.email?.split('@')[0] ?? '',
                phone: user.uid.substring(0, 8),
              ),
            );
            registerResponse.fold(
              (registerError) =>
                  _showErrorSnackbar('Gagal Register: $registerError'),
              (registerData) async {
                await AuthLocalDatasource().saveAuthData(registerData);

                // Simpan avatar Google jika ada
                final prefs = await SharedPreferences.getInstance();
                String? avatarPath = registerData.user?.avatar?.imagePath;
                if (avatarPath != null && avatarPath.isNotEmpty) {
                  String avatarUrl = baseUrl + avatarPath;
                  await prefs.setString('avatar_url', avatarUrl);
                } else {
                  await prefs.remove('avatar_url');
                }

                _showSuccessSnackbar(
                  'kamu berhasil register dengan akun baru!',
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Bottom()),
                );
              },
            );
          },
          (loginData) async {
            await AuthLocalDatasource().saveAuthData(loginData);

            // Simpan avatar Google jika ada
            final prefs = await SharedPreferences.getInstance();
            String? avatarPath = loginData.user?.avatar?.imagePath;
            if (avatarPath != null && avatarPath.isNotEmpty) {
              String avatarUrl = baseUrl + avatarPath;
              await prefs.setString('avatar_url', avatarUrl);
            } else {
              await prefs.remove('avatar_url');
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Bottom()),
            );
          },
        );
      }
    } catch (e) {
      _showErrorSnackbar('Gagal Login dengan Google: $e');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00973A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 1),
                  const Text(
                    "Masuk akunmu",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black, // warna judul utama
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/images/logo.png', height: 60),
                  const SizedBox(height: 80),

                  // Email
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masukan Email',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black, // warna judul field
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  _buildTextField(
                    controller: emailController,
                    hintText: 'Masukan Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masukkan Kata Sandi',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black, // warna judul field
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  _buildTextField(
                    controller: passwordController,
                    hintText: 'Masukkan Kata Sandi',
                    obscureText: !showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isFilled && !isLoading ? _login : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFilled && !isLoading
                            ? const Color(0xFF00973A)
                            : Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF605D64),
                            )
                          : Text(
                              'Masuk',
                              style: TextStyle(
                                color: isFilled && !isLoading
                                    ? Colors.white
                                    : const Color(0xFF605D64),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: signInWithGoogle,
                      icon: Image.asset(
                        'assets/icons/google_logo.jpg',
                        height: 24,
                      ),
                      label: const Text(
                        'Masuk dengan Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black, width: 1), // border hitam
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum memiliki akun? ',
                        style: TextStyle(
                          color: Color(0xFF605D64), // warna text
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Buat akun',
                          style: TextStyle(
                            color: Color(0xFF00973A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    bool isFilled = controller.text.isNotEmpty;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: isFilled ? Colors.white : Colors.grey[200],
        border:
            isFilled
                ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.black),
                )
                : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
        enabledBorder:
            isFilled
                ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.black),
                )
                : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
        focusedBorder:
            isFilled
                ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.black),
                )
                : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
