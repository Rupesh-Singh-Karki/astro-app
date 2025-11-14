import 'package:flutter/material.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'name': 'English', 'code': 'en', 'flag': '🇬🇧'},
      {'name': 'हिन्दी', 'code': 'hi', 'flag': '🇮🇳'},
      {'name': 'Español', 'code': 'es', 'flag': '🇪🇸'},
      {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
      {'name': '中文', 'code': 'zh', 'flag': '🇨🇳'},
    ];

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Select your preferred language',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          ...languages.map((lang) => _LanguageTile(
                flag: lang['flag']!,
                name: lang['name']!,
                code: lang['code']!,
                isSelected: lang['code'] == 'en',
              )),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String flag;
  final String name;
  final String code;
  final bool isSelected;

  const _LanguageTile({
    required this.flag,
    required this.name,
    required this.code,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 32)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name selected')),
        );
      },
    );
  }
}
