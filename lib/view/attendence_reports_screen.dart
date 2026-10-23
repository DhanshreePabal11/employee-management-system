
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../custom_widgets/summary_card.dart';

class AttendenceReportsScreen extends StatelessWidget {
  const AttendenceReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: const Text(AppStrings.attendanceReports),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Summary',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Overview of employee attendance records.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.greyColor,
              ),
            ),

            const SizedBox(height: 24),

            // First row of summary cards
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Present',
                    value: '0',
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.greenColor,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SummaryCard(
                    title: 'Absent',
                    value: '0',
                    icon: Icons.cancel_outlined,
                    iconColor: AppColors.redColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Second row of summary cards
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'On Leave',
                    value: '0',
                    icon: Icons.event_busy_outlined,
                    iconColor: AppColors.orangeColor,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SummaryCard(
                    title: 'Total Records',
                    value: '0',
                    icon: Icons.assignment_outlined,
                    iconColor: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'Report Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 14),

            // Empty report message
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
                    Icons.insert_chart_outlined,
                    size: 48,
                    color: AppColors.greyColor,
                  ),

                  SizedBox(height: 12),

                  Text(
                    'No Attendance Reports Yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Attendance reports will appear here '
                    'when attendance records are available.',
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
}
