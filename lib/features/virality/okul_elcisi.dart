import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../services.dart';

/// Bilgi Yolu - Okul Elçisi Modülü
/// Öğrencilerin kendi liselerinde/ortaokullarında Bilgi Yolu'nu yayarak
/// eğitimde fırsat eşitliği sağlamasını teşvik eden virality programı.
class OkulElcisiScreen extends StatefulWidget {
  const OkulElcisiScreen({super.key});

  @override
  State<OkulElcisiScreen> createState() => _OkulElcisiScreenState();
}

class _OkulElcisiScreenState extends State<OkulElcisiScreen> {
  final _schoolController = TextEditingController();
  bool _isApplied = false;

  @override
  void initState() {
    super.initState();
    final user = StorageService.getCurrentUser();
    _isApplied = user.isSchoolAmbassador;
    if (user.schoolName != null) {
      _schoolController.text = user.schoolName!;
    }
  }

  void _submitApplication() async {
    if (_schoolController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen okulunuzun adını giriniz.')),
      );
      return;
    }

    final user = StorageService.getCurrentUser();
    user.isSchoolAmbassador = true;
    user.schoolName = _schoolController.text.trim();
    user.totalXp += 150; // Elçilik unvanı hediyesi
    await StorageService.saveUser(user);

    setState(() {
      _isApplied = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tebrikler! Okul Elçisi unvanınız aktifleştirildi (+150 XP).'),
          backgroundColor: Color(0xFF002366),
        ),
      );
    }
  }

  void _shareSchoolInvite() {
    final school = _schoolController.text.isNotEmpty ? _schoolController.text : 'okulumuz';
    final shareText = '''
🎓 Merhaba arkadaşlar!
$school öğrencileri için %100 ÜCRETSİZ sınav hazırlık platformu Bilgi Yolu'na ben de katıldım!

✨ LGS, TYT-AYT, KPSS ve Ehliyet sınavlarına kota olmadan, hiçbir ücret ödemeden hazırlanıyoruz.
📲 Hemen indir ve okul elçimiz olarak aramıza katıl:
https://bilgiyolu.app/indir

#EğitimdeFırsatEşitliği #BilgiYolu
''';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Okul Elçisi Programı'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF002366).withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF002366).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.school, size: 48, color: Color(0xFF002366)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Eğitimde Fırsat Eşitliği',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF002366),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Okulundaki tüm arkadaşlarına ücretsiz sınav hazırlığını ulaştır, rozet ve liderlik puanları kazan!',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Okulunuzu Temsil Edin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _schoolController,
              decoration: const InputDecoration(
                labelText: 'Okulunuzun Adı (Örn: Atatürk Anadolu Lisesi)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.apartment),
              ),
            ),
            const SizedBox(height: 16),
            if (!_isApplied)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitApplication,
                  icon: const Icon(Icons.verified),
                  label: const Text('Okul Elçisi Ol (+150 XP)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE30A17),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              )
            else
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Resmi Okul Elçisisiniz! Arkadaşlarınızla paylaşarak okulunuzu il sıralamasında zirveye taşıyın.',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _shareSchoolInvite,
                      icon: const Icon(Icons.share),
                      label: const Text('Okul Davet Linkini Paylaş'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
