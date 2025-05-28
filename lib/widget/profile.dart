import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/message/popup_logout.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';
import 'package:trashsmart/profile/riwayat_penukaran.dart';
import 'package:trashsmart/widget/edit_password.dart';
import 'package:trashsmart/widget/edit_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:trashsmart/core/constants/variable.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key});

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  String? _username;
  String? _avatarUrl;
  int? _selectedAvatar;
  List<dynamic> _avatars = [];
  bool isAvatarLoading = false;
  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  Future<void> _initProfile() async {
    setState(() { isLoadingProfile = true; });
    await _loadUserData();
    await _fetchAvatars();
    setState(() { isLoadingProfile = false; });
  }

  Future<void> _loadUserData() async {
    final pref = await SharedPreferences.getInstance();
    final authData = pref.getString('auth_data');
    final avatar = pref.getString('avatar_url');
    if (authData != null) {
      final user = AuthResponseModel.fromJson(authData).user;
      setState(() {
        _username = user?.username ?? 'Nama Pengguna';
        _avatarUrl = avatar;
      });
    }
  }

  Future<void> _fetchAvatars() async {
    try {
      final token = (await SharedPreferences.getInstance()).getString('token');
      final response = await http.get(
        Uri.parse('${Variable.baseUrl}/api/avatars'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _avatars = data['data'];
        });
      }
    } catch (e) {
      print('Failed to fetch avatars: $e');
    }
  }

  // Widget loading custom
  Widget customLoadingWidget() {
    return const Center(
      child: SizedBox(
        width: 42,
        height: 42,
        child: CircularProgressIndicator(
          strokeWidth: 7,
          color: Color(0xE500973A),
        ),
      ),
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Choose Your Fighter!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (isAvatarLoading)
                    customLoadingWidget(), // Loading avatar
                  if (!isAvatarLoading)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_avatars.length, (index) {
                          final avatar = _avatars[index];
                          final path = '${Variable.baseUrl}/${avatar['image_path']}';
                          return GestureDetector(
                            onTap: () async {
                              setModalState(() { isAvatarLoading = true; });
                              final pref = await SharedPreferences.getInstance();
                              final token = pref.getString('token');
                              final response = await http.post(
                                Uri.parse('${Variable.baseUrl}/api/update-avatar'),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                  'Content-Type': 'application/json',
                                },
                                body: jsonEncode({'avatar_id': avatar['id']}),
                              );
                              if (response.statusCode == 200) {
                                final userData = jsonDecode(response.body)['user'];
                                final newAvatarPath = userData['avatar']['image_path'];
                                final newAvatarUrl = '${Variable.baseUrl}/$newAvatarPath';
                                await pref.setString('avatar_url', newAvatarUrl);
                                final authData = pref.getString('auth_data');
                                if (authData != null) {
                                  final authJson = jsonDecode(authData);
                                  authJson['user']['avatar'] = userData['avatar'];
                                  await pref.setString('auth_data', jsonEncode(authJson));
                                }
                                setState(() {
                                  _avatarUrl = newAvatarUrl;
                                  _selectedAvatar = avatar['id'];
                                });
                              }
                              setModalState(() { isAvatarLoading = false; });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: avatar['id'] == _selectedAvatar ? Border.all(color: Color(0xFF00973A), width: 3) : null,
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(path),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingProfile) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: customLoadingWidget(),
      );
    }

    final userInitial = _username?.isNotEmpty == true ? _username![0].toUpperCase() : '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: null,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade300,
                child: _avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          _avatarUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Jika gagal load gambar, tampilkan inisial user
                            return Center(
                              child: Text(
                                userInitial,
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        userInitial,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showAvatarPicker,
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFF00973A),
                    child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _username ?? 'Nama Pengguna',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildProfileItem(
                  iconPath: 'assets/icons/iconprofile.png',
                  label: 'Edit Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfilePage()),
                    ).then((_) {
                      _initProfile(); // Refresh data profile setelah kembali dari edit
                    });
                  },
                ),
                const SizedBox(height: 24),
                _buildProfileItem(
                  iconPath: 'assets/icons/iconpass.png',
                  label: 'Ubah Kata Sandi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditPasswordPage()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildProfileItem(
                  iconPath: 'assets/icons/icon_riwayat.png',
                  label: 'Riwayat Penukaran',
                  onTap: () async {
                    final riwayatList = await ambilRiwayat();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RiwayatPenukaranPage(riwayatList: riwayatList),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 110),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PopupLogout()),
                );
              },
              icon: Image.asset(
                'assets/icons/iconlogout.png',
                width: 20,
                height: 20,
                color: Colors.red,
              ),
              label: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static Widget _buildProfileItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Image.asset(iconPath, width: 32, height: 32),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
