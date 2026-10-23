
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              // Profile picture
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.lightBlueColor,
                child: Icon(
                  Icons.person,
                  size: 55,
                  color: AppColors.primaryColor,
                ),
              ),

              const SizedBox(height: 18),

              // User name
              const Text(
                'Admin User',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Administrator',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.greyColor,
                ),
              ),

              const SizedBox(height: 28),

              // User email
              profileCard(
                Icons.email_outlined,
                'Email',
                'admin@example.com',
              ),

              // User role
              profileCard(
                Icons.work_outline,
                'Role',
                'Administrator',
              ),

              // Application name
              profileCard(
                Icons.business_outlined,
                'Application',
                AppStrings.appName,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Displays one profile detail
  Widget profileCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.borderColor,
        ),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: 26,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
