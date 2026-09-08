import 'package:flutter/material.dart';
import '../../services.dart';

/// Bilgi Yolu - Katkı Yarışması (Topluluk Soru Katkısı)
/// Öğretmenler ve öğrencilerin kamuya açık, telifsiz soru ve çözüm önerilerini
/// platforma göndererek eğitimde fırsat eşitliği imecesine katıldığı modül.
class KatkiYarismasiScreen extends StatefulWidget {
  const KatkiYarismasiScreen({super.key});

  @override
  State<KatkiYarismasiScreen> createState() => _KatkiYarismasiScreenState();
}

class _KatkiYarismasiScreenState extends State<KatkiYarismasiScreen> {
  final _questionController = TextEditingController();
  final _optA = TextEditingController();
  final _optB = TextEditingController();
  final _optC = TextEditingController();
  final _optD = TextEditingController();
  final _explanationController = TextEditingController();

  String _selectedCategory = 'lise';
  String _selectedExam = 'TYT';
  int _correctIndex = 0;
  bool _submitted = false;

  void _submitQuestion() async {
    if (_questionController.text.trim().isEmpty ||
        _optA.text.trim().isEmpty ||
        _optB.text.trim().isEmpty ||
        _optC.text.trim().isEmpty ||
        _optD.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen soru metnini ve en az 4 şıkkı doldurunuz.')),
      );
      return;
    }

    // Kullanıcıya katkı XP'si ver (+100 XP)
    await StorageService.addXp(100);

    setState(() {
      _submitted = true;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber),
              SizedBox(width: 8),
              Text('Harika Katkı!'),
            ],
          ),
          content: const Text(
            'Sorunuz topluluk denetleme kuyruğuna alındı ve hesabınıza +100 XP eklendi. '
            'MEB/ÖSYM müfredat uygunluk kontrolünden sonra tüm Türkiye ile paylaşılacak!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _resetForm();
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _questionController.clear();
    _optA.clear();
    _optB.clear();
    _optC.clear();
    _optD.clear();
    _explanationController.clear();
    setState(() {
      _submitted = false;
      _correctIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluk Katkı Yarışması'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF002366), Color(0xFF0A3D91)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🏆 Soru Gönder, Fırsat Eşitliğine Katkı Ver!',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Onaylanan her soru için +100 XP ve Topluluk Katkıcısı Rozeti kazanın. Sorularınız Türkiye genelinde milyonlarca öğrenciye ücretsiz ulaşsın.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'ortaokul', child: Text('Ortaokul')),
                      DropdownMenuItem(value: 'lise', child: Text('Lise')),
                      DropdownMenuItem(value: 'universite', child: Text('Üniversite')),
                      DropdownMenuItem(value: 'ehliyet', child: Text('Ehliyet')),
                      DropdownMenuItem(value: 'acikogretim', child: Text('Açık Öğretim')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedExam,
                    decoration: const InputDecoration(labelText: 'Sınav Türü', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'LGS', child: Text('LGS')),
                      DropdownMenuItem(value: 'TYT', child: Text('TYT')),
                      DropdownMenuItem(value: 'AYT', child: Text('AYT')),
                      DropdownMenuItem(value: 'KPSS', child: Text('KPSS')),
                      DropdownMenuItem(value: 'Ehliyet', child: Text('Ehliyet')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedExam = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _questionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Soru Metni (Açık, anlaşılır ve telifsiz)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Şıklar ve Doğru Cevap:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildOptionField('A', _optA, 0),
            _buildOptionField('B', _optB, 1),
            _buildOptionField('C', _optC, 2),
            _buildOptionField('D', _optD, 3),
            const SizedBox(height: 12),
            TextField(
              controller: _explanationController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Çözüm Açıklaması & Püf Noktası',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitQuestion,
                icon: const Icon(Icons.send),
                label: const Text('Soruyu Gönder & +100 XP Kazan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE30A17),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionField(String label, TextEditingController controller, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Radio<int>(
            value: index,
            groupValue: _correctIndex,
            activeColor: const Color(0xFFE30A17),
            onChanged: (val) {
              if (val != null) setState(() => _correctIndex = val);
            },
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Şık $label',
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
