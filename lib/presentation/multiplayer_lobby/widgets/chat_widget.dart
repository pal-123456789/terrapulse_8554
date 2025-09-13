import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ChatWidget extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  final Function(String message)? onSendMessage;
  final String? currentUserId;

  const ChatWidget({
    super.key,
    required this.messages,
    this.onSendMessage,
    this.currentUserId,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  final FocusNode _messageFocusNode = FocusNode();

  final List<String> _scientificPhrases = [
    'Great observation!',
    'Interesting data point',
    'Let\'s analyze this',
    'Good hypothesis',
    'Ready for simulation',
    'Excellent teamwork',
    'Need more data',
    'Check the parameters',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildChatHeader(context, colorScheme),
          Expanded(
            child: _buildMessagesList(context, colorScheme),
          ),
          if (_showEmojiPicker)
            SizedBox(
              height: 25.h,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _messageController.text += emoji.emoji;
                },
                config: Config(
                  height: 25.h,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    backgroundColor: colorScheme.surface,
                    columns: 7,
                    emojiSizeMax: 28,
                  ),
                  skinToneConfig: const SkinToneConfig(),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: colorScheme.surface,
                    iconColor: colorScheme.onSurfaceVariant,
                    iconColorSelected: colorScheme.primary,
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(
                    backgroundColor: colorScheme.surface,
                    buttonColor: colorScheme.surface,
                    buttonIconColor: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          _buildQuickPhrases(context, colorScheme),
          _buildMessageInput(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildChatHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'chat',
            size: 20,
            color: colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          Text(
            'Team Chat',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
          ),
          const Spacer(),
          Text(
            '${widget.messages.length} messages',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, ColorScheme colorScheme) {
    if (widget.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'chat_bubble_outline',
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.h),
            Text(
              'No messages yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start the conversation!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return _buildMessageItem(context, colorScheme, message);
      },
    );
  }

  Widget _buildMessageItem(BuildContext context, ColorScheme colorScheme,
      Map<String, dynamic> message) {
    final String senderId = (message['senderId'] as String?) ?? '';
    final String senderName = (message['senderName'] as String?) ?? 'Unknown';
    final String content = (message['content'] as String?) ?? '';
    final DateTime timestamp =
        (message['timestamp'] as DateTime?) ?? DateTime.now();
    final bool isCurrentUser = senderId == widget.currentUserId;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 4.w,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                senderName.isNotEmpty ? senderName[0].toUpperCase() : 'U',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Text(
                      senderName,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                Container(
                  constraints: BoxConstraints(maxWidth: 70.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12).copyWith(
                      bottomLeft: isCurrentUser
                          ? const Radius.circular(12)
                          : const Radius.circular(4),
                      bottomRight: isCurrentUser
                          ? const Radius.circular(4)
                          : const Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isCurrentUser
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                        ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatTimestamp(timestamp),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
          if (isCurrentUser) ...[
            SizedBox(width: 2.w),
            CircleAvatar(
              radius: 4.w,
              backgroundColor: colorScheme.primary,
              child: Text(
                'You'[0],
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickPhrases(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _scientificPhrases.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: ActionChip(
              label: Text(
                _scientificPhrases[index],
                style: Theme.of(context).textTheme.labelSmall,
              ),
              onPressed: () {
                _messageController.text = _scientificPhrases[index];
                _messageFocusNode.requestFocus();
              },
              backgroundColor: colorScheme.surfaceContainerHighest,
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _showEmojiPicker = !_showEmojiPicker;
                });
                if (_showEmojiPicker) {
                  _messageFocusNode.unfocus();
                }
              },
              icon: CustomIconWidget(
                iconName: _showEmojiPicker ? 'keyboard' : 'emoji_emotions',
                size: 24,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onTap: () {
                  if (_showEmojiPicker) {
                    setState(() {
                      _showEmojiPicker = false;
                    });
                  }
                },
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
            SizedBox(width: 2.w),
            IconButton(
              onPressed: _sendMessage,
              icon: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'send',
                  size: 20,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage?.call(message);
      _messageController.clear();
      setState(() {
        _showEmojiPicker = false;
      });

      // Scroll to bottom after sending message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
