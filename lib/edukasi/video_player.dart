import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerPage extends StatefulWidget {
  final List<Map<String, dynamic>> videos;
  final String initialUrl;

  const VideoPlayerPage({
    Key? key,
    required this.videos,
    required this.initialUrl,
  }) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();

  static String youtubeVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtu.be')) return uri.pathSegments.first;
    return uri.queryParameters['v'] ?? '';
  }
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  late String currentUrl;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.initialUrl;
    _setupPlayer(currentUrl);
  }

  void _setupPlayer(String url) {
    final id = VideoPlayerPage.youtubeVideoId(url);
    _controller = YoutubePlayerController.fromVideoId(
      videoId: id,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  void _changeVideo(String newUrl) {
    if (newUrl == currentUrl) return;
    setState(() {
      currentUrl = newUrl;
      final id = VideoPlayerPage.youtubeVideoId(newUrl);
      _controller.loadVideoById(videoId: id);
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentVideo =
        widget.videos.firstWhere((v) => v['youtube_link'] == currentUrl);

    final currentThumb = currentVideo['thumbnail'] ??
        'https://img.youtube.com/vi/${VideoPlayerPage.youtubeVideoId(currentUrl)}/0.jpg';

    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00973A),
          centerTitle: true,
          title: const Text(
            'Video Edukasi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Player utama
            Container(
              padding: const EdgeInsets.all(12),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(aspectRatio: 16 / 9, child: player),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentVideo['title'] ?? 'Tanpa Judul',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(currentThumb),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentVideo['author'] ?? 'Admin Trashsmart',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Video Lainnya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ...widget.videos.map((v) {
              final url = v['youtube_link'] ?? '';
              final id = VideoPlayerPage.youtubeVideoId(url);
              final title = v['title'] ?? 'Tanpa Judul';
              final thumbUrl = v['thumbnail'] ??
                  'https://img.youtube.com/vi/$id/0.jpg';

              return GestureDetector(
                onTap: () => _changeVideo(url),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(8),
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://img.youtube.com/vi/$id/0.jpg',
                              width: 120,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Icon(
                            Icons.play_circle_fill,
                            size: 32,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(thumbUrl),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
