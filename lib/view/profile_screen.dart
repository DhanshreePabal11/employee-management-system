
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../custom_widgets/bottom_nav_bar.dart';
import '../model/user_session.dart';
import '../repo/employee_repo.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'employee_list_screen.dart';
import 'attendence_screen.dart';
import 'attendence_reports_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String email;
  String role = 'User';

  final EmployeeRepo employeeRepo = EmployeeRepo();

  @override
  void initState() {
    super.initState();
    name = UserSession.name;
    email = UserSession.email;
  }

  void editProfile() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return EditProfileDialog(
          initialName: name,
          initialEmail: email,
          onSave: (newName, newEmail) {
            setState(() {
              name = newName;
              email = newEmail;
              UserSession.email = newEmail;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
              ),
            );
          },
        );
      },
    );
  }

  void logout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                UserSession.email = '';
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.whiteColor,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void navigateToScreen(int index) {
    if (index == 4) return;

    Widget screen;

    if (index == 0) {
      screen = const DashboardScreen();
    } else if (index == 1) {
      screen = EmployeeListScreen(
        employeeRepo: employeeRepo,
      );
    } else if (index == 2) {
      screen = const AttendenceScreen();
    } else {
      screen = const AttendenceReportsScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role,
                style: const TextStyle(
                  color: Color(0xFF172554),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 25),

            _buildSectionTitle('Personal Information'),

            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.person_outline,
              title: 'Full Name',
              value: name,
            ),

            _buildInfoCard(
              icon: Icons.email_outlined,
              title: 'Email Address',
              value: email,
            ),

            _buildInfoCard(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Role',
              value: role,
            ),

            const SizedBox(height: 25),

            _buildSectionTitle('Profile Settings'),

            const SizedBox(height: 12),

            Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF172554),
                ),
                title: const Text('Edit Profile'),
                subtitle: const Text('Update your name and email'),
                trailing: const Icon(Icons.chevron_right),
                onTap: editProfile,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 4,
        onItemTapped: navigateToScreen,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF172554),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172554),
          ),
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final void Function(String name, String email) onSave;

  const EditProfileDialog({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveProfile() {
    final newName = nameController.text.trim();
    final newEmail = emailController.text.trim();

    if (newName.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid name and email.'),
        ),
      );
      return;
    }

    widget.onSave(newName, newEmail);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
