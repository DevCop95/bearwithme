import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../services/report_service.dart';

class ProfileSummaryView extends StatelessWidget {
  const ProfileSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis Clínico', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(LucideIcons.download, color: AppTheme.primaryBlue),
              onPressed: () {
                ReportService.generateClinicalReport(
                  userName: 'Paciente #2024-A',
                  personality: 'Mediador (INFP)',
                  distortions: ['Ansiedad Social', 'Catastrofismo', 'Pensamiento Todo o Nada'],
                  averageMood: 0.7,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 32),
            _SectionTitle(icon: LucideIcons.activity, title: 'Bienestar Emocional'),
            const SizedBox(height: 16),
            const _EmotionChartMock(),
            const SizedBox(height: 32),
            _SectionTitle(icon: LucideIcons.tag, title: 'Patrones Detectados'),
            const SizedBox(height: 16),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Tag(label: 'Ansiedad Social', color: AppTheme.primaryBlue, icon: LucideIcons.users),
                _Tag(label: 'Autoestima', color: AppTheme.primaryGreen, icon: LucideIcons.heart),
                _Tag(label: 'Relaciones', color: Colors.orangeAccent, icon: LucideIcons.home),
              ],
            ),
            const SizedBox(height: 32),
            _SectionTitle(icon: LucideIcons.clipboardList, title: 'Notas del Guía'),
            const SizedBox(height: 16),
            const _SessionNotes(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryBlue),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(LucideIcons.user, size: 40, color: AppTheme.primaryBlue),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paciente #2024-A', style: Theme.of(context).textTheme.titleLarge),
                const Text('Mediador (INFP)', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 14, color: AppTheme.textLight),
                    const SizedBox(width: 4),
                    const Text('Sesión: Hoy, 10:30 AM', style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _Tag({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 14, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
    );
  }
}

class _EmotionChartMock extends StatelessWidget {
  const _EmotionChartMock();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        height: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (index) {
            final height = [40.0, 60.0, 90.0, 50.0, 80.0, 110.0, 70.0][index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 12,
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withOpacity(0.3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8),
                Text(['L', 'M', 'X', 'J', 'V', 'S', 'D'][index], style: const TextStyle(fontSize: 10, color: AppTheme.textLight)),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _SessionNotes extends StatelessWidget {
  const _SessionNotes();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.brain, size: 18, color: AppTheme.accentPurple),
                const SizedBox(width: 8),
                const Text('Análisis IA', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentPurple)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'El usuario muestra signos de distorsión cognitiva (catastrofismo) al hablar de su entorno laboral. Se recomienda profundizar en la reestructuración cognitiva.',
              style: TextStyle(color: AppTheme.textDark, height: 1.6, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
