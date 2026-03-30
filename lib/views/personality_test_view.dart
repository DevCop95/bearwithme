import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/personality_service.dart';
import '../theme/app_theme.dart';
import '../widgets/dynamic_background.dart';

class PersonalityTestView extends StatefulWidget {
  const PersonalityTestView({super.key});

  @override
  State<PersonalityTestView> createState() => _PersonalityTestViewState();
}

class _PersonalityTestViewState extends State<PersonalityTestView> {
  final PersonalityService _service = PersonalityService();
  final Map<int, int> _answers = {};
  int _currentIndex = 0;

  void _answerQuestion(int value) {
    setState(() {
      _answers[_currentIndex] = value;
      if (_currentIndex < _service.questions.length - 1) {
        _currentIndex++;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    final type = _service.calculateType(_answers);
    Navigator.pushReplacementNamed(context, '/processing-test', arguments: {'personalityType': type});
  }

  @override
  Widget build(BuildContext context) {
    final question = _service.questions[_currentIndex];
    final progress = (_currentIndex + 1) / _service.questions.length;

    return DynamicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Descubriendo tu Ser', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: _currentIndex > 0 
              ? () => setState(() => _currentIndex--) 
              : () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Barra de Progreso Animada
              Stack(
                children: [
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: 8,
                    width: MediaQuery.of(context).size.width * 0.8 * progress,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.primaryGreen]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Pregunta ${_currentIndex + 1} de ${_service.questions.length}',
                style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 60),
              
              // Contenedor de Pregunta con Animación de Switch
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(_currentIndex),
                  child: Column(
                    children: [
                      Text(
                        question.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      // Escala 16Personalities (7 círculos)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ACUERDO', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('DESACUERDO', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          // Tamaños variados para imitar 16personalities
                          double size = 0;
                          Color color = Colors.grey;
                          
                          if (index < 3) {
                            size = 50.0 - (index * 8);
                            color = AppTheme.primaryGreen;
                          } else if (index == 3) {
                            size = 30.0;
                            color = Colors.grey.withOpacity(0.5);
                          } else {
                            size = 34.0 + ((index - 4) * 8);
                            color = Colors.redAccent;
                          }

                          return GestureDetector(
                            onTap: () => _answerQuestion(index + 1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: size,
                              width: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: color, width: 2.5),
                                color: color.withOpacity(0.05),
                              ),
                              child: Center(
                                child: Container(
                                  height: size * 0.4,
                                  width: size * 0.4,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.2)),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
