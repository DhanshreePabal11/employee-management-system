
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../model/employee_model.dart';
import '../repo/employee_api_repo.dart';
import 'edit_employee_screen.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final EmployeeModel employee;

  const EmployeeDetailScreen({
    super.key,
    required this.employee,
  });

  @override
  State<EmployeeDetailScreen> createState() =>
      _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState
    extends State<EmployeeDetailScreen> {
  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();

  bool isDeleting = false;

  Future<void> deleteEmployee() async {
    if (isDeleting) return;

    if (widget.employee.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee ID is not available.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Ask for confirmation before deleting.
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text(
            'Are you sure you want to delete '
            '${widget.employee.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete != true || !mounted) return;

    setState(() {
      isDeleting = true;
    });

    try {
      final success =
          await employeeApiRepo.deleteEmployeeFromApi(
        widget.employee.id!,
      );

      if (!mounted) return;

      if (success) {
        // Return to the employee list after successful deletion.
        Navigator.pop(context, true);
      }
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isDeleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete employee: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> editEmployee() async {
    if (widget.employee.id == null) return;

    final updatedEmployee =
        await Navigator.push<EmployeeModel>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmployeeScreen(
          employee: widget.employee,
          employeeId: widget.employee.id!,
        ),
      ),
    );

    if (!mounted) return;

    if (updatedEmployee != null) {
      // Return updated employee to the employee list.
      Navigator.pop(context, updatedEmployee);
    }
  }

  @override
  Widget build(BuildContext context) {
    final employee = widget.employee;

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

            // Edit button.
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isDeleting ||
                        employee.id == null
                    ? null
                    : editEmployee,
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

            const SizedBox(height: 12),

            // Delete button.
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isDeleting ||
                        employee.id == null
                    ? null
                    : deleteEmployee,
                icon: isDeleting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.delete_outline),
                label: Text(
                  isDeleting
                      ? 'Deleting...'
                      : 'Delete Employee',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            if (employee.id == null) ...[
              const SizedBox(height: 12),
              const Text(
                'This employee has no API ID. '
                'Editing and deleting are unavailable.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.greyColor,
                ),
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
            size: 24,
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
