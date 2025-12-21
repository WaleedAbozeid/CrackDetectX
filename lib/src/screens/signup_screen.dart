import 'package:flutter/material.dart';
import '../models/marketplace_full_models.dart';
import '../widgets/app_button.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String _passwordError = '';
  bool _isLoading = false;

  // Role Selection
  UserRole _selectedRole = UserRole.owner;

  // Engineer Fields
  late TextEditingController _syndicateController;
  late TextEditingController _experienceController;

  // Company Fields
  late TextEditingController _companyNameController;
  late TextEditingController _tradeLicenseController;
  late TextEditingController _taxIdController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Initialize new controllers
    _syndicateController = TextEditingController();
    _experienceController = TextEditingController();
    _companyNameController = TextEditingController();
    _tradeLicenseController = TextEditingController();
    _taxIdController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _syndicateController.dispose();
    _experienceController.dispose();
    _companyNameController.dispose();
    _tradeLicenseController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _passwordError = 'Passwords do not match');
      return;
    }

    setState(() {
      _passwordError = '';
      _isLoading = true;
    });

    try {
      if (_selectedRole == UserRole.owner) {
        await AuthService.instance.signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text,
        );
      } else if (_selectedRole == UserRole.engineer) {
        // Validate engineer fields
        if (_syndicateController.text.isEmpty ||
            _experienceController.text.isEmpty) {
          throw 'Please fill in all professional details';
        }
        await AuthService.instance.signUpEngineer(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text,
          syndicateNumber: _syndicateController.text,
          yearsOfExperience: int.tryParse(_experienceController.text) ?? 0,
          specializations: ['General'], // TODO: Add specialization picker
        );
      } else if (_selectedRole == UserRole.companyAdmin) {
        // Validate company fields
        if (_companyNameController.text.isEmpty ||
            _tradeLicenseController.text.isEmpty) {
          throw 'Please fill in all company details';
        }
        await AuthService.instance.signUpCompany(
          email: _emailController.text,
          password: _passwordController.text,
          companyName: _companyNameController.text,
          tradeLicense: _tradeLicenseController.text,
          taxId: _taxIdController.text,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          // Show full error text to help debugging (can be refined later)
          _passwordError = 'Signup failed: $e';
        });
      }
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                // App Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary900,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.apartment,
                    color: AppColors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Heading
                Text(
                  'Create Account',
                  style: AppTypography.h1.copyWith(color: AppColors.primary900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Role Selection
                Container(
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                  child: Row(
                    children: [
                      _buildRoleTab('Owner', UserRole.owner),
                      _buildRoleTab('Engineer', UserRole.engineer),
                      _buildRoleTab('Company', UserRole.companyAdmin),
                    ],
                  ),
                ),

                // Subheading
                Text(
                  'Join us to start inspecting',
                  style: AppTypography.bodyText,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Full Name Input
                _InputField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: AppSpacing.lg),

                if (_selectedRole == UserRole.engineer) ...[
                  _InputField(
                    label: 'Syndicate Number',
                    hint: 'e.g., 123456',
                    controller: _syndicateController,
                    prefixIcon: Icons.badge,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _InputField(
                    label: 'Years of Experience',
                    hint: 'e.g., 5',
                    controller: _experienceController,
                    prefixIcon: Icons.work_history,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                if (_selectedRole == UserRole.companyAdmin) ...[
                  _InputField(
                    label: 'Company Name',
                    hint: 'Official Company Name',
                    controller: _companyNameController,
                    prefixIcon: Icons.business,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _InputField(
                    label: 'Trade License No.',
                    hint: 'Commercial Register No.',
                    controller: _tradeLicenseController,
                    prefixIcon: Icons.verified_user,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _InputField(
                    label: 'Tax ID',
                    hint: 'Tax Identification Number',
                    controller: _taxIdController,
                    prefixIcon: Icons.receipt_long,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                const SizedBox(height: AppSpacing.lg),

                // Email Input
                _InputField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  prefixIcon: Icons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Password Input
                _InputField(
                  label: 'Password',
                  hint: 'Enter your password (min 6 characters)',
                  controller: _passwordController,
                  prefixIcon: Icons.lock,
                  obscureText: !_showPassword,
                  suffixIcon: _showPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onSuffixIconPressed: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                ),
                if (_passwordError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      _passwordError,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.dangerRed,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),

                // Confirm Password Input
                _InputField(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock,
                  obscureText: !_showConfirmPassword,
                  suffixIcon: _showConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onSuffixIconPressed: () {
                    setState(
                      () => _showConfirmPassword = !_showConfirmPassword,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Create Account Button
                AppButton(
                  title: _isLoading ? 'Creating...' : 'Create Account',
                  onPressed: _isLoading ? null : _handleSignup,
                  height: 56,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTypography.bodySmall,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: Text(
                        'Sign In',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Terms & Privacy
                Text(
                  'By creating an account, you agree to our Terms & Privacy Policy',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.grey500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(String title, UserRole role) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              color: isSelected ? AppColors.primary900 : AppColors.grey600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.h4),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.placeholder,
            ),
            prefixIcon: Icon(prefixIcon, color: AppColors.grey500),
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon, color: AppColors.grey500),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
            filled: true,
            fillColor: AppColors.grey50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              borderSide: const BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              borderSide: const BorderSide(color: AppColors.grey200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              borderSide: const BorderSide(
                color: AppColors.primary500,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ],
    );
  }
}
