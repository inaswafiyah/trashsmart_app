import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/core/constants/variable.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';
import 'package:trashsmart/message/popup_edit_success.dart';
import 'package:trashsmart/message/popup_edit_alert.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _avatarUrl;

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');
    final avatar = prefs.getString('avatar_url');
    if (authData != null) {
      final user = AuthResponseModel.fromJson(authData).user;
      setState(() {
        _nameController.text = user?.username ?? '';
        _phoneController.text = user?.phone ?? '';
        _emailController.text = user?.email ?? '';
        _avatarUrl = avatar;
      });
    }
  }

  Future<bool> _updateProfileApi() async {
    final prefs = await SharedPreferences.getInstance();
    final authDataString = prefs.getString('auth_data');
    if (authDataString == null) return false;
    final authData = AuthResponseModel.fromJson(authDataString);
    final user = authData.user;
    if (user == null || user.id == null) return false;

    final url = Uri.parse('${Variable.baseUrl}/api/update-profile/${user.id}');
    final body = jsonEncode({
      'username': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    });

    final token = authData.token ?? '';

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userData = data['data'];
      final prefs = await SharedPreferences.getInstance();

      final authDataString = prefs.getString('auth_data');
      if (authDataString != null) {
        final authData = jsonDecode(authDataString);
        authData['user'] = userData;
        await prefs.setString('auth_data', jsonEncode(authData));
      }
      return true;
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      final errors = data['errors'];
      String errorMsg = '';
      if (errors['email'] != null) {
        errorMsg += errors['email'][0];
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMsg.isNotEmpty ? errorMsg : 'Gagal update profile',
          ),
        ),
      );
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
      return false;
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

  void _handleSave() async {
    if (!_isFormValid) return;

    final isSuccess = await _updateProfileApi();
    if (isSuccess) {
      showSuccessDialog(context).then((continueEditing) {
        if (continueEditing == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        } else {
          _safePop();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: _safePop),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(30),
                child: Center(
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
                              _nameController.text.isNotEmpty
                                  ? _nameController.text[0].toUpperCase()
                                  : 'A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : null,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200,
                ),
                color: Colors.grey[50],
                padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    _buildFieldLabel('Nama'),
                    _buildTextField(_nameController, 'Nama Lengkap'),
                    SizedBox(height: 22),
                    _buildFieldLabel('No Telephone'),
                    _buildTextField(_phoneController, 'Masukan No Telephone'),
                    SizedBox(height: 22),
                    _buildFieldLabel('Email'),
                    _buildTextField(_emailController, 'Masukan Email'),
                    SizedBox(height: 60),
                    _buildButtons(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    final bool isEmpty = controller.text.isEmpty;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isEmpty ? Colors.grey[200] : Colors.white,
        border: isEmpty ? null : Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 55.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                showExitConfirmationDialog(context);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00973A)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF00973A),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: _isFormValid ? _handleSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid ? Color(0xFF00973A) : Colors.grey,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }
}
