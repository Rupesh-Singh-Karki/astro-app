import 'package:flutter/material.dart';
import '../../core/repositories/dummy_data.dart';
import '../../core/models/plan.dart';
import '../../core/widgets/primary_button.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = DummyData.plans();
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: plans.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _PlanDetailCard(plan: plans[index]),
      ),
    );
  }
}

class _PlanDetailCard extends StatelessWidget {
  final Plan plan;
  const _PlanDetailCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: cs.outlineVariant)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(plan.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plan.features
                  .map((f) => Chip(label: Text(f), backgroundColor: cs.secondaryContainer))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('₹${plan.pricePerMonth.toStringAsFixed(2)}/month',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.bold)),
                const Spacer(),
                PrimaryButton(label: 'Select', onPressed: () {}),
              ],
            )
          ],
        ),
      ),
    );
  }
}
