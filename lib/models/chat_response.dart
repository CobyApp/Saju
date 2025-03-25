class ChatResponse {
  final String reply;

  ChatResponse({required this.reply});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      reply: json['reply'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reply': reply,
    };
  }
} 