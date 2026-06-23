import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:gap/gap.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _nameController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _circleController = TextEditingController();
  
  String? _selectedRole;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _roles = [
    'Account Manager',
    'Zonal Sales Manager',
    'Circle Business Head',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _circleController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedRole == null) {
      setState(() {
        _errorMessage = 'Employee Name and Role are required.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).loginLocally(
        fullName: name,
        role: _selectedRole!,
        employeeId: _employeeIdController.text.trim().isNotEmpty ? _employeeIdController.text.trim() : null,
        circle: _circleController.text.trim().isNotEmpty ? _circleController.text.trim() : null,
      );
      // GoRouter will automatically redirect via redirect logic based on auth state
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(
                'assets/images/airtel_logo.svg',
                width: 60,
                height: 60,
                colorFilter: const ColorFilter.mode(AppConstants.primaryColor, BlendMode.srcIn),
              ),
              const Gap(16),
              const Text(
                'Airtel Nexus',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
              const Text(
                'Empowering Enterprise Relationships',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textColor,
                ),
              ),
              const Gap(48),
              
              // Employee Name (Required)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Employee Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const Gap(16),
              
              // Role Dropdown (Required)
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedRole = val;
                  });
                },
              ),
              const Gap(16),

              // Employee ID (Optional)
              TextField(
                controller: _employeeIdController,
                decoration: const InputDecoration(
                  labelText: 'Employee ID (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const Gap(16),

              // Circle (Optional)
              TextField(
                controller: _circleController,
                decoration: const InputDecoration(
                  labelText: 'Circle (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const Gap(24),

              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
              ],
              
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
