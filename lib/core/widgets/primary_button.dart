import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;

  const PrimaryButton({super.key, required this.label, this.onPressed, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return outlined
        ? OutlinedButton(onPressed: onPressed, child: Text(label))
        : ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
