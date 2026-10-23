
import 'package:flutter/material.dart';

class AttendenceScreen extends StatelessWidget {
  const AttendenceScreen({super.key});

  static const Color primaryColor = Color(0xFF172554);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
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
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage daily employee attendance.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            attendanceCard(
              'Present',
              '0',
              Icons.check_circle_outline,
              Colors.green,
            ),
            attendanceCard(
              'Absent',
              '0',
              Icons.cancel_outlined,
              Colors.red,
            ),
            attendanceCard(
              'On Leave',
              '0',
              Icons.event_busy_outlined,
              Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Attendance records will be added here.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
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
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
