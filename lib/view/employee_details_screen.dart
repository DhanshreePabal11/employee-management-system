
import 'package:flutter/material.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String department;
  final String salary;
  final String employeeId;
  final String designation;

  const EmployeeDetailScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.salary,
    required this.employeeId,
    required this.designation,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF172554);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text('Employee Details'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Employee Profile
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFFE3ECFF),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    designation,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F7EC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Active Employee',
                      style: TextStyle(
                        color: Color(0xFF15803D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Employee Information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Employee Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  detailRow(
                    Icons.badge_outlined,
                    'Employee ID',
                    employeeId,
                  ),

                  detailRow(
                    Icons.email_outlined,
                    'Email Address',
                    email,
                  ),

                  detailRow(
                    Icons.phone_outlined,
                    'Phone Number',
                    phone,
                  ),

                  detailRow(
                    Icons.business_outlined,
                    'Department',
                    department,
                  ),

                  detailRow(
                    Icons.currency_rupee,
                    'Monthly Salary',
                    '₹$salary',
                  ),

                  detailRow(
                    Icons.work_outline,
                    'Employment Type',
                    'Full Time',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Edit Employee Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit feature coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 0),
          Icon(
            icon,
            color: const Color(0xFF172554),
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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
