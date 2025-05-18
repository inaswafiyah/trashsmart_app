import 'package:flutter/material.dart';

class EdukasiDetailPage extends StatelessWidget {
  const EdukasiDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Informasi Edukasi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00973A),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Bikin icon back jadi putih
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Maskot
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/maskott.png",
                    height: 140,
                    width: 120,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Mengapa Edukasi\ntentang sampah\nitu penting?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00973A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Yuk, pelajari",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const Text(
                          "dampaknya dan",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const Text(
                          "bagaimana solusi",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const Text(
                          "sederhananya!",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            // Card Paragraf Penjelasan
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Mengapa Edukasi Sampah itu Penting?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Sampah menjadi salah satu masalah lingkungan terbesar di dunia. Namun, masih banyak orang yang belum benar-benar memahami dampak dari membuang sampah sembarangan. Inilah mengapa edukasi tentang sampah sangat penting untuk dilakukan sejak dini.\n",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "1. Kurangnya Pengetahuan = Kebiasaan Buruk",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Banyak orang membuang sampah sembarangan bukan karena sengaja, tapi karena tidak tahu akibatnya. Tanpa edukasi, mereka tidak sadar bahwa plastik yang mereka buang ke selokan bisa menyebabkan banjir, atau sampah organik yang menumpuk bisa menghasilkan gas metana berbahaya.\n",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "2. Edukasi Membentuk Perilaku Positif",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Dengan edukasi, masyarakat bisa belajar cara memilah sampah, memahami jenis-jenis sampah, dan mulai melakukan kebiasaan kecil seperti membawa tas belanja sendiri, atau menggunakan ulang barang-barang yang masih layak pakai.\n",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "3. Edukasi Melahirkan Generasi Peduli Lingkungan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Anak-anak yang sejak kecil diajarkan pentingnya menjaga lingkungan akan tumbuh menjadi individu yang bertanggung jawab. Mereka akan lebih sadar terhadap dampak jangka panjang dari tindakan mereka terhadap bumi.\n",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "4. Dampak Besar Dimulai dari Langkah Kecil",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Satu orang yang sadar bisa menginspirasi satu keluarga, dan keluarga bisa menginspirasi satu RT. Edukasi memiliki efek domino yang luar biasa dimulai dari satu langkah kecil, bisa menciptakan perubahan besar.\n",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Kesimpulan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Tanpa edukasi, kesadaran tidak akan tumbuh. Tanpa kesadaran, sampah akan terus menjadi masalah. Maka dari itu, mari bersama-sama menyebarkan pengetahuan dan kesadaran baik demi bumi yang lebih bersih dan sehat.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
