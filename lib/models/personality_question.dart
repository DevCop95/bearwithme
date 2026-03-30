enum PersonalityDimension { extraversion, intuition, feeling, judging }

class PersonalityQuestion {
  final String text;
  final PersonalityDimension dimension;
  final int weight; // 1 (normal) o -1 (inverso)

  PersonalityQuestion({
    required this.text,
    required this.dimension,
    required this.weight,
  });
}
