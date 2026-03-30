import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/message.dart';
import 'session_service.dart';

class ChatService {
  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  final SessionService _session = SessionService();
  final List<String> _detectedDistortions = [];
  final List<Map<String, String>> _history = [];

  List<String> get detectedDistortions => _detectedDistortions;

  Future<ChatMessage> getTherapistResponse(String userText) async {
    // Re-generar el system prompt cada vez para incluir el contexto de sesión más fresco
    if (_history.isEmpty) {
      _history.add({"role": "system", "content": _generateSystemPrompt()});
    } else {
      // Actualizar el primer mensaje (system) con el contexto actual si ha cambiado
      _history[0] = {"role": "system", "content": _generateSystemPrompt()};
    }

    _history.add({"role": "user", "content": userText});

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": _history,
          "temperature": 0.6,
          "max_tokens": 400,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String fullContent = data['choices'][0]['message']['content'];

        double sentimentScore = 0.5;
        String cleanContent = fullContent;
        
        if (fullContent.contains('###')) {
          final parts = fullContent.split('###');
          cleanContent = parts[0].trim();
          try {
            final analysisJson = jsonDecode(parts[1].trim());
            sentimentScore = (analysisJson['sentiment'] as num).toDouble();
            
            if (analysisJson['distortions'] != null) {
              for (var d in analysisJson['distortions']) {
                if (!_detectedDistortions.contains(d)) {
                  _detectedDistortions.add(d.toString());
                }
              }
            }
          } catch (e) {}
        }

        _history.add({"role": "assistant", "content": fullContent});

        // Vibración segura (solo si está soportada)
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 10, amplitude: 30);
        }

        return ChatMessage(
          text: cleanContent,
          sender: MessageSender.therapist,
          timestamp: DateTime.now(),
          sentimentScore: sentimentScore,
        );
      } else {
        print("Error Groq: ${response.body}");
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      return ChatMessage(
        text: "Me cuesta un poco conectar ahora mismo, pero estoy aquí. ¿Podemos intentarlo de nuevo?",
        sender: MessageSender.therapist,
        timestamp: DateTime.now(),
      );
    }
  }

  String _generateSystemPrompt() {
    final globalContext = _session.getGlobalContextSummary();

    return """Eres un TERAPEUTA IA experto en TCC. Tu misión es el bienestar del usuario.
    
    $globalContext

    LOGICA DE DISCERNIMIENTO AVANZADA:
    1. TEMAS PERSONALES (ACEPTAR): Si el usuario menciona religión, política o temas sociales como parte de su SUFRIMIENTO o VIVENCIA (ej. "me juzgan por mi religión", "me estresa la situación del país"), DEBES aceptarlo, validar su emoción y trabajar el impacto emocional. No debatas el tema, enfócate en lo que el usuario SIENTE.
    2. TEMAS TRIVIALES (RECHAZAR): Solo rechaza con brevedad si son consultas informativas, técnicas o de ocio sin carga emocional (ej. "receta de hamburguesa", "quién ganó el partido", "noticias de política"). Usa: "Prefiero que nos enfoquemos en tu bienestar, ¿te parece si volvemos a lo que sientes?".
    3. HERRAMIENTAS (ACEPTAR): Si pide una "receta" o "pasos" para mejorar emocionalmente, trátalo como una petición de herramientas terapéuticas, no como una receta de cocina.
    4. CIERRE: Toda respuesta debe ser corta (2 párrafos) y terminar con una pregunta o validación que mantenga el foco en el usuario.

    FORMATO OBLIGATORIO:
    [Respuesta empática y enfocada en el sentir del usuario]
    
    ### {"sentiment": 0.0-1.0, "distortions": ["lista"], "intensity": 1-10}
    """;
  }
}
