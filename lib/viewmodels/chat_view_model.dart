import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;
  
  late final ChatService _chatService;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ChatViewModel() {
    _chatService = ChatService(sessionId: const Uuid().v4());
    // 시작 메시지 추가
    addBotMessage("생년월일을 입력해주세요 (예: 1995-06-05)");
  }

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

  void addBotMessage(String message) {
    addMessage(message, false);
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // 사용자 메시지 추가
    addMessage(message, true);
    
    try {
      _isLoading = true;
      notifyListeners();

      // API 호출
      final response = await _chatService.sendMessage(message);
      
      // 봇 응답 추가
      addBotMessage(response.reply);
    } catch (e) {
      addBotMessage("죄송합니다. 오류가 발생했습니다. 다시 시도해주세요.");
      debugPrint('Error sending message: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 