import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/api_provider.dart';
import '../utils/logger.dart';

/// User details state
class UserDetails {
  final String id;
  final String userId;
  final String fullName;
  final String gender;
  final String maritalStatus;
  final DateTime dateOfBirth;
  final String timeOfBirth;
  final String placeOfBirth;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserDetails({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.gender,
    required this.maritalStatus,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.placeOfBirth,
    required this.timezone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      gender: json['gender'] as String,
      maritalStatus: json['marital_status'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      timeOfBirth: json['time_of_birth'] as String,
      placeOfBirth: json['place_of_birth'] as String,
      timezone: json['timezone'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Get zodiac sign from date of birth
  String get zodiacSign {
    final month = dateOfBirth.month;
    final day = dateOfBirth.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Scorpio';
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Sagittarius';
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'Capricorn';
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Aquarius';
    }
    return 'Pisces'; // (month == 2 && day >= 19) || (month == 3 && day <= 20)
  }

  /// Get zodiac sign emoji
  String get zodiacEmoji {
    switch (zodiacSign) {
      case 'Aries':
        return '♈';
      case 'Taurus':
        return '♉';
      case 'Gemini':
        return '♊';
      case 'Cancer':
        return '♋';
      case 'Leo':
        return '♌';
      case 'Virgo':
        return '♍';
      case 'Libra':
        return '♎';
      case 'Scorpio':
        return '♏';
      case 'Sagittarius':
        return '♐';
      case 'Capricorn':
        return '♑';
      case 'Aquarius':
        return '♒';
      case 'Pisces':
        return '♓';
      default:
        return '⭐';
    }
  }

  /// Get age from date of birth
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Get formatted birth date
  String get formattedBirthDate {
    final months = [
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
    return '${dateOfBirth.day} ${months[dateOfBirth.month - 1]} ${dateOfBirth.year}';
  }

  /// Get formatted birth time (12-hour format)
  String get formattedBirthTime {
    final parts = timeOfBirth.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }

  /// Get first name
  String get firstName {
    return fullName.split(' ').first;
  }
}

/// User details provider
final userDetailsProvider = FutureProvider<UserDetails?>((ref) async {
  try {
    final authApiService = ref.watch(authApiServiceProvider);
    final result = await authApiService.getUserDetails();

    return result.when(
      success: (data) {
        final userDetails = UserDetails.fromJson(data);
        AppLogger.info('User details loaded: ${userDetails.fullName}');
        return userDetails;
      },
      failure: (failure) {
        if (failure.message.contains('not found')) {
          AppLogger.info('User details not found - profile not completed');
          return null;
        }
        AppLogger.error('Failed to load user details: ${failure.message}');
        throw failure;
      },
    );
  } catch (e, stackTrace) {
    AppLogger.error('Error loading user details', e, stackTrace);
    rethrow;
  }
});
