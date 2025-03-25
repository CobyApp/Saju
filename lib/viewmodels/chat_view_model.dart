import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  void addMessage(String message, bool isUser) {
    _messages.add(
      ChatMessage(
        message: message,
        isUser: isUser,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
} 