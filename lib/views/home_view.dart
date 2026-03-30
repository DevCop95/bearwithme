import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../widgets/dynamic_background.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _personalityType;
  String? _cognitiveBias;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args.containsKey('personalityType')) _personalityType = args['personalityType'];
      if (args.containsKey('cognitiveBias')) _cognitiveBias = args['cognitiveBias'];
    }

    return DynamicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Mi Espacio', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.logOut, color: AppTheme.textLight),
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  _personalityType != null 
                    ? 'Hola, $_personalityType' 
                    : 'Hola, ¿cómo estás?',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
              ),
              const SizedBox(height: 8),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'Tu centro de bienestar psicológico está listo.',
                  style: TextStyle(fontSize: 16, color: AppTheme.textLight),
                ),
              ),
              
              if (_cognitiveBias != null) ...[
                const SizedBox(height: 16),
                FadeInRight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.brainCircuit, size: 16, color: AppTheme.primaryBlue),
                        const SizedBox(width: 8),
                        Text('Estado actual: $_cognitiveBias', style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),
              _buildMainGrid(context),
              const SizedBox(height: 32),
              
              // Reporte Clínico con icono y animación propia
              _buildFeaturedCardWithLottie(
                context,
                title: 'Tu Reporte Clínico',
                subtitle: 'Revisa tus progresos y patrones detectados.',
                lottieUrl: 'https://lottie.host/1c4c892b-870a-426c-851f-273523f66863/8iGvXvP8vR.json', // Gráficos de barras
                fallbackIcon: LucideIcons.barChart,
                color: AppTheme.accentPurple,
                route: '/profile-summary',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.82,
      children: [
        _MenuCard(
          title: 'Guía Emocional',
          description: 'Conversa con tu IA.',
          lottieUrl: 'https://lottie.host/809c9520-2f3b-4171-884d-262176461b47/vG8f0vP8vR.json', // Chat/Aura
          fallbackIcon: LucideIcons.messageSquare,
          color: AppTheme.primaryBlue,
          onTap: () => Navigator.pushNamed(context, '/home-chat', arguments: {
            'personalityType': _personalityType,
            'cognitiveBias': _cognitiveBias,
          }),
        ),
        _MenuCard(
          title: 'Tarea Cognitiva',
          description: 'Mide tu atención.',
          lottieUrl: 'https://lottie.host/6a56e097-47b7-4f81-a7d1-e6730393c834/fGvXvP9vW1.json', // Cerebro/Foco
          fallbackIcon: LucideIcons.brain,
          color: AppTheme.primaryGreen,
          onTap: () => Navigator.pushNamed(context, '/cognitive-task'),
        ),
        _MenuCard(
          title: 'Diario de Ánimo',
          description: 'Registra emociones.',
          lottieUrl: 'https://lottie.host/21966219-066e-4f32-8418-490b41140068/3G0XvP9vW1.json', // Sol/Clima
          fallbackIcon: LucideIcons.sun,
          color: Colors.orangeAccent,
          onTap: () => Navigator.pushNamed(context, '/mood-journal'),
        ),
        _MenuCard(
          title: 'Personalidad',
          description: 'Repite tu test MBTI.',
          lottieUrl: 'https://lottie.host/1785f7a0-093a-4467-8509-f860570b501b/69C4XvP8vR.json', // ID/Usuario
          fallbackIcon: LucideIcons.userCheck,
          color: Colors.pinkAccent,
          onTap: () => Navigator.pushNamed(context, '/personality-test'),
        ),
      ],
    );
  }

  Widget _buildFeaturedCardWithLottie(BuildContext context, {
    required String title,
    required String subtitle,
    required String lottieUrl,
    required IconData fallbackIcon,
    required Color color,
    required String route,
  }) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color.withOpacity(0.2), width: 2),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: Lottie.network(
                  lottieUrl,
                  errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, color: color, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: AppTheme.textLight)),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppTheme.textLight),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String description;
  final String lottieUrl;
  final IconData fallbackIcon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.description,
    required this.lottieUrl,
    required this.fallbackIcon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 85,
                child: Lottie.network(
                  lottieUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, color: color, size: 40),
                ),
              ),
              const Spacer(),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppTheme.textLight, height: 1.1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
