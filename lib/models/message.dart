enum MessageSender { user, therapist, system }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final double? sentimentScore; // -1.0 (negativo) a 1.0 (positivo)

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
    this.sentimentScore,
  });
}
