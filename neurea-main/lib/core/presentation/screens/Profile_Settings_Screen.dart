// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/cubit/profile/profile_cubit.dart';
import 'package:neurea/cubit/profile/profile_state.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _fullNameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _initialized = false;

  static const _primary = Color(0xFF6B21A8);
  static const _accent = Color(0xFF7C3AED);
  static const _bg = Color(0xFFF4F4F8);
  static const _card = Colors.white;
  static const _labelColor = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _initFields(String fullName) {
    if (_initialized) return;
    _initialized = true;
    _fullNameController.text = fullName; 
  }

  void _save() {
    final fullName = _fullNameController.text.trim(); 
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (fullName.isEmpty) {
      return _error('Please enter your full name.');
    }
    if (newPass.isNotEmpty) {
      if (oldPass.isEmpty) return _error('Please enter your old password.');
      if (confirm.isEmpty) return _error('Please confirm your new password.');
      if (newPass != confirm) return _error('Passwords do not match.');
      if (newPass.length < 6) return _error('Password must be at least 6 characters.');
    }

    final firstSpace = fullName.indexOf(' ');
    String firstName, lastName;
    
    if (firstSpace == -1) {
      firstName = fullName;
      lastName = '';
    } else {
      firstName = fullName.substring(0, firstSpace);
      lastName = fullName.substring(firstSpace + 1);
    }

    context.read<ProfileCubit>().updateProfile(
      firstName: firstName,
      lastName: lastName,
    );
  }

  void _error(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red.shade400,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  void _success() => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Profile updated successfully!'),
      backgroundColor: _accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (ctx, state) {
        if (state is ProfileLoaded) {
          _initFields(state.name);
        }
        if (state is ProfileUpdated) {
          _success();
          Navigator.pop(ctx);
        }
        if (state is ProfileError) {
          _error(state.message);
        }
      },
      builder: (ctx, state) {
        if (state is ProfileLoaded && !_initialized) {
          _initFields(state.name);
        }

        final isLoading = state is ProfileLoading;
        final photoUrl = state is ProfileLoaded ? state.photoUrl : '';

        return Scaffold(
          backgroundColor: _bg,
          appBar: _buildAppBar(sw),
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: _accent))
              : ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: sh * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _avatar(sw, sh, photoUrl),
                        SizedBox(height: sh * 0.035),
                        _nameSection(sw),
                        SizedBox(height: sh * 0.025),
                        _passwordSection(sw, sh),
                        SizedBox(height: sh * 0.04),
                        _saveButton(sw, sh, isLoading),
                        SizedBox(height: sh * 0.03),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(double sw) => AppBar(
    backgroundColor: _bg,
    elevation: 0,
    centerTitle: true,
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: Color(0xFF1A1A2E),
        ),
      ),
    ),
    title: Text(
      'Profile Settings',
      style: TextStyle(
        fontSize: sw * 0.052,
        fontWeight: FontWeight.w700,
        color: _primary,
        letterSpacing: 0.3,
      ),
    ),
  );

  Widget _avatar(double sw, double sh, String photoUrl) {
    final size = sw * 0.26;
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => context.read<ProfileCubit>().pickAndUploadImage(),
            child: Stack(
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _accent, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: photoUrl.isNotEmpty
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, p) => p == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: _accent,
                                    ),
                                  ),
                            errorBuilder: (_, __, ___) => _defaultAvatar(),
                          )
                        : _defaultAvatar(),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: sw * 0.075,
                    height: sw * 0.075,
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: sw * 0.038,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: sh * 0.012),
          GestureDetector(
            onTap: () => context.read<ProfileCubit>().pickAndUploadImage(),
            child: Text(
              'Edit picture',
              style: TextStyle(
                color: _accent,
                fontSize: sw * 0.037,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() => Container(
    color: const Color(0xFFEDE9FE),
    child: const Icon(Icons.person, size: 50, color: _accent),
  );

  Widget _nameSection(double sw) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('Full Name', sw),
      SizedBox(height: sw * 0.022),
      _inputField(_fullNameController, 'Enter your full name', sw),
    ],
  );

  Widget _passwordSection(double sw, double sh) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('Old Password', sw),
      SizedBox(height: sw * 0.022),
      _passwordField(
        _oldPasswordController,
        'Old Password',
        _showOld,
        sw,
        () => setState(() => _showOld = !_showOld),
      ),
      SizedBox(height: sh * 0.022),
      _label('New Password', sw),
      SizedBox(height: sw * 0.022),
      _passwordField(
        _newPasswordController,
        'New Password',
        _showNew,
        sw,
        () => setState(() => _showNew = !_showNew),
      ),
      SizedBox(height: sh * 0.022),
      _label('Confirm new Password', sw),
      SizedBox(height: sw * 0.022),
      _passwordField(
        _confirmPasswordController,
        'Confirm Password',
        _showConfirm,
        sw,
        () => setState(() => _showConfirm = !_showConfirm),
      ),
    ],
  );

  Widget _saveButton(double sw, double sh, bool isLoading) => SizedBox(
    width: double.infinity,
    height: sh * 0.068,
    child: ElevatedButton(
      onPressed: isLoading ? null : _save,
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sw * 0.04),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Text(
              'Save Updates',
              style: TextStyle(
                fontSize: sw * 0.042,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
    ),
  );

  Widget _label(String text, double sw) => Text(
    text,
    style: TextStyle(
      fontSize: sw * 0.034,
      fontWeight: FontWeight.w600,
      color: _labelColor,
      letterSpacing: 0.2,
    ),
  );

  Widget _inputField(TextEditingController ctrl, String hint, double sw) =>
      Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(sw * 0.035),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: ctrl,
          style: TextStyle(
            fontSize: sw * 0.037,
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: sw * 0.036,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: sw * 0.042,
              vertical: sw * 0.038,
            ),
          ),
        ),
      );

  Widget _passwordField(
    TextEditingController ctrl,
    String hint,
    bool show,
    double sw,
    VoidCallback toggle,
  ) => Container(
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(sw * 0.035),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: TextField(
      controller: ctrl,
      obscureText: !show,
      style: TextStyle(
        fontSize: sw * 0.037,
        color: const Color(0xFF1A1A2E),
        fontWeight: FontWeight.w500,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: sw * 0.036,
          letterSpacing: 0,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: sw * 0.042,
          vertical: sw * 0.038,
        ),
        suffixIcon: GestureDetector(
          onTap: toggle,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              show ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey.shade400,
              size: sw * 0.052,
            ),
          ),
        ),
      ),
    ),
  );
}