
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';


class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: const Text('Activity History'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          activityCard(
            icon: Icons.person_add_alt_1,
            title: 'Employee Added',
            subtitle: 'A new employee was added to the system.',
            time: 'Today',
          ),

          activityCard(
            icon: Icons.edit_outlined,
            title: 'Employee Details Updated',
            subtitle: 'Employee information was updated.',
            time: 'Yesterday',
          ),

          activityCard(
            icon: Icons.fact_check_outlined,
            title: 'Attendance Recorded',
            subtitle: 'Employee attendance was recorded.',
            time: 'Yesterday',
          ),

          activityCard(
            icon: Icons.assessment_outlined,
            title: 'Attendance Report',
            subtitle: 'Attendance report was viewed.',
            time: '2 days ago',
          ),
        ],
      ),
    );
  }

  // Displays one activity
  Widget activityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.lightBlueColor,
            child: Icon(
              icon,
              color: AppColors.primaryColor,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.greyColor,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyColor,
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
