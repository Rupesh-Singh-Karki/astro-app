import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/real_chat_provider.dart';
import '../../providers/api_provider.dart';
import '../../components/app_widgets.dart';
import '../../theme/app_spacing.dart';
import '../../models/chat_message.dart';
import '../../utils/logger.dart';

/// Chat screen for messaging with astrologer
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // User profile data needed for API calls
  Map<String, dynamic>? _userProfile;
  bool _isLoadingProfile = true;
  String?
  _lastProcessedQuestion; // Track last processed question to avoid duplicates
  bool _isProcessingQuestion = false; // Flag to prevent concurrent processing

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    // Listen to predefined question changes
    ref.listenManual(predefinedQuestionProvider, (previous, next) {
      if (next != null &&
          next.isNotEmpty &&
          next != _lastProcessedQuestion &&
          _userProfile != null &&
          !_isProcessingQuestion) {
        _isProcessingQuestion = true;
        _lastProcessedQuestion = next;

        // Clear and set the message in the text field
        _messageController.clear();
        _messageController.text = next;

        // Clear the predefined question from provider
        Future.microtask(() {
          if (mounted) {
            ref.read(predefinedQuestionProvider.notifier).state = null;

            // Auto-send the message after a short delay
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _sendMessage();
                _isProcessingQuestion = false;
              }
            });
          }
        });
      }
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final authApiService = ref.read(authApiServiceProvider);
      final result = await authApiService.getUserDetails();

      result.when(
        success: (data) {
          setState(() {
            _userProfile = data;
            _isLoadingProfile = false;
          });
          AppLogger.info('User profile loaded for chat');
        },
        failure: (failure) {
          setState(() => _isLoadingProfile = false);
          AppLogger.error('Failed to load user profile: ${failure.message}');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to load profile: ${failure.displayMessage}',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading user profile', e, stackTrace);
      setState(() => _isLoadingProfile = false);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty || _userProfile == null) {
      return;
    }

    _messageController.clear();

    // Parse birth date and time
    final dateOfBirth = DateTime.parse(
      _userProfile!['date_of_birth'] as String,
    );
    final timeOfBirth = _userProfile!['time_of_birth'] as String;
    final timeParts = timeOfBirth.split(':');
    final birthHour = int.parse(timeParts[0]);
    final birthMinute = int.parse(timeParts[1]);

    // TODO: Get actual lat/long from place_of_birth
    // For now, using Mumbai coordinates as fallback
    const latitude = 19.0760;
    const longitude = 72.8777;
    final timezone = _userProfile!['timezone'] as String;

    await ref
        .read(chatMessagesProvider.notifier)
        .sendMessage(
          text,
          birthYear: dateOfBirth.year,
          birthMonth: dateOfBirth.month,
          birthDay: dateOfBirth.day,
          birthHour: birthHour,
          birthMinute: birthMinute,
          latitude: latitude,
          longitude: longitude,
          timezone: timezone,
        );

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatMessagesState = ref.watch(chatMessagesProvider);
    final currentSessionId = ref.watch(currentSessionIdProvider);

    if (_isLoadingProfile) {
      return const Scaffold(
        body: AppLoadingIndicator(message: 'Loading profile...'),
      );
    }

    if (_userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const AppErrorWidget(
          message: 'Profile not found. Please complete your profile first.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => _ChatSessionsDrawer(
                onSessionTap: (sessionId) {
                  ref.read(currentSessionIdProvider.notifier).state = sessionId;
                  ref
                      .read(chatMessagesProvider.notifier)
                      .loadSession(sessionId);
                  Navigator.pop(context);
                },
                onNewChat: () {
                  ref.read(chatMessagesProvider.notifier).startNewSession();
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chat with Astrologer'),
            if (currentSessionId != null)
              Text(
                'Session active',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else
              Text(
                'New conversation',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatMessagesState.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const AppEmptyState(
                    message:
                        'No messages yet.\nStart a conversation with your astrologer!',
                    icon: Icons.chat_bubble_outline,
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppSpacing.lg),
                  itemCount: messages.length + 1, // +1 for typing indicator
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      // Show typing indicator at the end
                      return _TypingIndicator();
                    }
                    return _MessageBubble(message: messages[index]);
                  },
                );
              },
              loading: () =>
                  const AppLoadingIndicator(message: 'Loading messages...'),
              error: (error, _) => AppErrorWidget(
                message: 'Failed to load messages',
                onRetry: () => ref.invalidate(chatMessagesProvider),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ask your astrologer...',
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper class for markdown parsing
class _MarkdownSegment {
  final String text;
  final bool isBold;
  final bool isItalic;

  _MarkdownSegment(this.text, this.isBold, this.isItalic);
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  /// Parse simple markdown and return TextSpans
  List<TextSpan> _parseMarkdown(
    String text,
    TextStyle baseStyle,
    TextStyle boldStyle,
  ) {
    final List<TextSpan> spans = [];

    // Split by lines to handle bullet points
    final lines = text.split('\n');

    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      String line = lines[lineIndex];

      // Handle bullet points - replace * at start of line with bullet
      if (line.trim().startsWith('* ')) {
        line = line.replaceFirst(RegExp(r'^\s*\*\s+'), '• ');
      } else if (line.trim().startsWith('*') && line.trim().length > 1) {
        // Handle case where there's no space after asterisk
        line = line.replaceFirst(RegExp(r'^\s*\*'), '• ');
      }

      // Now parse this line for formatting
      final List<_MarkdownSegment> segments = [];

      // First find all **text** patterns (bold)
      final RegExp boldPattern = RegExp(r'\*\*([^\*]+?)\*\*');
      int lastIndex = 0;

      for (final match in boldPattern.allMatches(line)) {
        // Add text before this match
        if (match.start > lastIndex) {
          final beforeText = line.substring(lastIndex, match.start);
          segments.add(_MarkdownSegment(beforeText, false, false));
        }

        // Add the bold text
        segments.add(_MarkdownSegment(match.group(1)!, true, false));
        lastIndex = match.end;
      }

      // Add remaining text
      if (lastIndex < line.length) {
        segments.add(_MarkdownSegment(line.substring(lastIndex), false, false));
      }

      // If no bold patterns found, add the whole line
      if (segments.isEmpty) {
        segments.add(_MarkdownSegment(line, false, false));
      }

      // Now process each segment for single * (italic, but not at word boundaries)
      final List<_MarkdownSegment> finalSegments = [];
      for (final segment in segments) {
        if (segment.isBold) {
          // Already bold, don't process further
          finalSegments.add(segment);
        } else {
          // Check for single * italic patterns (but not at start of text which are bullets)
          final RegExp italicPattern = RegExp(r'(?<!^)\*([^\*\n]+?)\*');
          int segmentIndex = 0;
          bool foundItalic = false;

          for (final match in italicPattern.allMatches(segment.text)) {
            foundItalic = true;
            if (match.start > segmentIndex) {
              finalSegments.add(
                _MarkdownSegment(
                  segment.text.substring(segmentIndex, match.start),
                  false,
                  false,
                ),
              );
            }
            finalSegments.add(_MarkdownSegment(match.group(1)!, false, true));
            segmentIndex = match.end;
          }

          // If no italic patterns found, add the segment as is
          if (!foundItalic) {
            finalSegments.add(segment);
          } else if (segmentIndex < segment.text.length) {
            // Add remaining text after last italic match
            finalSegments.add(
              _MarkdownSegment(
                segment.text.substring(segmentIndex),
                false,
                false,
              ),
            );
          }
        }
      }

      // Convert segments to TextSpans
      for (final segment in finalSegments) {
        TextStyle style = baseStyle;
        if (segment.isBold) {
          style = boldStyle;
        } else if (segment.isItalic) {
          style = baseStyle.copyWith(fontStyle: FontStyle.italic);
        }

        spans.add(TextSpan(text: segment.text, style: style));
      }

      // Add newline if not the last line
      if (lineIndex < lines.length - 1) {
        spans.add(TextSpan(text: '\n', style: baseStyle));
      }
    }

    return spans.isEmpty ? [TextSpan(text: text, style: baseStyle)] : spans;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.fromUser;
    final colorScheme = Theme.of(context).colorScheme;

    final baseStyle = TextStyle(
      color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
    );

    final boldStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);

    final bubble = Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG).copyWith(
          bottomLeft: Radius.circular(
            isUser ? AppSpacing.radiusLG : AppSpacing.radiusXS,
          ),
          bottomRight: Radius.circular(
            isUser ? AppSpacing.radiusXS : AppSpacing.radiusLG,
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: _parseMarkdown(message.text, baseStyle, boldStyle),
        ),
      ),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(isUser ? 'Unsend Message' : 'Delete Message'),
              content: const Text(
                'Are you sure you want to delete this message? This action cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.error,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (confirmed == true && context.mounted) {
            final success = await ref
                .read(chatMessagesProvider.notifier)
                .deleteMessage(message.id);

            if (context.mounted) {
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Failed to delete message'),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            }
          }
        },
        child: bubble,
      ),
    );
  }
}

/// Drawer widget showing all chat sessions
class _ChatSessionsDrawer extends ConsumerWidget {
  const _ChatSessionsDrawer({
    required this.onSessionTap,
    required this.onNewChat,
  });

  final Function(String) onSessionTap;
  final VoidCallback onNewChat;

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${diff.inDays ~/ 7}w ago';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatSessionsAsync = ref.watch(chatSessionsProvider);
    final currentSessionId = ref.watch(currentSessionIdProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chat Sessions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onNewChat,
                  tooltip: 'New Chat',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: chatSessionsAsync.when(
              data: (sessions) => sessions.isEmpty
                  ? const Center(
                      child: Text(
                        'No chat sessions yet.\nStart a new conversation!',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final isSelected = session.id == currentSessionId;

                        return ListTile(
                          selected: isSelected,
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.chat_bubble,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            session.title,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Row(
                            children: [
                              Text('${session.messageCount} messages'),
                              const SizedBox(width: AppSpacing.xs),
                              const Text('•'),
                              const SizedBox(width: AppSpacing.xs),
                              Text(_formatTimestamp(session.createdAt)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Chat'),
                                  content: const Text(
                                    'Are you sure you want to delete this chat session? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true && context.mounted) {
                                final success = await ref
                                    .read(chatMessagesProvider.notifier)
                                    .deleteSession(session.id);

                                if (context.mounted) {
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Chat deleted successfully',
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Failed to delete chat',
                                        ),
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                          onTap: () => onSessionTap(session.id),
                        );
                      },
                    ),
              loading: () =>
                  const AppLoadingIndicator(message: 'Loading sessions...'),
              error: (error, _) => AppErrorWidget(
                message: 'Failed to load sessions',
                onRetry: () => ref.invalidate(chatSessionsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Typing indicator widget that shows when AI is responding
class _TypingIndicator extends ConsumerWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTyping = ref.watch(isAiTypingProvider);

    if (!isTyping) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusLG,
          ).copyWith(bottomLeft: Radius.circular(AppSpacing.radiusXS)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimatedDot(delay: 0),
            SizedBox(width: 4),
            _AnimatedDot(delay: 200),
            SizedBox(width: 4),
            _AnimatedDot(delay: 400),
          ],
        ),
      ),
    );
  }
}

/// Animated dot for typing indicator
class _AnimatedDot extends StatefulWidget {
  const _AnimatedDot({required this.delay});

  final int delay;

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Delay the start of animation
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
