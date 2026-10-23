
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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Attendance Overview',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Manage and review daily employee attendance.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.greyColor,
              ),
            ),

            const SizedBox(height: 22),

            // Date selector UI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.borderColor,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.primaryColor,
                    size: 26,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Attendance",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Select a date to view records',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Summary heading
            const Text(
              'Attendance Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 14),

            // Summary cards
            Row(
              children: [
                Expanded(
                  child: summaryCard(
                    'Present',
                    '0',
                    Icons.check_circle_outline,
                    AppColors.greenColor,
                    const Color(0xFFE8F7ED),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: summaryCard(
                    'Absent',
                    '0',
                    Icons.cancel_outlined,
                    AppColors.redColor,
                    const Color(0xFFFDECEC),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            summaryCard(
              'On Leave',
              '0',
              Icons.event_busy_outlined,
              AppColors.orangeColor,
              const Color(0xFFFFF1E5),
            ),

            const SizedBox(height: 26),

            // Employee list heading
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Employee Attendance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Daily Records',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Placeholder employee attendance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.borderColor,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 48,
                    color: AppColors.greyColor,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No Attendance Records',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Employee attendance details and status options will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Attendance summary card
  Widget summaryCard(
    String title,
    String count,
    IconData icon,
    Color iconColor,
    Color backgroundColor,
  ) {
    return Container(
      width: double.infinity,
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
              ),
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
