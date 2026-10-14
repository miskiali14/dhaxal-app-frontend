import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_graduated/screens/Sigin_screen.dart';
import 'package:project_graduated/screens/Singup_screen.dart';
import 'package:project_graduated/screens/help_screen.dart';
import 'package:project_graduated/provide/user_provider.dart';
import 'package:project_graduated/screens/settings_screen.dart';
import 'package:project_graduated/screens/update_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserProvider>(context, listen: false).loadUserFromStorage();
      });
    });
  }

  String _safeImage(String? image) {
    if (image == null || image.trim().isEmpty) {
      return '';
    }
    return image;
  }

  void _onProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateProfile()),
    );
  }

  void _onSettingsTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _onSignInTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SigIn()),
    );
  }

  void _onSignUpTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }

  void _onHelpCenterTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
  }

  void _onLogOutTap() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Ka bax koontada',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Ma hubtaa inaad ka baxayso koontadaada?',
            style: TextStyle(
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Maya',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (e) => const SigIn()),
                  (route) => false,
                );
              },
              child: const Text(
                'Haa',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showProfilePhoto(BuildContext context, String imageUrl) {
    if (imageUrl.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 80,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.user;
            final imageUrl = _safeImage(user?.image);

            final bool isGuest = user == null;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  _buildHeader(
                    imageUrl: imageUrl,
                    name: user?.name ?? 'Martida (Guest)',
                    email: user?.email ?? 'Ma aadan gelin koonto',
                  ),
                  const SizedBox(height: 18),
                  if (isGuest) ...[
                    _buildActionTile(
                      icon: Icons.login_rounded,
                      title: 'Soo Gal',
                      subtitle: 'Gal koontadaada si aad u keydiso natiijooyinka',
                      onTap: _onSignInTap,
                    ),
                    _buildActionTile(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Diiwaangeli',
                      subtitle: 'Samee koonto cusub',
                      onTap: _onSignUpTap,
                    ),
                    _buildActionTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Center',
                      subtitle: 'Caawimaad iyo hagitaan',
                      onTap: _onHelpCenterTap,
                    ),
                  ] else ...[
                    _buildActionTile(
                      icon: Iconsax.profile_circle,
                      title: 'Profile-kaaga',
                      subtitle: 'Cusbooneysii xogtaada',
                      onTap: _onProfileTap,
                    ),
                    _buildActionTile(
                      icon: Iconsax.setting_2,
                      title: 'Settings',
                      subtitle: 'Beddel password-ka ama tirtir koontada',
                      onTap: _onSettingsTap,
                    ),
                    _buildActionTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Center',
                      subtitle: 'Caawimaad iyo hagitaan',
                      onTap: _onHelpCenterTap,
                    ),
                    _buildActionTile(
                      icon: Iconsax.logout,
                      title: 'Log Out',
                      subtitle: 'Ka bax koontadaada',
                      onTap: _onLogOutTap,
                      isLogout: true,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader({
    required String imageUrl,
    required String name,
    required String email,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF2F5D8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showProfilePhoto(context, imageUrl),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accentColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: imageUrl.isEmpty
                      ? const Icon(
                          Icons.person_rounded,
                          size: 56,
                          color: primaryColor,
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: accentColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return const Icon(
                              Icons.person_rounded,
                              size: 56,
                              color: primaryColor,
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final iconColor = isLogout ? Colors.red : primaryColor;
    final iconBg =
        isLogout ? Colors.red.withOpacity(0.10) : accentColor.withOpacity(0.15);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          splashColor: accentColor.withOpacity(0.10),
          highlightColor: accentColor.withOpacity(0.05),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: iconBg,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: iconColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 15.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
