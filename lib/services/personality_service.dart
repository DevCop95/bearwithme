import '../models/personality_question.dart';

class PersonalityService {
  final List<PersonalityQuestion> questions = [
    PersonalityQuestion(
      text: "Te resulta difícil presentarte a ti mismo ante otras personas.",
      dimension: PersonalityDimension.extraversion,
      weight: -1,
    ),
    PersonalityQuestion(
      text: "A menudo te quedas tan absorto en tus pensamientos que ignoras tu entorno.",
      dimension: PersonalityDimension.intuition,
      weight: 1,
    ),
    PersonalityQuestion(
      text: "Tratas de responder a tus correos electrónicos lo antes posible.",
      dimension: PersonalityDimension.judging,
      weight: 1,
    ),
    PersonalityQuestion(
      text: "Te mantienes relajado y concentrado incluso bajo presión.",
      dimension: PersonalityDimension.feeling, // Usado para medir estabilidad emocional/T vs F
      weight: -1,
    ),
    PersonalityQuestion(
      text: "Sueles iniciar las conversaciones.",
      dimension: PersonalityDimension.extraversion,
      weight: 1,
    ),
    PersonalityQuestion(
      text: "Rara vez haces algo por pura curiosidad.",
      dimension: PersonalityDimension.intuition,
      weight: -1,
    ),
    PersonalityQuestion(
      text: "Te sientes superior a otras personas.",
      dimension: PersonalityDimension.feeling,
      weight: -1,
    ),
    PersonalityQuestion(
      text: "Para ti es más importante ser organizado que ser adaptable.",
      dimension: PersonalityDimension.judging,
      weight: 1,
    ),
    PersonalityQuestion(
      text: "A menudo sientes que tienes que justificarte ante los demás.",
      dimension: PersonalityDimension.feeling,
      weight: 1,
    ),
    PersonalityQuestion(
      text: "Tus planes de viaje suelen estar bien pensados.",
      dimension: PersonalityDimension.judging,
      weight: 1,
    ),
  ];

  String calculateType(Map<int, int> answers) {
    Map<PersonalityDimension, int> scores = {
      PersonalityDimension.extraversion: 0,
      PersonalityDimension.intuition: 0,
      PersonalityDimension.feeling: 0,
      PersonalityDimension.judging: 0,
    };

    answers.forEach((index, value) {
      final question = questions[index];
      // Escala Likert 1-5, centramos en 0 (-2 a 2)
      final normalizedValue = (value - 3) * question.weight;
      scores[question.dimension] = scores[question.dimension]! + normalizedValue;
    });

    String type = "";
    type += scores[PersonalityDimension.extraversion]! >= 0 ? "E" : "I";
    type += scores[PersonalityDimension.intuition]! >= 0 ? "N" : "S";
    type += scores[PersonalityDimension.feeling]! >= 0 ? "F" : "T";
    type += scores[PersonalityDimension.judging]! >= 0 ? "J" : "P";

    return type;
  }
}
