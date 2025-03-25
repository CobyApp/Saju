import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/chat_request.dart';
import '../models/chat_response.dart';
import 'dart:async';

class ChatService {
  static const String baseUrl = 'http://cobyserver.iptime.org:8000';
  final String sessionId;

  ChatService({required this.sessionId});

  Future<ChatResponse> sendMessage(String message) async {
    try {
      debugPrint('Attempting to connect to: $baseUrl/chat');
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(jsonEncode({
          'session_id': sessionId,
          'message': message,
        })),
      ).timeout(const Duration(seconds: 30));

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      
      final decodedBody = utf8.decode(response.bodyBytes);
      debugPrint('Decoded response: $decodedBody');

      if (response.statusCode == 200) {
        return ChatResponse.fromJson(jsonDecode(decodedBody));
      } else {
        throw Exception('서버 오류가 발생했습니다. 다시 시도해주세요.');
      }
    } on SocketException {
      throw Exception('서버에 연결할 수 없습니다. 인터넷 연결을 확인해주세요.');
    } on TimeoutException {
      throw Exception('서버 응답 시간이 초과되었습니다. 다시 시도해주세요.');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> reset() async {
    try {
      debugPrint('Attempting to reset session: $baseUrl/reset');
      final response = await http.post(
        Uri.parse('$baseUrl/reset'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(jsonEncode({
          'session_id': sessionId,
        })),
      ).timeout(const Duration(seconds: 10));

      debugPrint('Reset response status code: ${response.statusCode}');
      debugPrint('Reset response body: ${response.body}');

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody.get('detail', '세션 초기화 중 오류가 발생했습니다.'));
      }
    } catch (e) {
      debugPrint('Error resetting session: $e');
      if (e is SocketException) {
        throw Exception('서버에 연결할 수 없습니다. 인터넷 연결을 확인해주세요.');
      } else if (e is TimeoutException) {
        throw Exception('서버 응답 시간이 초과되었습니다. 다시 시도해주세요.');
      } else {
        throw Exception('세션 초기화 중 오류가 발생했습니다: ${e.toString()}');
      }
    }
  }
} 