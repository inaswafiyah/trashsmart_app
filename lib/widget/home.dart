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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/widget/profile.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int totalDonasi = 0;
  bool isLoadingDonasi = true;
  bool isLoadingUser = true;
  bool isLoadingVideos = true;
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
    setState(() {
      isLoadingUser = true;
    });
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final prefs = await SharedPreferences.getInstance();
      String? avatar;
      if (authData.user != null && authData.user!.username != null) {
        if (authData.user!.avatar != null &&
            authData.user!.avatar!.imagePath != null) {
          avatar = '${Variable.baseUrl}/${authData.user!.avatar!.imagePath}';
          await prefs.setString('avatar_url', avatar);
        } else {
          avatar = prefs.getString('avatar_url');
        }
        if (!mounted) return;
        setState(() {
          username = authData.user!.username!;
          avatarUrl = avatar;
          isLoadingUser = false;
        });
      } else {
        setState(() {
          isLoadingUser = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  Future<void> _loadVideos() async {
    setState(() {
      isLoadingVideos = true;
    });
    final result = await AuthRemoteDatasource().getAllVideos();
    result.fold(
      (error) {
        print("Gagal ambil video: $error");
        setState(() {
          isLoadingVideos = false;
        });
      },
      (videos) {
        videos.sort((a, b) {
          final aDate =
              DateTime.tryParse(a['created_at'] ?? '') ?? DateTime.now();
          final bDate =
              DateTime.tryParse(b['created_at'] ?? '') ?? DateTime.now();
          return bDate.compareTo(aDate);
        });
        if (!mounted) return;
        setState(() {
          sortedVideos = videos;
          isLoadingVideos = false;
        });
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

  Widget customLoadingWidget() {
    return Center(
      child: SizedBox(
        width: 42,
        height: 42,
        child: CircularProgressIndicator(
          strokeWidth: 7,
          color: const Color(0xE500973A),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser || isLoadingVideos) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: customLoadingWidget(),
      );
    }

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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfilePages()),
                    );
                    await _loadUserData();
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    backgroundImage:
                        (avatarUrl != null && avatarUrl!.isNotEmpty)
                            ? NetworkImage(avatarUrl!)
                            : null,
                    child:
                        (avatarUrl == null || avatarUrl!.isEmpty)
                            ? Text(
                              username.isNotEmpty
                                  ? username[0].toUpperCase()
                                  : "U",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            )
                            : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFDC901),
                        size: 62,
                      ),
                      const SizedBox(width: 8),
                      isLoadingDonasi
                          ? customLoadingWidget()
                          : Text(
                            "$totalDonasi",
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
            const Text(
              "Kategori Sampah",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 35),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((cat) {
                      return GestureDetector(
                        onTap: () {
                          Widget targetPage;
                          switch (cat['label']) {
                            case 'Plastik':
                              targetPage = PlastikDetailPage();
                              break;
                            case 'Kertas':
                              targetPage = KertasDetailPage();
                              break;
                            case 'Logam':
                              targetPage = LogamDetailPage();
                              break;
                            case 'Organik':
                              targetPage = OrganikDetailPage();
                              break;
                            case 'Tekstil':
                              targetPage = TekstilDetailPage();
                              break;
                            case 'Kaca':
                              targetPage = KacaDetailPage();
                              break;
                            case 'Jelantah':
                              targetPage = JelantahDetailPage();
                              break;
                            default:
                              targetPage = CategoryPage(label: cat['label']);
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => targetPage),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 19),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  child: Image.asset(
                                    cat['icon'],
                                    width: 40,
                                    height: 40,
                                  ),
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
            const Text(
              'Video Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ...(sortedVideos.take(2)).map((video) {
              final url = video['youtube_link'] ?? '';
              final id = _youtubeVideoId(url);
              final title = video['title'] ?? 'Tanpa Judul';
              final author = video['author'] ?? 'Admin';
              final thumb =
                  video['thumbnail'] ?? 'https://img.youtube.com/vi/$id/0.jpg';

              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => VideoPlayerPage(
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
                              width: 120,
                              height: 68,
                              child: Image.network(
                                'https://img.youtube.com/vi/$id/0.jpg',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.play_circle_fill,
                            size: 40,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
