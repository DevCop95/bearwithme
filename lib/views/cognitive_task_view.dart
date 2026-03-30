import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vibration/vibration.dart';
import '../theme/app_theme.dart';
import '../widgets/dynamic_background.dart';

class CognitiveTaskView extends StatefulWidget {
  const CognitiveTaskView({super.key});

  @override
  State<CognitiveTaskView> createState() => _CognitiveTaskViewState();
}

class _CognitiveTaskViewState extends State<CognitiveTaskView> {
  final List<Map<String, dynamic>> _allStimuli = [
    // POSITIVAS (16)
    {'word': 'ALEGRÍA', 'type': 'positive'},
    {'word': 'ESPERANZA', 'type': 'positive'},
    {'word': 'ÉXITO', 'type': 'positive'},
    {'word': 'PAZ', 'type': 'positive'},
    {'word': 'AMOR', 'type': 'positive'},
    {'word': 'CALMA', 'type': 'positive'},
    {'word': 'LOGRO', 'type': 'positive'},
    {'word': 'ENTUSIASMO', 'type': 'positive'},
    {'word': 'GRATITUD', 'type': 'positive'},
    {'word': 'CONFIANZA', 'type': 'positive'},
    {'word': 'ALIVIO', 'type': 'positive'},
    {'word': 'TRIUNFO', 'type': 'positive'},
    {'word': 'ARMONÍA', 'type': 'positive'},
    {'word': 'GOZO', 'type': 'positive'},
    {'word': 'PASIÓN', 'type': 'positive'},
    {'word': 'BIENESTAR', 'type': 'positive'},
    // NEGATIVAS (16)
    {'word': 'FRACASO', 'type': 'negative'},
    {'word': 'SOLEDAD', 'type': 'negative'},
    {'word': 'MIEDO', 'type': 'negative'},
    {'word': 'CULPA', 'type': 'negative'},
    {'word': 'DOLOR', 'type': 'negative'},
    {'word': 'TRISTEZA', 'type': 'negative'},
    {'word': 'AGOBIO', 'type': 'negative'},
    {'word': 'RECHAZO', 'type': 'negative'},
    {'word': 'ENVIDIA', 'type': 'negative'},
    {'word': 'TRAICIÓN', 'type': 'negative'},
    {'word': 'DERROTA', 'type': 'negative'},
    {'word': 'ESTRÉS', 'type': 'negative'},
    {'word': 'ABANDONO', 'type': 'negative'},
    {'word': 'RENCORES', 'type': 'negative'},
    {'word': 'DESPRECIO', 'type': 'negative'},
    {'word': 'ANGUSTIA', 'type': 'negative'},
  ];

  List<Map<String, dynamic>> _currentSessionStimuli = [];
  int _currentIndex = 0;
  bool _isTaskActive = false;
  bool _isShowingFixation = false;
  DateTime? _startTime;
  final List<int> _posRTs = [];
  final List<int> _negRTs = [];
  int _score = 0;

  void _startTask() {
    setState(() {
      // Crear sesión aleatoria balanceada (5 pos + 5 neg)
      final positives = _allStimuli.where((s) => s['type'] == 'positive').toList()..shuffle();
      final negatives = _allStimuli.where((s) => s['type'] == 'negative').toList()..shuffle();
      
      _currentSessionStimuli = [
        ...positives.take(6),
        ...negatives.take(6),
      ]..shuffle(); // Mezclar orden final

      _isTaskActive = true;
      _currentIndex = 0;
      _posRTs.clear();
      _negRTs.clear();
      _score = 0;
      _showFixation();
    });
  }

  void _showFixation() {
    setState(() {
      _isShowingFixation = true;
    });
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isShowingFixation = false;
          _startTime = DateTime.now();
        });
      }
    });
  }

  void _handleResponse(String type) {
    if (!_isTaskActive || _isShowingFixation) return;

    final duration = DateTime.now().difference(_startTime!).inMilliseconds;
    
    final stimulusType = _currentSessionStimuli[_currentIndex]['type'];
    if (stimulusType == 'positive') {
      _posRTs.add(duration);
    } else {
      _negRTs.add(duration);
    }

    if (stimulusType == type) {
      _score++;
      Vibration.vibrate(duration: 10, amplitude: 30);
    } else {
      Vibration.vibrate(duration: 50, amplitude: 100);
    }

    setState(() {
      if (_currentIndex < _currentSessionStimuli.length - 1) {
        _currentIndex++;
        _showFixation();
      } else {
        _isTaskActive = false;
        _showResults();
      }
    });
  }

  void _showResults() {
    final avgPos = _posRTs.isEmpty ? 0 : _posRTs.reduce((a, b) => a + b) / _posRTs.length;
    final avgNeg = _negRTs.isEmpty ? 0 : _negRTs.reduce((a, b) => a + b) / _negRTs.length;
    final bias = avgNeg - avgPos;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text('Perfil Cognitivo', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.brainCircuit, color: AppTheme.primaryBlue, size: 60),
            const SizedBox(height: 24),
            _ResultRow(label: 'Reacción Positiva', value: '${avgPos.toStringAsFixed(0)}ms', color: AppTheme.primaryGreen),
            _ResultRow(label: 'Reacción Negativa', value: '${avgNeg.toStringAsFixed(0)}ms', color: Colors.redAccent),
            const Divider(height: 32),
            Text(
              bias > 30 
                ? 'Sesgo Positivo: Tu mente prioriza estímulos constructivos.' 
                : bias < -30 
                  ? 'Sesgo de Alerta: Estás procesando amenazas con mayor rapidez.'
                  : 'Equilibrio Cognitivo: Procesamiento neutro y estable.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                final biasText = bias > 30 
                  ? 'Sesgo Positivo' 
                  : bias < -30 
                    ? 'Sesgo de Alerta'
                    : 'Equilibrio Cognitivo';
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/home', 
                  (route) => false,
                  arguments: {'cognitiveBias': biasText},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Finalizar', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Tarea de Atención', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: _isTaskActive ? _buildTaskUI() : _buildIntro(),
          ),
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(LucideIcons.brain, size: 100, color: AppTheme.primaryBlue),
        const SizedBox(height: 32),
        const Text(
          'Evaluación de Sesgo Cognitivo',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Clasifica las palabras que aparezcan lo más rápido posible como Positivas o Negativas.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textLight, fontSize: 16),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: _startTask,
          style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60)),
          child: const Text('Comenzar Tarea'),
        ),
      ],
    );
  }

  Widget _buildTaskUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _currentSessionStimuli.length,
          backgroundColor: Colors.white.withOpacity(0.3),
          color: AppTheme.primaryBlue,
        ),
        const SizedBox(height: 100),
        SizedBox(
          height: 80,
          child: Center(
            child: _isShowingFixation 
              ? const Text('+', style: TextStyle(fontSize: 72, color: AppTheme.primaryBlue, fontWeight: FontWeight.w300))
              : ZoomIn(
                  key: ValueKey(_currentIndex),
                  child: Text(
                    _currentSessionStimuli[_currentIndex]['word'],
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppTheme.textDark),
                  ),
                ),
          ),
        ),
        const SizedBox(height: 100),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'NEGATIVO',
                color: Colors.redAccent,
                icon: LucideIcons.thumbsDown,
                onPressed: () => _handleResponse('negative'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _ActionButton(
                label: 'POSITIVO',
                color: AppTheme.primaryGreen,
                icon: LucideIcons.thumbsUp,
                onPressed: () => _handleResponse('positive'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textLight)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.color, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
