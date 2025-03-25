import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/app_theme.dart';

class ChatMessageWidget extends StatefulWidget {
  final String message;
  final bool isUser;
  final bool isLoading;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: widget.isUser ? AppTheme.userMessageBackgroundColor : AppTheme.messageBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: widget.isUser ? null : Border.all(
            color: AppTheme.messageBorderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.messageShadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: widget.isLoading
            ? AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      final delay = index * 0.2;
                      final value = _animation.value;
                      final opacity = (value - delay).clamp(0.0, 1.0);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              )
            : Text(
                widget.message,
                style: TextStyle(
                  color: widget.isUser ? AppTheme.userMessageTextColor : AppTheme.textColor,
                  fontSize: 16,
                  letterSpacing: -0.3,
                ),
              ),
      ),
    );
  }
} 