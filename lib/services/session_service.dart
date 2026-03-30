class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  String? personalityType;
  String? cognitiveBias;
  double? latestMoodScore;
  String? latestMoodNote;
  DateTime? lastMoodTimestamp;

  void updateMood(double score, String note) {
    latestMoodScore = score;
    latestMoodNote = note;
    lastMoodTimestamp = DateTime.now();
  }

  String getGlobalContextSummary() {
    String context = "CONTEXTO GLOBAL DEL USUARIO:\n";
    if (personalityType != null) context += "- Personalidad MBTI: $personalityType\n";
    if (cognitiveBias != null) context += "- Estado Cognitivo Actual: $cognitiveBias\n";
    if (latestMoodScore != null) {
      context += "- Último Ánimo Registrado: ${(latestMoodScore! * 100).toStringAsFixed(0)}% de energía\n";
      if (latestMoodNote != null && latestMoodNote!.isNotEmpty) {
        context += "- Nota del Diario: \"$latestMoodNote\"\n";
      }
    }
    return context;
  }
}
