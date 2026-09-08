import 'dart:async';
import 'package:flutter/material.dart';

/// Bilgi Yolu - Eğitim Hikayeleri (Micro-Learning Stories)
/// Sosyal medya story formatında günlük 15 saniyelik hap bilgiler,
/// formüller ve motivasyon notları sunar.
class HikayelerScreen extends StatefulWidget {
  const HikayelerScreen({super.key});

  @override
  State<HikayelerScreen> createState() => _HikayelerScreenState();
}

class _HikayelerScreenState extends State<HikayelerScreen> {
  final List<Map<String, String>> stories = [
    {
      'title': 'TYT Matematik Püf Noktası',
      'category': 'Matematik',
      'content': '📌 Ardışık tek sayıların toplamı her zaman terim sayısının karesine eşittir!\n\nÖrnek: 1 + 3 + 5 + 7 = 16 (4 terim -> 4² = 16). Sınavda saniyeler kazandırır.',
      'color': '0xFF002366',
      'icon': 'calculate',
    },
    {
      'title': 'LGS Türkçe: Yazım Kuralları',
      'category': 'Türkçe',
      'content': '📌 "Şey" sözcüğü her zaman AYRI yazılır!\n\nBir şey, her şey, çok şey... "Şey" hiçbir zaman kendinden önceki kelimeye bitişmez.',
      'color': '0xFFE30A17',
      'icon': 'menu_book',
    },
    {
      'title': 'KPSS Tarih: Şifreli Hafıza',
      'category': 'Tarih',
      'content': '📌 Mudanya Ateşkesi\'ne katılan devletler: İ-F-İ-T (İtalya, Fransa, İngiltere, TBMM).\n\nUnutma: Yunanistan görüşmelere bizzat katılmamış, gemide beklemiştir!',
      'color': '0xFF1B5E20',
      'icon': 'history_edu',
    },
    {
      'title': 'Ehliyet: Geçiş Üstünlüğü',
      'category': 'Trafik',
      'content': '📌 Geçiş Üstünlüğü Sıralaması: C-A-P-S\n\n1. Cankurtaran (Ambulans)\n2. Asayiş (Polis/Jandarma)\n3. Polis/İtfaiye\n4. Sivil Savunma',
      'color': '0xFFE65100',
      'icon': 'local_hospital',
    },
  ];

  int _currentIndex = 0;
  Timer? _timer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startStoryTimer();
  }

  void _startStoryTimer() {
    _timer?.cancel();
    _progress = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          _timer?.cancel();
          _nextStory();
        }
      });
    });
  }

  void _nextStory() {
    if (_currentIndex < stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _startStoryTimer();
    } else {
      Navigator.pop(context);
    }
  }

  void _prevStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _startStoryTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = stories[_currentIndex];
    final bgColor = Color(int.parse(story['color']!));

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: GestureDetector(
          onTapUp: (details) {
            final screenWidth = MediaQuery.of(context).size.width;
            if (details.globalPosition.dx < screenWidth / 3) {
              _prevStory();
            } else {
              _nextStory();
            }
          },
          child: Stack(
            children: [
              // Üst İlerleme Çubukları
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Row(
                  children: List.generate(stories.length, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: index < _currentIndex
                              ? 1.0
                              : index == _currentIndex
                                  ? _progress
                                  : 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Kapat Butonu & Kategori
              Positioned(
                top: 24,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      label: Text(
                        story['category']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Ana Hikaye Kartı
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lightbulb, size: 64, color: Colors.amberAccent),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        story['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          story['content']!,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Alt Bilgi İpucu
              const Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Text(
                  'Sol / Sağ tıklayarak hikayeler arasında geçiş yapabilirsiniz',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
