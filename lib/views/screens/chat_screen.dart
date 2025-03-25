import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/chat_view_model.dart';
import '../../models/chat_message.dart';
import '../widgets/chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
    // 시작 메시지 추가
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatViewModel>().addMessage(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: "이름을 입력해주세요.",
          isUser: false,
        ),
      );
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleTextChange);
    _focusNode.removeListener(_handleFocusChange);
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isKeyboardVisible = _focusNode.hasFocus;
    });
  }

  void _handleTextChange() {
    setState(() {
      _isComposing = _messageController.text.isNotEmpty;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSendMessage(BuildContext context) async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // 키보드 숨기기
      FocusScope.of(context).unfocus();
      
      // 입력창 초기화
      _messageController.clear();
      
      // 메시지 전송
      await context.read<ChatViewModel>().sendMessage(message);
      
      // 스크롤 애니메이션
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollToBottom();
    }
  }

  Future<void> _showResetConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('채팅 내역 초기화'),
          content: const Text('모든 채팅 내역이 삭제됩니다. 계속하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('초기화'),
              onPressed: () async {
                try {
                  await context.read<ChatViewModel>().clearChatHistory();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    // 시작 메시지 다시 추가
                    context.read<ChatViewModel>().addMessage(
                      ChatMessage(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        content: "이름을 입력해주세요.",
                        isUser: false,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('초기화 중 오류가 발생했습니다: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.moon_stars_fill,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text('운세냥이'),
            ],
          ),
          elevation: 0,
          backgroundColor: AppTheme.appBarBackgroundColor,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(CupertinoIcons.arrow_counterclockwise, color: AppTheme.primaryColor),
                onPressed: _showResetConfirmationDialog,
                tooltip: '채팅 내역 초기화',
              ),
            ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.backgroundColor,
                  AppTheme.backgroundColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<ChatViewModel>(
                    builder: (context, viewModel, child) {
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: _isKeyboardVisible ? 80 : 16,
                          left: 8,
                          right: 8,
                        ),
                        itemCount: viewModel.messages.length + (viewModel.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == viewModel.messages.length) {
                            return ChatMessageWidget(
                              message: "",
                              isUser: false,
                              isLoading: true,
                            );
                          }
                          final message = viewModel.messages[index];
                          return ChatMessageWidget(
                            message: message.content,
                            isUser: message.isUser,
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.appBarShadowColor,
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxHeight: 100,
                                minHeight: 40,
                              ),
                              child: TextField(
                                controller: _messageController,
                                focusNode: _focusNode,
                                maxLines: null,
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                autocorrect: false,
                                style: Theme.of(context).textTheme.bodyLarge,
                                decoration: InputDecoration(
                                  hintText: '메시지를 입력하세요...',
                                  hintStyle: TextStyle(
                                    color: AppTheme.secondaryTextColor.withOpacity(0.7),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  isDense: true,
                                ),
                                onSubmitted: (_) {
                                  if (_isComposing) {
                                    _handleSendMessage(context);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Consumer<ChatViewModel>(
                            builder: (context, viewModel, child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  color: _isComposing && !viewModel.isLoading
                                      ? AppTheme.primaryColor
                                      : AppTheme.secondaryTextColor.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isComposing && !viewModel.isLoading
                                          ? AppTheme.primaryColor
                                          : AppTheme.secondaryTextColor.withOpacity(0.3)).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: (_isComposing && !viewModel.isLoading)
                                        ? () => _handleSendMessage(context)
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(
                                        viewModel.isLoading
                                            ? CupertinoIcons.hourglass
                                            : CupertinoIcons.arrow_up_circle_fill,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 