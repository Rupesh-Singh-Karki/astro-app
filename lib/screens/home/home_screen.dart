import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user_details_provider.dart';
import '../../providers/real_chat_provider.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../data/articles_data.dart';
import 'article_screen.dart';

/// Home screen with dashboard and quick actions.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.onNavigateToChat});

  final VoidCallback? onNavigateToChat;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userDetailsAsync = ref.watch(userDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TrustAstrology'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: userDetailsAsync.when(
        data: (userDetails) => _buildHomeContent(context, userDetails),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildHomeContent(context, null),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, UserDetails? userDetails) {
    final displayName = userDetails?.firstName ?? 'Explorer';

    return ListView(
      padding: EdgeInsets.all(AppSpacing.lg),
      children: [
        // Welcome Card with Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryPurple, AppColors.primaryPurpleLight],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMD,
                        ),
                      ),
                      child: Text(
                        userDetails?.zodiacEmoji ?? '⭐',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, $displayName',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (userDetails != null)
                            Text(
                              '${userDetails.zodiacEmoji} ${userDetails.zodiacSign} • Born ${userDetails.formattedBirthDate}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            )
                          else
                            Text(
                              'Your cosmic journey awaits',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                // Today's date and zodiac
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.xl),

        // Quick Actions
        Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.chat_bubble_outline,
                label: 'Chat',
                subtitle: 'Ask astrologer',
                onTap: () {},
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.auto_awesome,
                label: 'Daily',
                subtitle: 'Horoscope',
                onTap: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.stars,
                label: 'Birth Chart',
                subtitle: 'Your chart',
                onTap: () {},
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.psychology_outlined,
                label: 'Remedies',
                subtitle: 'Solutions',
                onTap: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xl),

        // Today's Insights
        Text(
          'Today\'s Insights',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: AppSpacing.md),

        _InsightCard(
          icon: Icons.favorite,
          title: 'Love & Relationships',
          description:
              'Venus is in a favorable position today. Great time for romantic connections.',
          color: Colors.pink,
          onTap: () => _navigateToChatWithQuestion(
            'How is my love life looking? What do the stars say about my romantic relationships?',
          ),
        ),
        _InsightCard(
          icon: Icons.work_outline,
          title: 'Career & Finance',
          description:
              'Mercury brings opportunities. Stay focused on your goals.',
          color: Colors.blue,
          onTap: () => _navigateToChatWithQuestion(
            'What does my birth chart say about my career prospects and financial situation?',
          ),
        ),
        _InsightCard(
          icon: Icons.health_and_safety,
          title: 'Health & Wellness',
          description:
              'Take time for self-care. Moon phase supports relaxation.',
          color: Colors.green,
          onTap: () => _navigateToChatWithQuestion(
            'How can I improve my health and wellness according to my astrological chart?',
          ),
        ),
        SizedBox(height: AppSpacing.xl),

        // Zodiac Signs Section
        Text('Zodiac Signs', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: AppSpacing.md),

        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _ZodiacCard(icon: '♈', name: 'Aries', date: 'Mar 21 - Apr 19'),
              _ZodiacCard(icon: '♉', name: 'Taurus', date: 'Apr 20 - May 20'),
              _ZodiacCard(icon: '♊', name: 'Gemini', date: 'May 21 - Jun 20'),
              _ZodiacCard(icon: '♋', name: 'Cancer', date: 'Jun 21 - Jul 22'),
              _ZodiacCard(icon: '♌', name: 'Leo', date: 'Jul 23 - Aug 22'),
              _ZodiacCard(icon: '♍', name: 'Virgo', date: 'Aug 23 - Sep 22'),
              _ZodiacCard(icon: '♎', name: 'Libra', date: 'Sep 23 - Oct 22'),
              _ZodiacCard(icon: '♏', name: 'Scorpio', date: 'Oct 23 - Nov 21'),
              _ZodiacCard(
                icon: '♐',
                name: 'Sagittarius',
                date: 'Nov 22 - Dec 21',
              ),
              _ZodiacCard(
                icon: '♑',
                name: 'Capricorn',
                date: 'Dec 22 - Jan 19',
              ),
              _ZodiacCard(icon: '♒', name: 'Aquarius', date: 'Jan 20 - Feb 18'),
              _ZodiacCard(icon: '♓', name: 'Pisces', date: 'Feb 19 - Mar 20'),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.xl),

        // Featured Content
        Text('Featured Content', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: AppSpacing.md),

        _FeaturedCard(
          title: 'Understanding Your Birth Chart',
          description:
              'Learn how to read and interpret your unique astrological blueprint',
          imageIcon: Icons.auto_stories,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ArticleScreen(article: articles['birth_chart']!),
              ),
            );
          },
        ),
        _FeaturedCard(
          title: 'Planetary Transits This Month',
          description: 'Major astrological events and how they affect you',
          imageIcon: Icons.public,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ArticleScreen(article: articles['planetary_transits']!),
              ),
            );
          },
        ),
      ],
    );
  }

  void _navigateToChatWithQuestion(String question) {
    // Start a new chat session first
    ref.read(chatMessagesProvider.notifier).startNewSession();

    // Store the predefined question in provider
    ref.read(predefinedQuestionProvider.notifier).state = question;

    // Navigate to chat tab if callback is provided
    widget.onNavigateToChat?.call();
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppSpacing.iconSizeLarge,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZodiacCard extends StatelessWidget {
  const _ZodiacCard({
    required this.icon,
    required this.name,
    required this.date,
  });

  final String icon;
  final String name;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: AppSpacing.md),
      child: Card(
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: TextStyle(fontSize: 28)),
                SizedBox(height: 4),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.title,
    required this.description,
    required this.imageIcon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData imageIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryPurple,
                      AppColors.primaryPurpleLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: Icon(imageIcon, color: Colors.white, size: 40),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
