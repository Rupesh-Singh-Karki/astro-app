import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../auth/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthController>().email ?? 'User';
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        children: [
          // Profile section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View Profile',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ],
            ),
          ),
          const Divider(),
          
          // Menu items
          _SettingsTile(
            icon: Icons.history,
            title: 'My Activity',
            subtitle: 'View your astrology journey',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('My Activity - Coming soon')),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.card_giftcard,
            title: 'Credits',
            subtitle: 'Manage your credits',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Credits - Coming soon')),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.shopping_bag_outlined,
            title: 'Shop',
            subtitle: 'Browse our products',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Shop - Coming soon')),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.support_agent,
            title: 'Support',
            subtitle: 'Get help and contact us',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support - Coming soon')),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms and Conditions',
            subtitle: 'Read our terms',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms and Conditions - Coming soon')),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.gavel,
            title: 'Legal',
            subtitle: 'Privacy policy and legal info',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Legal - Coming soon')),
              );
            },
          ),
          
          const Divider(height: 32),
          
          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<AuthController>().logout();
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
