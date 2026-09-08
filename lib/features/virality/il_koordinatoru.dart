import 'package:flutter/material.dart';
import '../../services.dart';

/// Bilgi Yolu - İl Koordinatörü ve 81 İl Liderlik Tablosu Modülü
/// 81 ilin öğrencileri arasında dostane bir dayanışma ve yarış oluşturur.
class IlKoordinatoruScreen extends StatelessWidget {
  const IlKoordinatoruScreen({super.key});

  static final List<Map<String, dynamic>> cityRankings = [
    {'rank': 1, 'name': 'Ankara', 'solved': 48920, 'xp': 978400, 'schools': 342},
    {'rank': 2, 'name': 'İstanbul', 'solved': 46780, 'xp': 935600, 'schools': 610},
    {'rank': 3, 'name': 'İzmir', 'solved': 31450, 'xp': 629000, 'schools': 218},
    {'rank': 4, 'name': 'Bursa', 'solved': 24100, 'xp': 482000, 'schools': 175},
    {'rank': 5, 'name': 'Antalya', 'solved': 22890, 'xp': 457800, 'schools': 160},
    {'rank': 6, 'name': 'Konya', 'solved': 19800, 'xp': 396000, 'schools': 140},
    {'rank': 7, 'name': 'Adana', 'solved': 18450, 'xp': 369000, 'schools': 132},
    {'rank': 8, 'name': 'Eskişehir', 'solved': 17920, 'xp': 358400, 'schools': 98},
    {'rank': 9, 'name': 'Gaziantep', 'solved': 16800, 'xp': 336000, 'schools': 125},
    {'rank': 10, 'name': 'Trabzon', 'solved': 15200, 'xp': 304000, 'schools': 89},
  ];

  @override
  Widget build(BuildContext context) {
    final user = StorageService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İl Koordinatörlüğü & 81 İl Yarışı'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF002366),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text(
                    '${user.cityCode}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002366),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Şehrin: ${user.cityName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Senin Katkın: ${user.totalSolvedCount} soru • ${user.totalXp} XP',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE30A17),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'CANLI',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '81 İl Başarı Sıralaması',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Toplam Çözülen Soru',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: cityRankings.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = cityRankings[index];
                final isTop3 = index < 3;
                final badgeColors = [
                  const Color(0xFFFFD700), // Altın
                  const Color(0xFFC0C0C0), // Gümüş
                  const Color(0xFFCD7F32), // Bronz
                ];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isTop3 ? badgeColors[index] : Colors.grey.shade200,
                    foregroundColor: isTop3 ? Colors.black87 : Colors.black54,
                    child: Text(
                      '${item['rank']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    item['name'] as String,
                    style: TextStyle(
                      fontWeight: isTop3 ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text('${item['schools']} Okul Temsil Ediliyor'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${item['solved']} Soru',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF002366),
                        ),
                      ),
                      Text(
                        '${item['xp']} XP',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
