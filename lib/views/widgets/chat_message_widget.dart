import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryColor : AppTheme.secondaryBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : AppTheme.textColor,
          ),
        ),
      ),
    );
  }
} 