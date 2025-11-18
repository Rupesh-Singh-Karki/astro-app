import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_spacing.dart';
import '../../providers/api_provider.dart';
import '../../utils/logger.dart';
import '../home/main_scaffold_screen.dart';

/// Profile screen for detailed user information
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.isFirstTime = false, this.email});

  final bool isFirstTime;
  final String? email;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _placeOfBirthController = TextEditingController();

  String _gender = 'Male';
  String _maritalStatus = 'Single';
  DateTime? _dateOfBirth;
  TimeOfDay? _timeOfBirth;
  String _timezone = 'UTC';
  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatusOptions = ['Single', 'Married'];
  final List<String> _timezones = [
    'Pacific/Midway',
    'Pacific/Honolulu',
    'America/Anchorage',
    'America/Los_Angeles',
    'America/Denver',
    'America/Chicago',
    'America/New_York',
    'America/Halifax',
    'America/Sao_Paulo',
    'Atlantic/Azores',
    'UTC',
    'Europe/London',
    'Europe/Paris',
    'Europe/Athens',
    'Europe/Moscow',
    'Asia/Dubai',
    'Asia/Karachi',
    'Asia/Kolkata',
    'Asia/Dhaka',
    'Asia/Bangkok',
    'Asia/Shanghai',
    'Asia/Tokyo',
    'Australia/Sydney',
    'Pacific/Auckland',
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.isFirstTime) {
      _loadExistingProfile();
    }
  }

  Future<void> _loadExistingProfile() async {
    setState(() => _isLoading = true);

    try {
      final authApiService = ref.read(authApiServiceProvider);
      final result = await authApiService.getUserDetails();

      result.when(
        success: (data) {
          setState(() {
            _fullNameController.text = data['full_name'] as String;
            _gender = _capitalize(data['gender'] as String);
            _maritalStatus = _capitalize(data['marital_status'] as String);
            _dateOfBirth = DateTime.parse(data['date_of_birth'] as String);

            final timeOfBirth = data['time_of_birth'] as String;
            final timeParts = timeOfBirth.split(':');
            _timeOfBirth = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );

            _placeOfBirthController.text = data['place_of_birth'] as String;
            _timezone = data['timezone'] as String;
            _isLoading = false;
          });

          AppLogger.info('Existing profile loaded');
        },
        failure: (failure) {
          setState(() => _isLoading = false);
          AppLogger.error('Failed to load profile: ${failure.message}');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to load profile: ${failure.displayMessage}',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading profile', e, stackTrace);
      setState(() => _isLoading = false);
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _placeOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _timeOfBirth ?? TimeOfDay.now(),
      helpText: 'Select Time of Birth',
    );
    if (picked != null) {
      setState(() => _timeOfBirth = picked);
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_dateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date of birth')),
        );
        return;
      }
      if (_timeOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select time of birth')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );

      if (widget.isFirstTime) {
        // First time user - register details via API
        if (widget.email != null) {
          final authApiService = ref.read(authApiServiceProvider);

          // Format gender and marital status to match API format
          final genderLower = _gender
              .toLowerCase(); // 'male', 'female', or 'other'
          final maritalLower = _maritalStatus
              .toLowerCase(); // 'single' or 'married'

          // Format date and time for API
          final dateStr =
              '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}';
          final timeStr =
              '${_timeOfBirth!.hour.toString().padLeft(2, '0')}:${_timeOfBirth!.minute.toString().padLeft(2, '0')}:00';

          final registerResult = await authApiService.registerDetails(
            fullName: _fullNameController.text.trim(),
            gender: genderLower,
            maritalStatus: maritalLower,
            dateOfBirth: dateStr,
            timeOfBirth: timeStr,
            placeOfBirth: _placeOfBirthController.text.trim(),
            timezone: _timezone, // Use timezone identifier directly
          );

          if (!mounted) return;

          registerResult.when(
            success: (_) {
              // Navigate to home screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainScaffoldScreen(),
                ),
              );
            },
            failure: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${failure.displayMessage}'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
          );
        }
      } else {
        // Existing user - update details via PUT API
        final authApiService = ref.read(authApiServiceProvider);

        // Format gender and marital status to match API format
        final genderLower = _gender
            .toLowerCase(); // 'male', 'female', or 'other'
        final maritalLower = _maritalStatus
            .toLowerCase(); // 'single' or 'married'

        // Format date and time for API
        final dateStr =
            '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}';
        final timeStr =
            '${_timeOfBirth!.hour.toString().padLeft(2, '0')}:${_timeOfBirth!.minute.toString().padLeft(2, '0')}:00';

        final updateResult = await authApiService.updateUserDetails(
          fullName: _fullNameController.text.trim(),
          gender: genderLower,
          maritalStatus: maritalLower,
          dateOfBirth: dateStr,
          timeOfBirth: timeStr,
          placeOfBirth: _placeOfBirthController.text.trim(),
          timezone: _timezone,
        );

        if (!mounted) return;

        updateResult.when(
          success: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          },
          failure: (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${failure.displayMessage}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFirstTime ? 'Complete Your Profile' : 'Edit Profile',
        ),
        automaticallyImplyLeading: !widget.isFirstTime,
        actions: [
          TextButton(onPressed: _saveProfile, child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.lg),
          children: [
            // Full Name
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                hintText: 'Enter your full name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg),

            // Gender
            // ignore: deprecated_member_use
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                prefixIcon: Icon(Icons.wc),
              ),
              items: _genderOptions.map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _gender = value);
                }
              },
            ),
            SizedBox(height: AppSpacing.lg),

            // Marital Status
            // ignore: deprecated_member_use
            DropdownButtonFormField<String>(
              value: _maritalStatus,
              decoration: const InputDecoration(
                labelText: 'Marital Status',
                prefixIcon: Icon(Icons.favorite),
              ),
              items: _maritalStatusOptions.map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _maritalStatus = value);
                }
              },
            ),
            SizedBox(height: AppSpacing.lg),

            // Date of Birth
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'Select date of birth',
                ),
                child: Text(
                  _dateOfBirth != null
                      ? _formatDate(_dateOfBirth!)
                      : 'Select date of birth',
                  style: TextStyle(
                    color: _dateOfBirth != null
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Time of Birth
            InkWell(
              onTap: _selectTime,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Time of Birth',
                  prefixIcon: Icon(Icons.access_time),
                  hintText: 'Select time of birth',
                ),
                child: Text(
                  _timeOfBirth != null
                      ? _formatTime(_timeOfBirth!)
                      : 'Select time of birth',
                  style: TextStyle(
                    color: _timeOfBirth != null
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Place of Birth
            TextFormField(
              controller: _placeOfBirthController,
              decoration: const InputDecoration(
                labelText: 'Place of Birth',
                prefixIcon: Icon(Icons.location_on),
                hintText: 'Enter place of birth',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter place of birth';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg),

            // Timezone
            // ignore: deprecated_member_use
            DropdownButtonFormField<String>(
              value: _timezone,
              decoration: const InputDecoration(
                labelText: 'Timezone',
                prefixIcon: Icon(Icons.public),
              ),
              items: _timezones.map((tz) {
                return DropdownMenuItem(
                  value: tz,
                  child: Text(tz, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _timezone = value);
                }
              },
            ),
            SizedBox(height: AppSpacing.xxl),

            // Save Button
            FilledButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save),
              label: const Text('Save Profile'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.all(AppSpacing.md),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
