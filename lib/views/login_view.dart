import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';

import '../widgets/dynamic_background.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  
                  // Ilustración Central con animación de flotación
                  FadeInDown(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 120,
                        width: 120,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.psychology_outlined,
                          size: 100,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  FadeIn(
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      'BearWithMe',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.5,
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: const Text(
                      'Tu viaje de autodescubrimiento y bienestar emocional comienza aquí.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                  
                  FadeInUp(
                    delay: const Duration(milliseconds: 1200),
                    child: _ImpactfulButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/personality-test'),
                      icon: const Icon(Icons.login_rounded, color: AppTheme.primaryBlue), // Usamos un icono por defecto
                      label: 'Continuar con Google',
                      backgroundColor: Colors.white,
                      textColor: AppTheme.textDark,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  FadeInUp(
                    delay: const Duration(milliseconds: 1400),
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/personality-test'),
                      child: const Text(
                        'Entrar como invitado',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F2F1), // Verde menta muy claro
            Color(0xFFE1F5FE), // Azul cielo muy claro
            Colors.white,
          ],
        ),
      ),
    );
  }
}

class _ImpactfulButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _ImpactfulButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
