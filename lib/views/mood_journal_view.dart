import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/dynamic_background.dart';
import '../theme/app_theme.dart';
import '../widgets/lume_avatar.dart';
import '../services/session_service.dart';

class MoodJournalView extends StatefulWidget {
  const MoodJournalView({super.key});

  @override
  State<MoodJournalView> createState() => _MoodJournalViewState();
}

class _MoodJournalViewState extends State<MoodJournalView> {
  double _currentMood = 0.5;
  final TextEditingController _noteController = TextEditingController();

  Future<void> _safeVibrate({int duration = 10, List<int>? pattern, int amplitude = -1}) async {
    if (await Vibration.hasVibrator() ?? false) {
      if (pattern != null) {
        Vibration.vibrate(pattern: pattern);
      } else {
        Vibration.vibrate(duration: duration, amplitude: amplitude);
      }
    }
  }

  void _onMoodChanged(double value) {
    setState(() => _currentMood = value);
    _safeVibrate(duration: 15, amplitude: 50);
  }

  String _getLottieUrl() {
    if (_currentMood <= 0.2) return 'https://lottie.host/7e04f981-2292-4114-934c-687f46571583/eYc9vO6NfL.json';
    if (_currentMood <= 0.4) return 'https://lottie.host/4694a974-9842-4f11-9257-8977464047a0/GAsA3K8W0k.json';
    if (_currentMood <= 0.6) return 'https://lottie.host/809c9520-2f3b-4171-884d-262176461b47/vG8f0vP8vR.json';
    if (_currentMood <= 0.8) return 'https://lottie.host/21966219-066e-4f32-8418-490b41140068/3G0XvP9vW1.json';
    return 'https://lottie.host/7686666c-890d-404b-994a-94166e323343/9vXvXvXvXv.json';
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Diario de Ánimo', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              FadeInDown(
                child: SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Lottie.network(
                          _getLottieUrl(),
                          key: ValueKey(_getLottieUrl()),
                          fit: BoxFit.contain,
                          height: 300,
                          errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.cloudSun, size: 100, color: Colors.white24),
                        ),
                      ),
                      LumeAvatar(moodScore: _currentMood, size: 280),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ZoomIn(
                key: ValueKey(_currentMood),
                child: Text(
                  _getMoodLabel(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.textDark, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.1), blurRadius: 30)],
                  ),
                  child: Column(
                    children: [
                      const Text('¿Cómo describirías tu energía hoy?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 24),
                      Slider(
                        value: _currentMood,
                        min: 0.0,
                        max: 1.0,
                        divisions: 4,
                        onChanged: _onMoodChanged,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _MoodIndicator(label: 'Baja', color: Colors.blueGrey),
                          _MoodIndicator(label: 'Calma', color: AppTheme.primaryBlue),
                          _MoodIndicator(label: 'Alta', color: Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Cuéntale a tu diario...',
                    prefixIcon: const Icon(LucideIcons.penTool, size: 18),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Guardar en Memoria Global
                    SessionService().updateMood(_currentMood, _noteController.text);
                    _safeVibrate(pattern: [0, 50, 100, 50]);
                    _showSuccess();
                  },
                  icon: const Icon(LucideIcons.save),
                  label: const Text('Registrar Bienestar'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 65)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMoodLabel() {
    if (_currentMood <= 0.2) return 'Tormentoso';
    if (_currentMood <= 0.4) return 'Lluvioso';
    if (_currentMood <= 0.6) return 'Nublado';
    if (_currentMood <= 0.8) return 'Radiante';
    return '¡Extraordinario!';
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.network(
              'https://lottie.host/7686666c-890d-404b-994a-94166e323343/9vXvXvXvXv.json',
              height: 150,
              repeat: false,
              errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.checkCircle, size: 80, color: AppTheme.primaryGreen),
            ),
            const Text('¡Registrado!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Tu estado emocional ha sido guardado con éxito.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Genial')),
          ],
        ),
      ),
    );
  }
}

class _MoodIndicator extends StatelessWidget {
  final String label;
  final Color color;
  const _MoodIndicator({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color));
  }
}
