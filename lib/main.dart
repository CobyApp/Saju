import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/chat_view_model.dart';
import 'views/screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: MaterialApp(
        title: 'AI 사주봇',
        theme: AppTheme.lightTheme,
        home: const ChatScreen(),
      ),
    );
  }
}
