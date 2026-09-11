import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A model holding the extra profile details collected in the popup.
class RegistrationDetails {
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String city;

  const RegistrationDetails({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.city,
  });
}

/// Shows a popup asking for First Name, Last Name, Phone, Address, and City.
///
/// Returns a [RegistrationDetails] if the user fills the form and taps
/// "Confirm & Register", or `null` if they cancel/dismiss the dialog.
Future<RegistrationDetails?> showRegistrationDetailsDialog(
  BuildContext context,
) {
  return showDialog<RegistrationDetails>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _AdditionalDetailsDialog(),
  );
}

class _AdditionalDetailsDialog extends StatefulWidget {
  const _AdditionalDetailsDialog();

  @override
  State<_AdditionalDetailsDialog> createState() =>
      _AdditionalDetailsDialogState();
}

class _AdditionalDetailsDialogState extends State<_AdditionalDetailsDialog> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldLabel) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldLabel is required';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 7) return 'Enter a valid phone number';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      RegistrationDetails(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'A Few More Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Help us complete your profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _firstNameController,
                  decoration: _inputDecoration('First Name'),
                  validator: (v) => _requiredValidator(v, 'First name'),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _lastNameController,
                  decoration: _inputDecoration('Last Name'),
                  validator: (v) => _requiredValidator(v, 'Last name'),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Phone Number'),
                  validator: _phoneValidator,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _addressController,
                  decoration: _inputDecoration('Address'),
                  validator: (v) => _requiredValidator(v, 'Address'),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _cityController,
                  decoration: _inputDecoration('City'),
                  validator: (v) => _requiredValidator(v, 'City'),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.hintGrey.withValues(alpha: 0.25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}