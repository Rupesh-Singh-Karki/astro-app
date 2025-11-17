/// Represents a subscription plan available in the application.
///
/// Contains plan details, pricing, and features.
class Plan {
  const Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerMonth,
    required this.features,
    this.isPopular = false,
    this.isFeatured = false,
    this.durationMonths = 1,
    this.discount,
  });

  final String id;
  final String name;
  final String description;
  final double pricePerMonth;
  final List<String> features;
  final bool isPopular;
  final bool isFeatured;
  final int durationMonths;
  final Discount? discount;

  /// Calculate total price for the plan duration
  double get totalPrice {
    final basePrice = pricePerMonth * durationMonths;
    if (discount != null) {
      return basePrice - (basePrice * discount!.percentage / 100);
    }
    return basePrice;
  }

  /// Get price per month after discount
  double get effectivePricePerMonth {
    if (discount != null) {
      return pricePerMonth - (pricePerMonth * discount!.percentage / 100);
    }
    return pricePerMonth;
  }

  /// Format price for display
  String get formattedPrice => '\$${pricePerMonth.toStringAsFixed(2)}';

  /// Format total price for display
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Creates a copy with updated fields
  Plan copyWith({
    String? id,
    String? name,
    String? description,
    double? pricePerMonth,
    List<String>? features,
    bool? isPopular,
    bool? isFeatured,
    int? durationMonths,
    Discount? discount,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pricePerMonth: pricePerMonth ?? this.pricePerMonth,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
      isFeatured: isFeatured ?? this.isFeatured,
      durationMonths: durationMonths ?? this.durationMonths,
      discount: discount ?? this.discount,
    );
  }

  /// Creates from JSON
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pricePerMonth: (json['pricePerMonth'] as num).toDouble(),
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isPopular: json['isPopular'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      durationMonths: json['durationMonths'] as int? ?? 1,
      discount: json['discount'] != null
          ? Discount.fromJson(json['discount'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pricePerMonth': pricePerMonth,
      'features': features,
      'isPopular': isPopular,
      'isFeatured': isFeatured,
      'durationMonths': durationMonths,
      'discount': discount?.toJson(),
    };
  }

  @override
  String toString() => 'Plan(id: $id, name: $name, price: $formattedPrice)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Plan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a discount applied to a plan
class Discount {
  const Discount({
    required this.percentage,
    required this.validUntil,
    this.code,
  });

  final double percentage;
  final DateTime validUntil;
  final String? code;

  /// Whether the discount is still valid
  bool get isValid => DateTime.now().isBefore(validUntil);

  /// Creates from JSON
  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      percentage: (json['percentage'] as num).toDouble(),
      validUntil: DateTime.parse(json['validUntil'] as String),
      code: json['code'] as String?,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'validUntil': validUntil.toIso8601String(),
      'code': code,
    };
  }
}
