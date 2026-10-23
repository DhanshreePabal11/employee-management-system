
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class AttendenceScreen extends StatelessWidget {
  const AttendenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: const Text(AppStrings.attendance),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Manage daily employee attendance.',
              style: TextStyle(
                color: AppColors.greyColor,
              ),
            ),

            const SizedBox(height: 24),

            // Present employees
            attendanceCard(
              'Present',
              '0',
              Icons.check_circle_outline,
              AppColors.greenColor,
            ),

            // Absent employees
            attendanceCard(
              'Absent',
              '0',
              Icons.cancel_outlined,
              AppColors.redColor,
            ),

            // Employees on leave
            attendanceCard(
              'On Leave',
              '0',
              Icons.event_busy_outlined,
              AppColors.orangeColor,
            ),

            const SizedBox(height: 16),

            const Text(
              'Attendance records will be added here.',
              style: TextStyle(
                color: AppColors.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Creates one attendance summary card
  Widget attendanceCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),

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
            color: color,
            size: 30,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
