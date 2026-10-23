
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../custom_widgets/employee_card.dart';
import '../model/employee_model.dart';
import '../repo/employee_repo.dart';
import 'employee_details_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  final EmployeeRepo employeeRepo;

  const EmployeeListScreen({
    super.key,
    required this.employeeRepo,
  });

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  Widget build(BuildContext context) {
    final List<EmployeeModel> employees =
        widget.employeeRepo.getEmployees();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: const Text(AppStrings.employeeList),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),

      body: employees.isEmpty
          ? const Center(
              child: Text(
                'No employees found.\nPlease add an employee.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.greyColor,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: employees.length,

              itemBuilder: (context, index) {
                final employee = employees[index];

                return EmployeeCard(
                  name: employee.name,
                  department: employee.department,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeDetailScreen(
                          employee: employee,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
