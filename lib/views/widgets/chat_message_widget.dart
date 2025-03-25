import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../core/theme/app_theme.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage message;

  const ChatMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // 슬라이드 애니메이션
    _slideAnimation = Tween<double>(
      begin: widget.message.isUser ? 50.0 : -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    // 스케일 애니메이션
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    // 투명도 애니메이션
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // 애니메이션 시작
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.75;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          child: Align(
            alignment: widget.message.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(_slideAnimation.value, 0),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                alignment: widget.message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: widget.message.isUser
                            ? AppTheme.primaryColor
                            : AppTheme.secondaryBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(widget.message.isUser ? 20 : 5),
                          bottomRight: Radius.circular(widget.message.isUser ? 5 : 20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        widget.message.message,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.message.isUser 
                              ? Colors.white 
                              : AppTheme.textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 