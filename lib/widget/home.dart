// ... semua import tetap
import 'package:flutter/material.dart';
import 'package:trashsmart/category/category_page.dart';
import 'package:trashsmart/category/jelantah_page.dart';
import 'package:trashsmart/category/kaca_page.dart';
import 'package:trashsmart/category/kertas_page.dart';
import 'package:trashsmart/category/logam_page.dart';
import 'package:trashsmart/category/organik_page.dart';
import 'package:trashsmart/category/plastik_page.dart';
import 'package:trashsmart/category/tekstil_page.dart';
import 'package:trashsmart/core/constants/variable.dart';
import 'package:trashsmart/data/datasource/auth_local_datasource.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';
import 'package:trashsmart/edukasi/video_player.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/widget/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int totalDonasi = 0;
  bool isLoadingDonasi = true; // Tambahkan ini
  String username = "User";
  String? avatarUrl;
  List<Map<String, dynamic>> sortedVideos = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadVideos();
    _loadTotalDonasi();
  }

  Future<void> _loadUserData() async {
  try {
    final authData = await AuthLocalDatasource().getAuthData();
    final prefs = await SharedPreferences.getInstance();
    String? avatar;
    if (authData.user != null && authData.user!.username != null) {
      // Ambil dari data user jika ada avatar
      if (authData.user!.avatar != null && authData.user!.avatar!.imagePath != null) {
        avatar = '${Variable.baseUrl}/${authData.user!.avatar!.imagePath}';
        await prefs.setString('avatar_url', avatar); // update cache
      } else {
        avatar = prefs.getString('avatar_url');
      }
      if (!mounted) return;
      setState(() {
        username = authData.user!.username!;
        avatarUrl = avatar;
      });
    }
  } catch (e) {
    print('Error loading user data: $e');
  }
}

Future<void> _loadVideos() async {
  print("Mulai load videos");
  final result = await AuthRemoteDatasource().getAllVideos();
  print("Selesai getAllVideos");
  result.fold(
    (error) => print("Gagal ambil video: $error"),
    (videos) {
      print("Videos didapat, jumlah: ${videos.length}");
      videos.sort((a, b) {
        final aDate = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime.now();
        final bDate = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime.now();
        return bDate.compareTo(aDate);
      });
      if (!mounted) {
        print("Widget sudah tidak mounted, return");
        return;
      }
      print("Sebelum setState");
      setState(() {
        sortedVideos = videos;
      });
      print("SetState selesai");
    },
  );
}

Future<void> _loadTotalDonasi() async {
  if (!mounted) return;
  setState(() {
    isLoadingDonasi = true;
  });
  try {
    final total = await AuthRemoteDatasource().getTotalDonasi();
    if (!mounted) return;
    setState(() {
      totalDonasi = total;
      isLoadingDonasi = false;
    });
  } catch (e) {
    print('Error loading total donasi: $e');
    if (!mounted) return;
    setState(() {
      isLoadingDonasi = false;
    });
  }
}

  String _youtubeVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtu.be')) return uri.pathSegments.first;
    return uri.queryParameters['v'] ?? '';
  }

  final List<Map<String, dynamic>> categories = [
    {"icon": "assets/images/plastik.png", "label": "Plastik"},
    {"icon": "assets/images/kertas.png", "label": "Kertas"},
    {"icon": "assets/images/logam.png", "label": "Logam"},
    {"icon": "assets/images/organik.png", "label": "Organik"},
    {"icon": "assets/images/tekstil.png", "label": "Tekstil"},
    {"icon": "assets/images/kaca.png", "label": "Kaca"},
    {"icon": "assets/images/jelantah.png", "label": "Jelantah"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Ubah sampahmu menjadi Berkah",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePages()));
                  },
                  child: CircleAvatar(
                    radius: 30, // avatar profile lebih besar
                    backgroundColor: Colors.green,
                    backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                        ? NetworkImage(avatarUrl!)
                        : null,
                    child: (avatarUrl == null || avatarUrl!.isEmpty)
                        ? Text(
                            username.isNotEmpty ? username[0].toUpperCase() : "U",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // Progres Donasi
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF00973A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Progres Penukaranmu",
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFDC901), size: 62), // bintang besar
                      const SizedBox(width: 8),
                      Text(
                        isLoadingDonasi ? ".." : "$totalDonasi",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Total Bintangmu",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFFDC901), thickness: 2),
                  const SizedBox(height: 16),
                  const Text(
                    "Kumpulkan bintang, wujudkan kebaikan!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),
            const Text("Kategori Sampah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 35),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  return GestureDetector(
                    onTap: () {
                      Widget targetPage;
                      switch (cat['label']) {
                        case 'Plastik': targetPage = PlastikDetailPage(); break;
                        case 'Kertas': targetPage = KertasDetailPage(); break;
                        case 'Logam': targetPage = LogamDetailPage(); break;
                        case 'Organik': targetPage = OrganikDetailPage(); break;
                        case 'Tekstil': targetPage = TekstilDetailPage(); break;
                        case 'Kaca': targetPage = KacaDetailPage(); break;
                        case 'Jelantah': targetPage = JelantahDetailPage(); break;
                        default: targetPage = CategoryPage(label: cat['label']);
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Image.asset(cat['icon'], width: 40, height: 40),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(cat['label']),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
            const Text('Video Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            ...(sortedVideos.take(2)).map((video) {
              final url = video['youtube_link'] ?? '';
              final id = _youtubeVideoId(url);
              final title = video['title'] ?? 'Tanpa Judul';
              final author = video['author'] ?? 'Admin';
              final thumb = video['thumbnail'] ?? 'https://img.youtube.com/vi/$id/0.jpg';

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerPage(
                      videos: sortedVideos,
                      initialUrl: url,
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 120, // atau 140, sesuaikan dengan desain
                              height: 68, // 16:9 dari 120 = 67.5, dibulatkan 68
                              child: Image.network(
                                'https://img.youtube.com/vi/$id/0.jpg',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Icon(Icons.play_circle_fill, size: 40, color: Colors.white.withOpacity(0.8)),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(thumb),
                                ),
                                const SizedBox(width: 5),
                                Text(author),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}