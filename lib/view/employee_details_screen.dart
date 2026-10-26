
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../model/employee_model.dart';
import 'edit_employee_screen.dart';

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
        title: const Text('Employee Details'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.person,
                size: 45,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
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
            Text(
              employee.department,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 28),

            _buildDetail(
              Icons.email_outlined,
              'Email Address',
              employee.email,
            ),
            _buildDetail(
              Icons.phone_outlined,
              'Phone Number',
              employee.phone,
            ),
            _buildDetail(
              Icons.business_outlined,
              'Department',
              employee.department,
            ),
            _buildDetail(
              Icons.currency_rupee,
              'Monthly Salary',
              '₹${employee.salary.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: employee.id == null
                    ? null
                    : () async {
                        final updatedEmployee =
                            await Navigator.push<EmployeeModel>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditEmployeeScreen(
                              employee: employee,
                              employeeId: employee.id!,
                            ),
                          ),
                        );

                        if (updatedEmployee != null &&
                            context.mounted) {
                          Navigator.pop(
                            context,
                            updatedEmployee,
                          );
                        }
                      },
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Edit Employee',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            if (employee.id == null) ...[
              const SizedBox(height: 10),
              const Text(
                'This employee does not have an API ID, so API editing is unavailable.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.greyColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(
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
        borderRadius: BorderRadius.circular(12),
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
                    fontSize: 13,
                    color: AppColors.greyColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value.isEmpty ? 'Not provided' : value,
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
