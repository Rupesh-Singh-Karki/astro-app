import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Subscription plans screen.
///
/// Displays available subscription plans for premium features.
class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscribe'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Header
          Text(
            'Choose Your Plan',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Unlock premium features and get personalized astrology insights',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Free Plan
          _PlanCard(
            title: 'Free',
            price: '\$0',
            period: 'Forever',
            features: const [
              'Basic daily horoscope',
              '3 chat messages per day',
              'Weekly predictions',
              'Community access',
            ],
            isPopular: false,
            onSubscribe: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You are on the Free plan')),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Monthly Plan
          _PlanCard(
            title: 'Monthly',
            price: '\$9.99',
            period: 'per month',
            features: const [
              'Unlimited chat with astrologer',
              'Detailed birth chart analysis',
              'Daily personalized insights',
              'Relationship compatibility',
              'Priority support',
              'Ad-free experience',
            ],
            isPopular: true,
            onSubscribe: () {
              _showSubscriptionDialog(context, 'Monthly', '\$9.99/month');
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Yearly Plan
          _PlanCard(
            title: 'Yearly',
            price: '\$79.99',
            period: 'per year',
            discount: 'Save 33%',
            features: const [
              'Everything in Monthly',
              'Annual forecast report',
              'Personalized remedies',
              'Exclusive webinars',
              '1-on-1 consultation (30 min)',
              'Gemstone recommendations',
            ],
            isPopular: false,
            badge: 'BEST VALUE',
            onSubscribe: () {
              _showSubscriptionDialog(context, 'Yearly', '\$79.99/year');
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          // Features comparison
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.purpleContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✨ Premium Benefits',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                const _BenefitItem(
                  icon: Icons.chat_bubble,
                  text: 'Unlimited conversations with expert astrologers',
                ),
                const _BenefitItem(
                  icon: Icons.star,
                  text: 'Personalized daily insights based on your chart',
                ),
                const _BenefitItem(
                  icon: Icons.favorite,
                  text: 'Compatibility analysis for relationships',
                ),
                const _BenefitItem(
                  icon: Icons.psychology,
                  text: 'AI-powered predictions and guidance',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showSubscriptionDialog(BuildContext context, String plan, String price) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Subscribe to $plan Plan'),
      content: Text(
        'You are about to subscribe to the $plan plan at $price.\n\n'
        'This is a demo app, so no actual payment will be processed.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Subscribed to $plan plan successfully! 🎉'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('Subscribe'),
        ),
      ],
    ),
  );
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String? discount;
  final List<String> features;
  final bool isPopular;
  final String? badge;
  final VoidCallback onSubscribe;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    this.discount,
    required this.features,
    required this.isPopular,
    this.badge,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isPopular ? AppColors.primaryPurple : Colors.grey.shade300,
          width: isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (discount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSM,
                          ),
                        ),
                        child: Text(
                          discount!,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        period,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: AppColors.primaryPurple,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: title == 'Free'
                      ? OutlinedButton(
                          onPressed: null,
                          child: const Text('Current Plan'),
                        )
                      : isPopular
                      ? FilledButton(
                          onPressed: onSubscribe,
                          child: const Text('Subscribe Now'),
                        )
                      : OutlinedButton(
                          onPressed: onSubscribe,
                          child: const Text('Subscribe Now'),
                        ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppSpacing.radiusLG),
                    bottomLeft: Radius.circular(AppSpacing.radiusMD),
                  ),
                ),
                child: Text(
                  badge!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryPurple),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
