import 'dart:async';
import 'package:flutter/material.dart';

/// Bilgi Yolu - Sınav Öncesi Stres Yönetimi ve 4-7-8 Nefes Egzersizi
/// Öğrencilerin sınav kaygısını ve stresini bilimsel nefes teknikleriyle
/// yatıştırmak üzere tasarlanmış ücretsiz sağlık modülü.
class StresYonetimiScreen extends StatefulWidget {
  const StresYonetimiScreen({super.key});

  @override
  State<StresYonetimiScreen> createState() => _StresYonetimiScreenState();
}

class _StresYonetimiScreenState extends State<StresYonetimiScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Timer? _countdownTimer;

  String _breathPhase = 'Hazır mısın?';
  int _secondsLeft = 4;
  bool _isRunning = false;
  int _completedCycles = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  void _startBreathingCycle() {
    setState(() {
      _isRunning = true;
      _completedCycles = 0;
    });
    _runPhase(phase: 'Nefes Al', durationSeconds: 4, next: () {
      _runPhase(phase: 'Nefesini Tut', durationSeconds: 7, next: () {
        _runPhase(phase: 'Yavaşça Ver', durationSeconds: 8, next: () {
          setState(() {
            _completedCycles++;
          });
          if (_isRunning) {
            _startBreathingCycle(); // Yeni döngü
          }
        });
      });
    });
  }

  void _runPhase({
    required String phase,
    required int durationSeconds,
    required VoidCallback next,
  }) {
    if (!_isRunning) return;

    setState(() {
      _breathPhase = phase;
      _secondsLeft = durationSeconds;
    });

    if (phase == 'Nefes Al') {
      _animController.duration = Duration(seconds: durationSeconds);
      _animController.forward(from: 0.0);
    } else if (phase == 'Yavaşça Ver') {
      _animController.duration = Duration(seconds: durationSeconds);
      _animController.reverse(from: 1.0);
    }

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isRunning) {
        t.cancel();
        return;
      }
      setState(() {
        _secondsLeft--;
      });
      if (_secondsLeft <= 0) {
        t.cancel();
        next();
      }
    });
  }

  void _stopBreathing() {
    _countdownTimer?.cancel();
    _animController.stop();
    setState(() {
      _isRunning = false;
      _breathPhase = 'Harika bir mola verdin!';
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav Kaygısı & Stres Yönetimi'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '4-7-8 Bilimsel Nefes Tekniği',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002366),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Parasempatik sinir sistemini uyararak kalp atışını dengeler, zihni sakinleştirir ve sınav öncesi odaklanmayı artırır.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 36),

              // Ritmik Genişleyen Nefes Halkası
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final scale = 1.0 + (_animController.value * 0.35);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF002366).withOpacity(0.8),
                            const Color(0xFFE30A17).withOpacity(0.9),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002366).withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _breathPhase,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_isRunning) ...[
                              const SizedBox(height: 8),
                              Text(
                                '$_secondsLeft sn',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),
              Text(
                'Tamamlanan Döngü: $_completedCycles',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: 240,
                child: ElevatedButton.icon(
                  onPressed: _isRunning ? _stopBreathing : _startBreathingCycle,
                  icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(_isRunning ? 'Durdur' : 'Egzersize Başla'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? const Color(0xFFE30A17) : const Color(0xFF002366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
