
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../model/employee_model.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeDetailScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: const Text(AppStrings.employeeDetails),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            // Employee icon
            const CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.lightBlueColor,
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 16),

            // Employee name
            Text(
              employee.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 6),

            // Employee department
            Text(
              employee.department,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.greyColor,
              ),
            ),

            const SizedBox(height: 28),

            // Employee information
            detailCard(
              Icons.email_outlined,
              'Email',
              employee.email,
            ),

            detailCard(
              Icons.phone_outlined,
              AppStrings.phone,
              employee.phone,
            ),

            detailCard(
              Icons.business_outlined,
              AppStrings.department,
              employee.department,
            ),

            detailCard(
              Icons.currency_rupee,
              'Monthly Salary',
              '₹${employee.salary.toStringAsFixed(2)}',
            ),
          ],
        ),
      ),
    );
  }

  // Displays one employee detail
  Widget detailCard(IconData icon, String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
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
            size: 25,
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

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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
