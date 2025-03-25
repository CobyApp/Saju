import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final ChatService _chatService;
  bool _isLoading = false;
  static const String _storageKey = 'chat_history';

  ChatViewModel() : _chatService = ChatService(sessionId: const Uuid().v4()) {
    _loadChatHistory();
  }

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> _loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString(_storageKey);
      
      if (historyJson != null) {
        final List<dynamic> history = List<dynamic>.from(jsonDecode(historyJson));
        _messages.clear();
        _messages.addAll(
          history.map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = jsonEncode(_messages.map((msg) => msg.toJson()).toList());
      await prefs.setString(_storageKey, historyJson);
    } catch (e) {
      debugPrint('Error saving chat history: $e');
    }
  }

  void addMessage(ChatMessage message) {
    _messages.add(message);
    _saveChatHistory();
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
    );
    addMessage(userMessage);

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _chatService.sendMessage(message);
      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response.reply,
        isUser: false,
      );
      addMessage(botMessage);
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: e.toString(),
        isUser: false,
      );
      addMessage(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearChatHistory() async {
    try {
      // 서버에 세션 초기화 요청
      await _chatService.reset();
      
      // 로컬 저장소에서 채팅 내역 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      
      // 메모리에서 메시지 목록 초기화
      _messages.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing chat history: $e');
      rethrow;
    }
  }
} 