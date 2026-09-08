import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'models.dart';
import 'services.dart';
import 'services/ad_service.dart';
import 'features/virality/okul_elcisi.dart';
import 'features/virality/il_koordinatoru.dart';
import 'features/virality/katki_yarismasi.dart';
import 'features/virality/hikayeler.dart';
import 'features/virality/stres_yonetimi.dart';
import 'features/virality/sertifika_paylasimi.dart';

/// ============================================================================
/// 1. DASHBOARD EKRANI (Ana Sayfa)
/// ============================================================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserModel _user;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Ortaokul & LGS',
      'sub': '5, 6, 7, 8. Sınıf & LGS Çıkmış Sorular',
      'id': 'ortaokul',
      'icon': Icons.menu_book,
      'color': 0xFF002366,
    },
    {
      'title': 'Lise & YKS (TYT - AYT)',
      'sub': 'TYT, AYT, YDT ve 9-12. Sınıf Dersleri',
      'id': 'lise',
      'icon': Icons.school,
      'color': 0xFFE30A17,
    },
    {
      'title': 'Üniversite & KPSS',
      'sub': 'KPSS, ALES, DGS, YDS, YÖKDİL',
      'id': 'universite',
      'icon': Icons.account_balance,
      'color': 0xFF0A3D91,
    },
    {
      'title': 'MEB Ehliyet Sınavı',
      'sub': 'Trafik, İlk Yardım, Motor & Çevre',
      'id': 'ehliyet',
      'icon': Icons.directions_car,
      'color': 0xFF2E7D32,
    },
    {
      'title': 'Açık Öğretim (AÖF - AÖL)',
      'sub': 'Açık Lise ve Anadolu/Atatürk AÖF',
      'id': 'acikogretim',
      'icon': Icons.import_contacts,
      'color': 0xFFE65100,
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshUserData();
    _initBanner();
  }

  void _refreshUserData() {
    setState(() {
      _user = StorageService.getCurrentUser();
    });
  }

  void _initBanner() {
    _bannerAd = AdService.createBannerAd(
      onAdLoaded: () {
        if (mounted) setState(() => _isBannerLoaded = true);
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Color(0xFF002366), size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              'Bilgi Yolu',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology),
            tooltip: 'Stres Yönetimi',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StresYonetimiScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Sertifikamı Paylaş',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SertifikaPaylasimiScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Maskot ve Günlük Seri Kartı
                _buildMascotHeader(),
                const SizedBox(height: 16),

                // Hızlı Erişim Butonları (Hikayeler, Yanlış Defteri, Flashcard)
                _buildQuickActionsRow(),
                const SizedBox(height: 20),

                // Kategori Başlığı
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sınavını Seç & Hemen Başla',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF002366),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const KategorilerScreen()),
                      ),
                      child: const Text('Tümünü Gör', style: TextStyle(color: Color(0xFFE30A17), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Kategoriler Listesi
                ...categories.map((cat) => _buildCategoryCard(cat)).toList(),

                const SizedBox(height: 20),
                // Virality ve Topluluk Banner'ı
                _buildCommunityBanner(),
              ],
            ),
          ),

          // En Altta AdMob Banner Reklamı (Kullanıcıyı rahatsız etmeyen standart alan)
          if (_isBannerLoaded && _bannerAd != null)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }

  Widget _buildMascotHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF002366), Color(0xFF0A3D91)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF002366).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bilge Baykuş Maskotu (Gerçek Vektör Varlık)
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE30A17), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/bilgi_yolu.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text('🦉', style: TextStyle(fontSize: 34)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba, ${_user.name}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hedef: ${_user.targetExam} • ${_user.cityName}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPill('⭐ Lvl ${_user.level}', Colors.amber),
                    const SizedBox(width: 8),
                    _buildPill('🔥 ${_user.currentStreakDays} Gün Seri', Colors.orangeAccent),
                    const SizedBox(width: 8),
                    _buildPill('${_user.totalXp} XP', Colors.lightBlueAccent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Column(
      children: [
        // 1. Satır: Soru ve Çalışma Araçları
        Row(
          children: [
            _buildActionTile(
              icon: Icons.flash_on,
              title: 'Flashcard',
              subtitle: 'Aralıklı Tekrar',
              color: const Color(0xFFE30A17),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FlashcardScreen()),
              ).then((_) => _refreshUserData()),
            ),
            const SizedBox(width: 10),
            _buildActionTile(
              icon: Icons.bookmark_remove,
              title: 'Yanlış Defteri',
              subtitle: '${StorageService.getWrongNotebookQuestions().length} Soru',
              color: const Color(0xFF002366),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const YanlisDefteriScreen()),
              ).then((_) => _refreshUserData()),
            ),
            const SizedBox(width: 10),
            _buildActionTile(
              icon: Icons.menu_book,
              title: 'Konu Anlatımı',
              subtitle: 'Püf Noktalar',
              color: const Color(0xFF0A3D91),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KonuAnlatimiScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // 2. Satır: Başarımlar, Stres Yönetimi ve Sertifika
        Row(
          children: [
            _buildActionTile(
              icon: Icons.military_tech,
              title: 'Başarımlar',
              subtitle: 'Rozetler & İl',
              color: Colors.amber.shade800,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BasarimlarScreen()),
              ).then((_) => _refreshUserData()),
            ),
            const SizedBox(width: 10),
            _buildActionTile(
              icon: Icons.self_improvement,
              title: 'Sınav Stresi',
              subtitle: '4-7-8 Nefes',
              color: Colors.teal.shade700,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StresYonetimiScreen()),
              ),
            ),
            const SizedBox(width: 10),
            _buildActionTile(
              icon: Icons.workspace_premium,
              title: 'Sertifikam',
              subtitle: 'Paylaş & Kanıtla',
              color: const Color(0xFF2E7D32),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SertifikaPaylasimiScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> cat) {
    final color = Color(cat['color'] as int);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(cat['icon'] as IconData, color: color, size: 28),
        ),
        title: Text(
          cat['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(cat['sub'] as String, style: const TextStyle(fontSize: 12)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizScreen(
                category: cat['id'] as String,
                categoryTitle: cat['title'] as String,
              ),
            ),
          ).then((_) => _refreshUserData());
        },
      ),
    );
  }

  Widget _buildCommunityBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌟 Topluluk & Fırsat Eşitliği Hareketi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OkulElcisiScreen()),
                  ),
                  icon: const Icon(Icons.school, size: 18),
                  label: const Text('Okul Elçisi'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const IlKoordinatoruScreen()),
                  ),
                  icon: const Icon(Icons.location_city, size: 18),
                  label: const Text('81 İl Sıralaması'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KatkiYarismasiScreen()),
              ),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Soru Katkı Yarışması (+100 XP)'),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// 2. QUIZ EKRANI (İnteraktif Soru Çözümü)
/// ============================================================================
class QuizScreen extends StatefulWidget {
  final String category;
  final String categoryTitle;

  const QuizScreen({
    super.key,
    required this.category,
    required this.categoryTitle,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int? _selectedOption;
  bool _isAnswered = false;
  int _correctCount = 0;
  int _wrongCount = 0;

  bool _allQuestionsAlreadySolved = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    // "Aynı soru asla iki kez gelmesin": Kullanıcının daha önce çözmediği soruları getir
    final list = StorageService.getUnsolvedQuestionsByCategory(widget.category);
    if (list.isNotEmpty) {
      setState(() {
        _questions = list;
        _allQuestionsAlreadySolved = false;
      });
    } else {
      final totalCatQuestions = StorageService.getQuestionsByCategory(widget.category);
      setState(() {
        _questions = [];
        _allQuestionsAlreadySolved = totalCatQuestions.isNotEmpty;
      });
    }
  }

  void _selectOption(int index) {
    if (_isAnswered) return;

    final currentQuestion = _questions[_currentIndex];
    final isCorrect = index == currentQuestion.correctIndex;

    setState(() {
      _selectedOption = index;
      _isAnswered = true;
      if (isCorrect) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
    });

    StorageService.recordQuestionSolved(
      questionId: currentQuestion.id,
      isCorrect: isCorrect,
      selectedIndex: index,
    );

    // Her 5 soruda bir geçiş reklamı (AdMob Interstitial)
    AdService.showInterstitialIfReady();
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isAnswered = false;
      });
    } else {
      _showQuizSummary();
    }
  }

  void _showQuizSummary() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Test Tamamlandı! 🎉'),
        content: Text(
          'Tebrikler!\n\nDoğru: $_correctCount\nYanlış: $_wrongCount\nKazanılan XP: +${_correctCount * 20}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Ana Sayfaya Dön'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryTitle),
          backgroundColor: const Color(0xFF002366),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _allQuestionsAlreadySolved ? Icons.check_circle_outline : Icons.inbox,
                  size: 72,
                  color: _allQuestionsAlreadySolved ? const Color(0xFF1B5E20) : Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  _allQuestionsAlreadySolved
                      ? 'Harika! Tüm Soruları Tamamladın! 🏆'
                      : 'Bu kategoride henüz soru bulunmuyor.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  _allQuestionsAlreadySolved
                      ? 'Soru tekrarı engelleme (SHA-256) kuralı gereği aynı soru asla iki kez karşına çıkmaz. Sistem arka planda otomatik yeni soru taramaktadır.'
                      : 'Sistem kamuya açık kaynaklardan yeni soruları otomatik olarak senkronize etmektedir.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                if (_allQuestionsAlreadySolved) ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Kategoriyi Sıfırla ve Yeniden Başla'),
                    onPressed: () async {
                      await StorageService.resetSolvedQuestionsForCategory(widget.category);
                      _loadQuestions();
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ana Sayfaya Dön'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} (${_currentIndex + 1}/${_questions.length})'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Soru Üst Bilgisi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text('${q.subject} • ${q.year}')),
                Chip(
                  backgroundColor: const Color(0xFFE30A17).withOpacity(0.1),
                  label: Text(
                    q.source,
                    style: const TextStyle(color: Color(0xFFE30A17), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Soru Metni
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Text(
                q.questionText,
                style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),

            // Şıklar
            ...List.generate(q.options.length, (index) {
              Color cardColor = Colors.white;
              Color borderColor = Colors.grey.shade300;

              if (_isAnswered) {
                if (index == q.correctIndex) {
                  cardColor = Colors.green.shade50;
                  borderColor = Colors.green;
                } else if (_selectedOption == index) {
                  cardColor = Colors.red.shade50;
                  borderColor = Colors.red;
                }
              }

              return Card(
                color: cardColor,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: borderColor),
                ),
                child: InkWell(
                  onTap: () => _selectOption(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            q.options[index],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        if (_isAnswered && index == q.correctIndex)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (_isAnswered && _selectedOption == index && index != q.correctIndex)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Çözüm Açıklaması
            if (_isAnswered) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF002366).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF002366).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: Color(0xFF002366), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Çözüm Açıklaması',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF002366),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(q.explanation, style: const TextStyle(fontSize: 13, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _nextQuestion,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(_currentIndex < _questions.length - 1 ? 'Sonraki Soru' : 'Testi Bitir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// 3. FLASHCARD EKRANI (SM-2 Spaced Repetition Aralıklı Tekrar)
/// ============================================================================
class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<QuestionModel> _cards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    final list = StorageService.getDueFlashcards();
    setState(() {
      _cards = list.isNotEmpty ? list : StorageService.questionBox.values.take(10).toList();
    });
  }

  void _rateCard(int quality) async {
    final card = _cards[_currentIndex];
    await StorageService.recordFlashcardReview(card.id, quality);

    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tebrikler!'),
            content: const Text('Bugünkü SM-2 aralıklı tekrar seansınızı tamamladınız!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flashcard Tekrar')),
        body: const Center(child: Text('Tekrar edilecek kart bulunamadı.')),
      );
    }

    final card = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Aralıklı Tekrar (SM-2) • ${_currentIndex + 1}/${_cards.length}'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF002366).withOpacity(0.3), width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showAnswer ? 'ÇÖZÜM & AÇIKLAMA' : 'SORU (${card.subject})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: _showAnswer ? Colors.green : const Color(0xFFE30A17),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _showAnswer ? card.explanation : card.questionText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17, height: 1.6),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _showAnswer ? 'Doğru Cevap: ${card.options[card.correctIndex]}' : 'Cevabı görmek için karta dokun',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _showAnswer ? const Color(0xFF002366) : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // SM-2 Kalite Puanlama Butonları
            if (_showAnswer) ...[
              const Text('Hatırlama Derecenizi Seçin (SM-2):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rateCard(1),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Zor (1 Gün)', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rateCard(3),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Orta (3 Gün)', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rateCard(5),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Kolay (6+ Gün)', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// 4. YANLIŞ DEFTERİ EKRANI
/// ============================================================================
class YanlisDefteriScreen extends StatelessWidget {
  const YanlisDefteriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = StorageService.getWrongNotebookQuestions();

    return Scaffold(
      appBar: AppBar(
        title: Text('Yanlış Defteri (${list.length})'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: list.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Harika gidiyorsun! Yanlış yaptığın soru bulunmuyor.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final q = list[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${q.subject} • ${q.subCategory}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE30A17)),
                        ),
                        const SizedBox(height: 8),
                        Text(q.questionText, style: const TextStyle(fontSize: 15)),
                        const Divider(height: 24),
                        Text(
                          'Çözüm: ${q.explanation}',
                          style: const TextStyle(color: Colors.black87, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// ============================================================================
/// 5. KONU ANLATIMI EKRANI (Hızlı & Püf Noktalı Özetler)
/// ============================================================================
class KonuAnlatimiScreen extends StatefulWidget {
  const KonuAnlatimiScreen({super.key});

  @override
  State<KonuAnlatimiScreen> createState() => _KonuAnlatimiScreenState();
}

class _KonuAnlatimiScreenState extends State<KonuAnlatimiScreen> {
  String _selectedCategory = 'lise';

  final Map<String, List<Map<String, String>>> _notes = {
    'ortaokul': [
      {
        'title': 'LGS Türkçe - Cümlede Anlam & Fiilimsiler',
        'subject': 'Türkçe',
        'content': '• İsim-fiil (-ma, -ış, -mak): "Kitap okumak zihni açar."\n• Sıfat-fiil (-an, -ası, -mez, -ar, -dik, -ecek, -miş): "Görünen köy kılavuz istemez."\n• Zarf-fiil (-ken, -alı, -esiye, -meden, -ince, -ip, -arak): "Gülerek yanıma geldi."\n💡 Püf Nokta: Fiilimsiler fiil çekim eki almazlar, cümlede yan cümlecik kurarlar.',
      },
      {
        'title': 'LGS Matematik - EBOB & EKOK',
        'subject': 'Matematik',
        'content': '• EBOB (En Büyük Ortak Bölen): Parçalama, bölüştürme, şişeleme, eşit aralıklarla ağaç dikme sorularında kullanılır.\n• EKOK (En Küçük Ortak Kat): Birleştirme, ceviz/bilye sayma, nöbet tutma, zil çalma sorularında kullanılır.\n💡 Kural: İki sayının çarpımı, bu sayıların EBOB ve EKOK çarpımlarına eşittir: a * b = EBOB(a,b) * EKOK(a,b).',
      },
    ],
    'lise': [
      {
        'title': 'TYT Matematik - Fonksiyonlar & Püf Noktaları',
        'subject': 'Matematik',
        'content': '• Birebir Fonksiyon: Tanım kümesindeki her elemanın görüntüsü farklıdır.\n• Örten Fonksiyon: Değer kümesinde açıkta eleman kalmaz (Görüntü = Değer kümesi).\n• Bileşke Fonksiyon: (f o g)(x) = f(g(x)). Fonksiyonu diğerinin içine yerleştirin.\n• Ters Fonksiyon: f(x) = (ax + b) / (cx + d) ise f⁻¹(x) = (-dx + b) / (cx - a).',
      },
      {
        'title': 'TYT Fizik - Newton\'un Hareket Yasaları',
        'subject': 'Fizik',
        'content': '1. Eylemsizlik Prensibi: Cisme etkiyen net kuvvet sıfırsa (F_net = 0), cisim duruyorsa durur, hareketliyse sabit hızla devam eder.\n2. Temel Prensip: F_net = m * a. Net kuvvet kütle ile ivmenin çarpımıdır.\n3. Etki-Tepki: Her etkiye karşılık eşit büyüklükte ve zıt yönde bir tepki kuvveti vardır.',
      },
    ],
    'universite': [
      {
        'title': 'KPSS Tarih - Milli Mücadele Genelgeler Kronolojisi',
        'subject': 'Tarih',
        'content': '1. Havza Genelgesi (1919): İşgallere karşı ilk kitlesel mitingler düzenlendi.\n2. Amasya Genelgesi: Kurtuluş Savaşı\'nın amaç, gerekçe ve yöntemi ilk kez belirlendi.\n3. Erzurum Kongresi: Manda ve himaye ilk kez reddedildi, Misak-ı Milli sınırları çizildi.\n4. Sivas Kongresi: Tüm cemiyetler tek çatı altında (ARMHC) toplandı.',
      },
      {
        'title': 'KPSS Vatandaşlık - Temel Hak ve Hürriyetler',
        'subject': 'Vatandaşlık',
        'content': '• Kişi Hak ve Ödevleri (Koruyucu / Negatif statü hakları): Yaşama hakkı, kişi hürriyeti, konut dokunulmazlığı.\n• Sosyal ve Ekonomik Haklar (İsteme / Pozitif statü): Eğitim hakkı, sağlık hakkı, çalışma hakkı.\n• Siyasi Haklar (Katılma / Aktif statü): Seçme ve seçilme, kamu hizmetine girme, dilekçe hakkı.',
      },
    ],
    'ehliyet': [
      {
        'title': 'Ehliyet Sınavı - İlk Yardım Temel Yaşam Desteği (CAB)',
        'subject': 'İlk Yardım',
        'content': '• C (Circulation - Dolaşım): Kalp masajı (Dakikada 100-120 bası, 5 cm çökme, 30 bası).\n• A (Airway - Hava Yolu): Baş geri-çene yukarı pozisyonu ile hava yolu açılır.\n• B (Breathing - Solunum): Bak-dinle-hisset (10 saniye), 2 suni solunum verilir.\n💡 Oran: 30 Kalp Masajı : 2 Suni Solunum.',
      },
      {
        'title': 'Ehliyet Sınavı - Geçiş Üstünlüğü ve Kavşak Kuralları',
        'subject': 'Trafik',
        'content': '1. Cankurtaran (Ambulans) ve organ nakil araçları.\n2. İtfaiye ve orman yangın araçları.\n3. Polis, jandarma ve zabıta araçları.\n4. Kar ve buzla mücadele araçları.\n💡 Kontrolsüz kavşakta soldaki araç, sağdaki araca geçiş hakkı vermek zorundadır.',
      },
    ],
    'acikogretim': [
      {
        'title': 'AÖF - Hukukun Temel Kavramları',
        'subject': 'Hukuk',
        'content': '• Normlar Hiyerarşisi: Anayasa > Kanun & Milletlerarası Antlaşmalar > CB Kararnameleri > Yönetmelikler.\n• Butlan: Kurucu unsurları tam olan bir işlemin geçerlilik şartlarındaki sakatlık nedeniyle hükümsüz kalması.\n• Yokluk: İşlemin kurucu unsurlarından birinin eksik olması (Örn: Yetkili memur önünde yapılmayan evlilik).',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentNotes = _notes[_selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konu Anlatımı & Özetler'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Kategori Seçici Tab Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab('ortaokul', 'Ortaokul LGS'),
                  const SizedBox(width: 8),
                  _buildTab('lise', 'Lise TYT/AYT'),
                  const SizedBox(width: 8),
                  _buildTab('universite', 'Üniversite KPSS'),
                  const SizedBox(width: 8),
                  _buildTab('ehliyet', 'MEB Ehliyet'),
                  const SizedBox(width: 8),
                  _buildTab('acikogretim', 'Açık Öğretim'),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Özet Kartları Listesi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                final note = currentNotes[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF002366).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                note['subject']!,
                                style: const TextStyle(
                                  color: Color(0xFF002366),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          note['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF002366),
                          ),
                        ),
                        const Divider(height: 20),
                        Text(
                          note['content']!,
                          style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String id, String label) {
    final isSelected = _selectedCategory == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedCategory = id);
      },
      selectedColor: const Color(0xFF002366),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

/// ============================================================================
/// 6. BAŞARIMLAR & LİDERLİK TABLOSU EKRANI
/// ============================================================================
class BasarimlarScreen extends StatelessWidget {
  const BasarimlarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = StorageService.getCurrentUser();
    final awards = StorageService.awardsBox.values.toList();

    // 81 İl Liderlik Tablosu Verisi
    final cityLeaderboard = [
      {'city': 'Ankara', 'code': '06', 'xp': '2.450.120', 'rank': 1, 'badge': '🥇'},
      {'city': 'İstanbul', 'code': '34', 'xp': '2.190.840', 'rank': 2, 'badge': '🥈'},
      {'city': 'İzmir', 'code': '35', 'xp': '1.870.300', 'rank': 3, 'badge': '🥉'},
      {'city': 'Bursa', 'code': '16', 'xp': '1.420.900', 'rank': 4, 'badge': '4'},
      {'city': 'Antalya', 'code': '07', 'xp': '1.280.450', 'rank': 5, 'badge': '5'},
      {'city': 'Konya', 'code': '42', 'xp': '1.150.200', 'rank': 6, 'badge': '6'},
      {'city': 'Adana', 'code': '01', 'xp': '980.700', 'rank': 7, 'badge': '7'},
      {'city': 'Eskişehir', 'code': '26', 'xp': '940.100', 'rank': 8, 'badge': '8'},
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Başarımlar & Sıralama'),
          backgroundColor: const Color(0xFF002366),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Color(0xFFE30A17),
            tabs: [
              Tab(icon: Icon(Icons.military_tech), text: 'Rozetlerim'),
              Tab(icon: Icon(Icons.leaderboard), text: 'İl Sıralaması'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Rozetler
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Kullanıcı Durum Özeti
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF002366), Color(0xFF0A3D91)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Toplam XP', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${user.xp}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Seviye', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('Lvl ${user.level}', style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Açılan Rozet', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${awards.where((a) => a.isUnlocked || user.xp >= a.requiredXp).length}/${awards.length}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Rozet Kartları
                ...awards.map((award) {
                  final isUnlocked = award.isUnlocked || user.xp >= award.requiredXp;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isUnlocked ? const Color(0xFF002366) : Colors.grey.shade300,
                        foregroundColor: isUnlocked ? Colors.amber : Colors.grey.shade600,
                        radius: 24,
                        child: Icon(
                          isUnlocked ? Icons.verified : Icons.lock,
                          size: 26,
                        ),
                      ),
                      title: Text(
                        award.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? const Color(0xFF002366) : Colors.grey,
                        ),
                      ),
                      subtitle: Text(award.description),
                      trailing: Text(
                        '${award.requiredXp} XP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),

            // Tab 2: İl Sıralaması
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cityLeaderboard.length,
              itemBuilder: (context, index) {
                final row = cityLeaderboard[index];
                final isUserCity = row['city'] == user.cityName;

                return Card(
                  color: isUserCity ? const Color(0xFF002366).withOpacity(0.05) : Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isUserCity
                        ? const BorderSide(color: Color(0xFF002366), width: 1.5)
                        : BorderSide.none,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: index < 3 ? const Color(0xFFE30A17) : Colors.grey.shade200,
                      foregroundColor: index < 3 ? Colors.white : Colors.black87,
                      child: Text('${row['badge']}'),
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${row['city']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (isUserCity) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF002366),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Senin İlin', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text('Plaka: ${row['code']} • Çözülen Puan'),
                    trailing: Text(
                      '${row['xp']} XP',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF002366)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// 7. KATEGORİLER EKRANI (Tüm Sınav Kataloğu)
/// ============================================================================
class KategorilerScreen extends StatelessWidget {
  const KategorilerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'Ortaokul & LGS',
        'sub': '5, 6, 7, 8. Sınıf & LGS Çıkmış ve Örnek Sorular',
        'id': 'ortaokul',
        'icon': Icons.menu_book,
        'color': 0xFF002366,
      },
      {
        'title': 'Lise & YKS (TYT - AYT)',
        'sub': 'TYT, AYT, YDT ve 9, 10, 11, 12. Sınıf Müfredatı',
        'id': 'lise',
        'icon': Icons.school,
        'color': 0xFFE30A17,
      },
      {
        'title': 'Üniversite & KPSS',
        'sub': 'KPSS Lisans, Önlisans, Ortaöğretim, ALES, DGS',
        'id': 'universite',
        'icon': Icons.account_balance,
        'color': 0xFF0A3D91,
      },
      {
        'title': 'MEB Ehliyet Sınavı',
        'sub': 'Trafik, İlk Yardım, Motor ve Çevre Bilgisi',
        'id': 'ehliyet',
        'icon': Icons.directions_car,
        'color': 0xFF2E7D32,
      },
      {
        'title': 'Açık Öğretim (AÖF & AÖL)',
        'sub': 'Açık Lise ve Anadolu/Atatürk Üniversitesi AÖF',
        'id': 'acikogretim',
        'icon': Icons.import_contacts,
        'color': 0xFFE65100,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav Kategorileri'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final color = Color(cat['color'] as int);

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.12),
                foregroundColor: color,
                radius: 26,
                child: Icon(cat['icon'] as IconData, size: 28),
              ),
              title: Text(
                cat['title'] as String,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
              ),
              subtitle: Text(cat['sub'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      category: cat['id'] as String,
                      categoryTitle: cat['title'] as String,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

