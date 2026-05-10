// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/core/presentation/screens/Emergency_Contact_profile.dart';
import 'package:neurea/core/presentation/screens/Help_Center_Screen.dart';
import 'package:neurea/core/presentation/screens/Make_Report_Screen.dart';
import 'package:neurea/core/presentation/screens/Privacy_Policy_Screen.dart';
import 'package:neurea/core/presentation/screens/Profile_Settings_Screen.dart';
import 'package:neurea/core/presentation/screens/account_Notification.dart';
import 'package:neurea/core/presentation/screens/pro_profile.dart';
import 'package:neurea/cubit/profile/profile_cubit.dart';
import 'package:neurea/cubit/profile/profile_state.dart';
import 'package:neurea/Service/Auth_Service.dart';
import 'package:neurea/features/login_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadProfile(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  bool _darkMode = false;

  static const _purple = Color(0xFF7C3AED);
  static const _darkBg = Colors.black;
  static const _lightBg = Colors.white;
  static const _darkCard = Color(0xff1c1c1e);
  static const _lightCard = Color(0xfff4f4f4);

  Color get _bg => _darkMode ? _darkBg : _lightBg;
  Color get _card => _darkMode ? _darkCard : _lightCard;
  Color get _textColor => _darkMode ? Colors.white : Colors.black;

  void _showLogoutDialog(BuildContext ctx) {
    final sw = MediaQuery.of(ctx).size.width;
    final sh = MediaQuery.of(ctx).size.height;

    showDialog(
      context: ctx,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: EdgeInsets.all(sw * 0.06),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: sw * 0.15,
                height: sw * 0.15,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade400,
                  size: sw * 0.07,
                ),
              ),
              SizedBox(height: sh * 0.02),
              Text(
                'Log out',
                style: TextStyle(
                  fontSize: sw * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: sh * 0.012),
              Text(
                'Are you sure you want to log out of\nyour Neurea account? You will need\nto log in again to access your data.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sw * 0.033,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              SizedBox(height: sh * 0.03),
              _dialogButton(
                label: 'Yes, Log Out',
                color: Colors.red,
                textColor: Colors.white,
                sw: sw,
                sh: sh,
                onTap: () async {
                  Navigator.pop(ctx);
                  await AuthService.signOut();
                  if (ctx.mounted) {
                    Navigator.pushAndRemoveUntil(
                      ctx,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                      (_) => false,
                    );
                  }
                },
              ),
              SizedBox(height: sh * 0.012),
              _dialogButton(
                label: 'Cancel',
                color: Colors.transparent,
                textColor: Colors.black,
                sw: sw,
                sh: sh,
                bordered: true,
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogButton({
    required String label,
    required Color color,
    required Color textColor,
    required double sw,
    required double sh,
    required VoidCallback onTap,
    bool bordered = false,
  }) => SizedBox(
    width: double.infinity,
    height: sh * 0.065,
    child: bordered
        ? OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: sw * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: sw * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
  );

  AppBar _buildAppBar(double sw) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.only(left: sw * 0.04),
        child: Text(
          'Profile',
          style: TextStyle(
            color: _textColor,
            fontSize: sw * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(sw),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: sw * 0.04,
            vertical: sh * 0.02,
          ),
          child: Column(
            children: [
              _profileHeader(context, sw, sh),
              SizedBox(height: sh * 0.025),
              _proCard(context, sw, sh),
              SizedBox(height: sh * 0.02),
              _sectionCard(sw, [
                _darkModeTile(sw),
                _navTile(
                  context: context,
                  sw: sw,
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                  dest: const AccountNotification(),
                ),
                _assetTile(
                  context: context,
                  sw: sw,
                  asset: 'assets/Emergency contact.png',
                  label: 'Emergency contact',
                  dest: const EmergencyContactProfile(),
                ),
              ]),
              SizedBox(height: sh * 0.02),
              _sectionCard(sw, [
                _assetTile(
                  context: context,
                  sw: sw,
                  asset: 'assets/Get help.png',
                  label: 'Get help',
                  dest: const HelpCenterScreen(),
                ),
                _assetTile(
                  context: context,
                  sw: sw,
                  asset: 'assets/Privacy and Policy.png',
                  label: 'Privacy and Policy',
                  dest: const PrivacyPolicyScreen(),
                ),
                _assetTile(
                  context: context,
                  sw: sw,
                  asset: 'assets/Make a report.png',
                  label: 'Make a report',
                  dest: const MakeReportScreen(),
                ),
                _logoutTile(context, sw),
              ]),
              SizedBox(height: sh * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context, double sw, double sh) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final fullName = state is ProfileLoaded ? state.name : '';
        String firstName = fullName.trim().split(' ')[0];
        firstName = firstName.replaceAll(RegExp(r'[0-9]'), '');
        final email = state is ProfileLoaded ? state.email : '';
        final photoUrl = state is ProfileLoaded ? state.photoUrl : '';

        return Container(
          padding: EdgeInsets.all(sw * 0.045),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: sw * 0.19,
                    height: sw * 0.19,
                    decoration: const BoxDecoration(
                      color: Color(0xffd9caff),
                      shape: BoxShape.circle,
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
                                        color: _purple,
                                      ),
                                    ),
                              errorBuilder: (_, __, ___) =>
                                  Image.asset('assets/profile (2).png'),
                            )
                          : Image.asset('assets/profile (2).png'),
                    ),
                  ),
           Positioned(
  right: 0,
  bottom: 0,
  child: GestureDetector(
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ProfileCubit>(),
            child: const ProfileSettingsScreen(),
          ),
        ),
      );
      if (context.mounted) {
        context.read<ProfileCubit>().loadProfile();
      }
    },
    child: Container(
      width: sw * 0.07,
      height: sw * 0.07,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.edit,
        size: sw * 0.035,
        color: Colors.blueGrey,
      ),
    ),
  ),
),
                ],
              ),
              SizedBox(width: sw * 0.045),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName.isNotEmpty ? firstName : fullName,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: sw * 0.048,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: sh * 0.004),
                    Text(
                      email,
                      style: TextStyle(
                        color: _textColor.withOpacity(0.6),
                        fontSize: sw * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _proCard(BuildContext context, double sw, double sh) {
    return Container(
      padding: EdgeInsets.all(sw * 0.045),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.diamond_rounded, size: sw * 0.085, color: _textColor),
          SizedBox(width: sw * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Neurea Pro',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: sw * 0.043,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: sh * 0.004),
                Text(
                  'Unlock extra insights',
                  style: TextStyle(
                    color: _textColor.withOpacity(0.6),
                    fontSize: sw * 0.035,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProProfile()),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.045,
                vertical: sw * 0.025,
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'upgrade',
                style: TextStyle(color: Colors.white, fontSize: sw * 0.035),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(double sw, List<Widget> tiles) => Container(
    padding: EdgeInsets.symmetric(vertical: sw * 0.02),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(children: tiles),
  );

  Widget _darkModeTile(double sw) => ListTile(
    leading: Icon(
      Icons.dark_mode_outlined,
      color: _textColor,
      size: sw * 0.055,
    ),
    title: Text(
      'Dark mode',
      style: TextStyle(color: _textColor, fontSize: sw * 0.04),
    ),
    trailing: CupertinoSwitch(
      value: _darkMode,
      onChanged: (v) => setState(() => _darkMode = v),
      activeTrackColor: Colors.black,
      inactiveTrackColor: Colors.grey.shade700,
    ),
  );

  Widget _navTile({
    required BuildContext context,
    required double sw,
    required IconData icon,
    required String label,
    required Widget dest,
  }) => ListTile(
    leading: Icon(icon, color: _textColor, size: sw * 0.055),
    title: Text(
      label,
      style: TextStyle(color: _textColor, fontSize: sw * 0.04),
    ),
    trailing: Icon(Icons.arrow_forward_ios, size: sw * 0.04, color: _textColor),
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => dest)),
  );

  Widget _assetTile({
    required BuildContext context,
    required double sw,
    required String asset,
    required String label,
    required Widget dest,
  }) => ListTile(
    leading: Image.asset(asset, width: sw * 0.055, color: _textColor),
    title: Text(
      label,
      style: TextStyle(color: _textColor, fontSize: sw * 0.04),
    ),
    trailing: Icon(Icons.arrow_forward_ios, size: sw * 0.04, color: _textColor),
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => dest)),
  );

  Widget _logoutTile(BuildContext context, double sw) => ListTile(
    leading: Icon(
      Icons.logout_rounded,
      color: Colors.red.shade400,
      size: sw * 0.055,
    ),
    title: Text(
      'Log out',
      style: TextStyle(
        color: Colors.red,
        fontSize: sw * 0.04,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: sw * 0.04,
      color: Colors.red.shade300,
    ),
    onTap: () => _showLogoutDialog(context),
  );
}