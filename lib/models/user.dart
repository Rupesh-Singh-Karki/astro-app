/// Represents a user in the application.
///
/// Contains user authentication and profile information.
class User {
  const User({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.profileImageUrl,
    this.createdAt,
    this.subscription,
  });

  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final DateTime? birthDate;
  final String? birthTime; // Format: "HH:mm"
  final String? birthPlace;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final UserSubscription? subscription;

  /// Creates a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    DateTime? birthDate,
    String? birthTime,
    String? birthPlace,
    String? profileImageUrl,
    DateTime? createdAt,
    UserSubscription? subscription,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      subscription: subscription ?? this.subscription,
    );
  }

  /// Creates a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      birthTime: json['birthTime'] as String?,
      birthPlace: json['birthPlace'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      subscription: json['subscription'] != null
          ? UserSubscription.fromJson(
              json['subscription'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate?.toIso8601String(),
      'birthTime': birthTime,
      'birthPlace': birthPlace,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'subscription': subscription?.toJson(),
    };
  }

  /// Returns display name (name or email)
  String get displayName => name ?? email.split('@').first;

  /// Returns whether user has complete profile
  bool get hasCompleteProfile =>
      name != null &&
      birthDate != null &&
      birthTime != null &&
      birthPlace != null;

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a user's subscription details.
class UserSubscription {
  const UserSubscription({
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.autoRenew = true,
  });

  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool autoRenew;

  /// Whether subscription is expired
  bool get isExpired => DateTime.now().isAfter(endDate);

  /// Days remaining in subscription
  int get daysRemaining {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }

  /// Creates a copy with updated fields
  UserSubscription copyWith({
    String? planId,
    String? planName,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    bool? autoRenew,
  }) {
    return UserSubscription(
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      autoRenew: autoRenew ?? this.autoRenew,
    );
  }

  /// Creates from JSON
  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      planId: json['planId'] as String,
      planName: json['planName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      autoRenew: json['autoRenew'] as bool? ?? true,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'autoRenew': autoRenew,
    };
  }
}
