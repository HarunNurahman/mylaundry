import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylaundry/configs/constants/app_color.dart';
import 'package:mylaundry/configs/constants/app_session.dart';
import 'package:mylaundry/models/user/user.dart';
import 'package:mylaundry/screen/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                AppSession.removeUser();
                AppSession.removeBearerToken();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSession.getUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        User user = snapshot.data!;
        return SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Text(
                'Account',
                style: GoogleFonts.poppins(
                  color: AppColor.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              buildUserInfo(user),
              const SizedBox(height: 24),
              buildSettingMenu(),
            ],
          ),
        );
      },
    );
  }

  Widget buildUserInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            SizedBox(
              width: 80,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        'Username',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMenuItem(() {}, Icons.image, 'Change Profile'),
            _buildMenuItem(() {}, Icons.edit, 'Edit Profile'),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                logout();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColor.grayColor),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Logout', style: GoogleFonts.poppins(fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSettingMenu() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        _buildMenuItem(
          () {},
          Icons.mode_night,
          'Dark Mode',
          trailing: Switch(
            value: false,
            onChanged: (value) {},
            activeColor: AppColor.primary,
          ),
        ),
        _buildMenuItem(() {}, Icons.translate, 'Language'),
        _buildMenuItem(() {}, Icons.notifications, 'Notification'),
        _buildMenuItem(() {}, Icons.feedback, 'Feedback'),
        _buildMenuItem(() {}, Icons.support_agent, 'Support'),
        _buildMenuItem(
          () {
            showAboutDialog(
              context: context,
              applicationIcon: Icon(
                Icons.local_laundry_service,
                size: 50,
                color: AppColor.primary,
              ),
              applicationName: 'My Laundry',
              applicationVersion: 'v0.0.1',
              children: [Text('Laundry app to monitor your laundry process')],
            );
          },
          Icons.info,
          'About',
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    VoidCallback onTap,
    IconData leading,
    String title, {
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      iconColor: AppColor.grayColor,
      contentPadding: EdgeInsets.zero,
      leading: Icon(leading, size: 32),
      trailing: trailing ?? Icon(Icons.chevron_right, size: 32),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
    );
  }
}
