class MoodEntry {
  final int score; // 1 (muy mal) a 5 (excelente)
  final String label;
  final String notes;
  final DateTime date;

  MoodEntry({
    required this.score,
    required this.label,
    required this.notes,
    required this.date,
  });
}
