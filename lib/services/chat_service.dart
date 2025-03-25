import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_request.dart';
import '../models/chat_response.dart';

class ChatService {
  static const String baseUrl = 'http://cobyserver.iptime.org:8000';
  final String sessionId;

  ChatService({required this.sessionId});

  Future<ChatResponse> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(jsonEncode(
          ChatRequest(
            sessionId: sessionId,
            message: message,
          ).toJson(),
        )),
      );

      if (response.statusCode == 200) {
        // UTF-8로 디코딩
        final decodedBody = utf8.decode(response.bodyBytes);
        return ChatResponse.fromJson(
          jsonDecode(decodedBody) as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
} 