class Plan {
  final String id;
  final String name;
  final String description;
  final double pricePerMonth;
  final List<String> features;

  const Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerMonth,
    required this.features,
  });
}
