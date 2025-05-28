import 'package:flutter/material.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';
import 'package:trashsmart/edukasi/edukasi_detail.dart';
import 'package:trashsmart/edukasi/video_player.dart';

class HalamanEdukasiPage extends StatelessWidget {
  const HalamanEdukasiPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video Edukasi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00973A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: AuthRemoteDatasource().getAllVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return customLoadingWidget();
          }
          if (snapshot.hasError || snapshot.data?.isLeft() == true) {
            return const Center(child: Text('Gagal mengambil video'));
          }

          final videos = snapshot.data!.getOrElse(() => []);

          // Urutkan berdasarkan created_at (atau field tanggal lain dari backend)
          videos.sort((a, b) {
            final aDate = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
            final bDate = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
            return bDate.compareTo(aDate); // terbaru di atas
          });

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildBanner(context),

              const SizedBox(height: 35),
              const Text(
                'Yuk Belajar Bareng Trashsmart!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              ...videos.map((video) {
                final url = video['youtube_link'] ?? '';
                final title = video['title'] ?? 'Tanpa Judul';
                final author = video['author'] ?? 'Admin Trashsmart';
                final id = VideoPlayerPage.youtubeVideoId(url);
                final thumb = video['thumbnail'] ??
                    'https://img.youtube.com/vi/$id/0.jpg';

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerPage(
                        videos: videos,
                        initialUrl: url,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  'https://img.youtube.com/vi/$id/0.jpg',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  loadingBuilder: (context, child, progress) =>
                                      progress == null
                                          ? child
                                          : customLoadingWidget(),
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: Colors.grey[300]),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(thumb),
                                  ),
                                  const SizedBox(width: 6),
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
          );
        },
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF00973A)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/maskott.png',
            width: 120,
            height: 140,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mengapa Edukasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Tentang Sampah',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Itu Penting?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EdukasiDetailPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDD00),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Selengkapnya'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
