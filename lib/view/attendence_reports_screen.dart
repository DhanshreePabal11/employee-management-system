
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
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page heading
            const Text(
              'Monthly Reports',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Review and monitor employee attendance.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.greyColor,
              ),
            ),

            const SizedBox(height: 22),

            // Month selector UI
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

              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primaryColor,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report Period',
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 12,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'October 2026',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Summary heading
            const Text(
              'Attendance Overview',
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

            // Monthly breakdown heading
            const Text(
              'Monthly Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 14),

            // Placeholder chart card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.borderColor,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attendance Distribution',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart_rounded,
                          size: 52,
                          color: AppColors.greyColor,
                        ),

                        SizedBox(height: 8),

                        Text(
                          'Chart will appear here',
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.greenColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Present',
                        style: TextStyle(fontSize: 12),
                      ),

                      SizedBox(width: 16),

                      Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.redColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Absent',
                        style: TextStyle(fontSize: 12),
                      ),

                      SizedBox(width: 16),

                      Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.orangeColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Leave',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Report details
            const Text(
              'Report Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 14),

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
                    'Detailed employee attendance records '
                    'will appear here once available.',
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
