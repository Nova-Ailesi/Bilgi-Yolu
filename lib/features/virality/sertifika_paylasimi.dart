import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../services.dart';

/// Bilgi Yolu - Başarı Sertifikası ve Sosyal Medya Paylaşım Modülü
/// Öğrencilerin çalışma azmini ödüllendiren, sosyal medyada paylaşarak
/// organik yayılım sağlayan prestij sertifikası.
class SertifikaPaylasimiScreen extends StatelessWidget {
  const SertifikaPaylasimiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = StorageService.getCurrentUser();
    final todayStr = '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}';

    void shareCertificate() {
      final shareText = '''
📜 GURURLA BİLDİRİRİM!
Bilgi Yolu Türkiye Genel Başarı Sertifikamı aldım!

🎓 Öğrenci: ${user.name}
📍 Şehir: ${user.cityName} (Plaka: ${user.cityCode})
🎯 Hedef Sınav: ${user.targetExam}
🔥 Çalışma Serisi: ${user.currentStreakDays} Gün
💡 Çözülen Soru: ${user.totalSolvedCount}
⭐ Seviye & XP: Level ${user.level} (${user.totalXp} XP)

Eğitimde fırsat eşitliği için tamamen ücretsiz sınav hazırlığı:
https://bilgiyolu.app/indir

#BilgiYolu #BaşarıSertifikası #${user.targetExam}2025 #EğitimdeFırsatEşitliği
''';
      Share.share(shareText);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resmi Başarı Sertifikası'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Sertifika Görsel Alanı (Türk Eğitim Geleneğine Uygun Prestijli Çerçeve)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE30A17), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Üst Amblem ve Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE30A17), width: 1.5),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/bilgi_yolu.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.school,
                              color: Color(0xFF002366),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'BİLGİ YOLU',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Color(0xFF002366),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'TÜRKİYE DİJİTAL EĞİTİM PLATFORMU',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE30A17),
                    ),
                  ),
                  const Divider(height: 32, thickness: 1.5, color: Color(0xFF002366)),

                  const Text(
                    'ÜSTÜN GAYRET VE BAŞARI SERTİFİKASI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFF002366),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    user.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    '${user.cityName} ilimizde ${user.targetExam} sınav hazırlığı sürecinde ${user.totalSolvedCount} soru çözerek ve ${user.currentStreakDays} günlük kesintisiz çalışma serisini koruyarak büyük bir azim ve başarı örneği sergilemiştir.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  // Başarı İstatistikleri Kutusu
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF002366).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Seviye', 'Lvl ${user.level}'),
                        _buildStatItem('Toplam XP', '${user.totalXp}'),
                        _buildStatItem('Seri', '${user.currentStreakDays} Gün'),
                        _buildStatItem('Doğruluk', '%${user.successRate.toStringAsFixed(0)}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mühür ve İmza
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tarih: $todayStr', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          const Text('Sertifika No: BY-2025-81TR', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE30A17), width: 2),
                        ),
                        child: const Text(
                          'ONAYLI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE30A17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Paylaş Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: shareCertificate,
                icon: const Icon(Icons.share),
                label: const Text('Sertifikayı Instagram & WhatsApp\'ta Paylaş'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF002366))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
