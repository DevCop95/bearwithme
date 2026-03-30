import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/dynamic_background.dart';

class ChatView extends StatefulWidget {
  final String? personalityType;
  const ChatView({super.key, this.personalityType});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  
  // Soporte para Voz
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    
    // Capturar contexto de sesión y argumentos de navegación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final bias = args?['cognitiveBias'] as String?;
      final session = SessionService();

      if (widget.personalityType != null) {
        session.personalityType = widget.personalityType;
      }

      if (bias != null) {
        session.cognitiveBias = bias;
        setState(() {
          _messages.add(ChatMessage(
            text: "He recibido tus resultados de la tarea de atención. Tu perfil actual muestra un '$bias'. ¿Cómo te hace sentir este hallazgo sobre tu estado mental hoy?",
            sender: MessageSender.therapist,
            timestamp: DateTime.now(),
          ));
        });
      } else {
        setState(() {
          final pType = session.personalityType ?? widget.personalityType ?? 'única';
          _messages.add(ChatMessage(
            text: "Hola, soy tu guía. He notado que tu personalidad es $pType. ¿Cómo estás viviendo el día de hoy?",
            sender: MessageSender.therapist,
            timestamp: DateTime.now(),
          ));
        });
      }
    });
  }

  Future<void> _safeVibrate({int duration = 10, int amplitude = 30}) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: duration, amplitude: amplitude);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _safeVibrate(duration: 30);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _safeVibrate(duration: 30);
    }
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    
    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    final response = await _chatService.getTherapistResponse(text);
    
    setState(() {
      _messages.add(response);
      _isTyping = false;
    });
    
    _safeVibrate(duration: 10, amplitude: 30);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Guía Emocional', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white.withOpacity(0.5),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.home, color: AppTheme.primaryBlue),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
          ),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.sun, color: Colors.orangeAccent),
              onPressed: () => Navigator.pushNamed(context, '/mood-journal'),
            ),
            IconButton(
              icon: const Icon(LucideIcons.barChart2, color: AppTheme.primaryBlue),
              onPressed: () => Navigator.pushNamed(context, '/profile-summary'),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _ChatBubble(message: message),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_isTyping)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('El guía está reflexionando...', 
                  style: TextStyle(fontStyle: FontStyle.italic, color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
              ),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 25, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isListening ? LucideIcons.mic : LucideIcons.micOff,
                    color: _isListening ? Colors.redAccent : AppTheme.textLight,
                  ),
                  onPressed: _listen,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _handleSubmitted,
                    decoration: const InputDecoration(
                      hintText: 'Cuéntame lo que sientes...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _handleSubmitted(_controller.text),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.send, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              radius: 18,
              child: Icon(LucideIcons.sparkles, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: isUser 
                  ? const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.primaryGreen], begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : null,
                color: isUser ? null : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: Radius.circular(isUser ? 22 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 22),
                ),
                boxShadow: [
                  BoxShadow(color: (isUser ? AppTheme.primaryBlue : Colors.black).withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 5)),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : AppTheme.textDark,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 12),
        ],
      ),
    );
  }
}
