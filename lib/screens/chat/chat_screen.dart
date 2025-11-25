import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/real_chat_provider.dart';
import '../../providers/api_provider.dart';
import '../../components/app_widgets.dart';
import '../../theme/app_spacing.dart';
import '../../models/chat_message.dart';
import '../../utils/logger.dart';

/// Helper to show styled snackbar
void showStyledSnackBar(
  ScaffoldMessengerState messenger, {
  required String message,
  IconData icon = Icons.check_circle,
  Color? backgroundColor,
  bool isError = false,
}) {
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: isError ? Colors.red.shade700 : Colors.grey.shade800,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isError ? Icons.error : icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Flexible(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

/// Global notifier to close any open action menus
final _closeActionMenuNotifier = ValueNotifier<int>(0);

/// Chat screen for messaging with astrologer
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final ScaffoldMessengerState _scaffoldMessenger;

  // User profile data needed for API calls
  Map<String, dynamic>? _userProfile;
  bool _isLoadingProfile = true;
  String?
  _lastProcessedQuestion; // Track last processed question to avoid duplicates
  bool _isProcessingQuestion = false; // Flag to prevent concurrent processing

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    // Close action menus on scroll
    _scrollController.addListener(_onScroll);

    // Listen to predefined question changes
    ref.listenManual(predefinedQuestionProvider, (previous, next) {
      if (next != null &&
          next.isNotEmpty &&
          next != _lastProcessedQuestion &&
          _userProfile != null &&
          !_isProcessingQuestion) {
        _isProcessingQuestion = true;
        _lastProcessedQuestion = next;

        // Clear the predefined question from provider immediately to prevent re-triggers
        ref.read(predefinedQuestionProvider.notifier).state = null;

        // Clear and set the message in the text field
        _messageController.clear();
        _messageController.text = next;

        // Auto-send the message after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _sendMessage();
            _isProcessingQuestion = false;
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
            showStyledSnackBar(
              _scaffoldMessenger,
              message: 'Failed to load profile: ${failure.displayMessage}',
              isError: true,
            );
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading user profile', e, stackTrace);
      setState(() => _isLoadingProfile = false);
    }
  }

  void _onScroll() {
    // Notify all message bubbles to close their action menus
    _closeActionMenuNotifier.value++;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
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
                      return _TypingIndicator(
                        key: const ValueKey('typing_indicator'),
                      );
                    }
                    final message = messages[index];
                    final isLastMessage = index == messages.length - 1;
                    final isAiMessage = !message.fromUser;

                    // Show suggestion prompts after the last AI message
                    if (isLastMessage && isAiMessage) {
                      return Column(
                        key: ValueKey('message_with_suggestions_${message.id}'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MessageBubble(message: message),
                          _SuggestionPrompts(
                            key: ValueKey('suggestions_${message.id}'),
                            onPromptSelected: (prompt) {
                              _messageController.text = prompt;
                              _sendMessage();
                            },
                          ),
                        ],
                      );
                    }

                    return _MessageBubble(
                      key: ValueKey('message_${message.id}'),
                      message: message,
                    );
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

/// Random suggestion prompts for the user
const List<String> _suggestionPrompts = [
  "What does my birth chart say about my career?",
  "How will this week be for my love life?",
  "What planetary alignments affect me today?",
  "Tell me about my moon sign compatibility",
  "What should I focus on this month?",
  "How can I improve my financial luck?",
  "What are my strengths according to my chart?",
  "Is this a good time for new beginnings?",
  "What does Mercury retrograde mean for me?",
  "How does my rising sign influence my personality?",
  "What are my lucky days this week?",
  "Should I make major decisions right now?",
  "What do the stars say about my health?",
  "How can I balance my energy better?",
  "What opportunities should I look for?",
  "Tell me about my Venus placement",
];

/// Widget to display suggestion prompts after AI response
class _SuggestionPrompts extends StatefulWidget {
  const _SuggestionPrompts({super.key, required this.onPromptSelected});

  final void Function(String prompt) onPromptSelected;

  @override
  State<_SuggestionPrompts> createState() => _SuggestionPromptsState();
}

class _SuggestionPromptsState extends State<_SuggestionPrompts> {
  late final List<String> _prompts;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    // Generate random prompts only once when widget is created
    final shuffled = List<String>.from(_suggestionPrompts)..shuffle();
    _prompts = shuffled.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _prompts.map((prompt) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: GestureDetector(
              onTap: _isSending
                  ? null
                  : () {
                      if (_isSending) return;
                      setState(() => _isSending = true);
                      widget.onPromptSelected(prompt);
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: Colors.grey.shade500, width: 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        prompt,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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

/// Action button for the message action menu
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        onPressed: onPressed,
        splashRadius: 20,
      ),
    );
  }
}

class _MessageBubble extends ConsumerStatefulWidget {
  const _MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  ConsumerState<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<_MessageBubble> {
  bool _showActions = false;
  OverlayEntry? _overlayEntry;
  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    _closeActionMenuNotifier.addListener(_onCloseNotified);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    _closeActionMenuNotifier.removeListener(_onCloseNotified);
    _removeOverlay();
    super.dispose();
  }

  void _onCloseNotified() {
    if (_showActions) {
      _removeOverlay();
      setState(() => _showActions = false);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showActionMenu(Offset globalPosition) {
    // Close any other open menus first
    _closeActionMenuNotifier.value++;

    final colorScheme = Theme.of(context).colorScheme;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final bubblePosition = renderBox.localToGlobal(Offset.zero);

    // Calculate position - show to the right of long press point
    final screenWidth = MediaQuery.of(context).size.width;
    final isUser = widget.message.fromUser;

    // Determine x position based on message alignment and available space
    double left;
    if (isUser) {
      // User message is on the right, show menu on the left of the bubble
      left = bubblePosition.dx - 60;
    } else {
      // AI message is on the left, show menu on the right of the bubble
      left = bubblePosition.dx + size.width + 8;
    }

    // Ensure menu stays within screen bounds
    if (left < 8) left = 8;
    if (left > screenWidth - 60) left = screenWidth - 60;

    // Y position at the long press point
    double top = globalPosition.dy - 70;
    if (top < 100) top = 100;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap anywhere to close
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _removeOverlay();
                setState(() => _showActions = false);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Action menu
          Positioned(
            left: left,
            top: top,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionButton(
                      icon: Icons.close,
                      color: Colors.grey.shade700,
                      onPressed: () {
                        _removeOverlay();
                        setState(() => _showActions = false);
                      },
                    ),
                    _ActionButton(
                      icon: Icons.copy,
                      color: Colors.grey.shade700,
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: widget.message.text),
                        );
                        _removeOverlay();
                        setState(() => _showActions = false);
                        if (_scaffoldMessenger != null) {
                          showStyledSnackBar(
                            _scaffoldMessenger!,
                            message: 'Message copied to clipboard',
                            icon: Icons.copy,
                          );
                        }
                      },
                    ),
                    _ActionButton(
                      icon: Icons.delete,
                      color: Colors.red.shade400,
                      onPressed: () async {
                        _removeOverlay();
                        setState(() => _showActions = false);

                        final isUser = widget.message.fromUser;
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              isUser ? 'Unsend Message' : 'Delete Message',
                            ),
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

                        if (confirmed == true && mounted) {
                          final success = await ref
                              .read(chatMessagesProvider.notifier)
                              .deleteMessage(widget.message.id);

                          if (_scaffoldMessenger != null) {
                            if (success) {
                              showStyledSnackBar(
                                _scaffoldMessenger!,
                                message: 'Message deleted',
                                icon: Icons.delete,
                              );
                            } else {
                              showStyledSnackBar(
                                _scaffoldMessenger!,
                                message: 'Failed to delete message',
                                isError: true,
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);

    // Re-listen after incrementing notifier
    Future.microtask(() {
      if (mounted) setState(() => _showActions = true);
    });
  }

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
  Widget build(BuildContext context) {
    final isUser = widget.message.fromUser;
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
          children: _parseMarkdown(widget.message.text, baseStyle, boldStyle),
        ),
      ),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPressStart: (details) {
          if (_showActions) {
            _removeOverlay();
            setState(() => _showActions = false);
          } else {
            _showActionMenu(details.globalPosition);
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
                                  final messenger = ScaffoldMessenger.of(
                                    context,
                                  );
                                  if (success) {
                                    showStyledSnackBar(
                                      messenger,
                                      message: 'Chat deleted successfully',
                                      icon: Icons.delete,
                                    );
                                  } else {
                                    showStyledSnackBar(
                                      messenger,
                                      message: 'Failed to delete chat',
                                      isError: true,
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
  const _TypingIndicator({super.key});

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
