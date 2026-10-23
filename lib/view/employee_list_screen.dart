
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
  State<EmployeeListScreen> createState() =>
      _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedDepartment = 'All Departments';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<EmployeeModel> employees =
        widget.employeeRepo.getEmployees();

    final List<String> departments = employees
        .map((employee) => employee.department)
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.employeeList),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Your Team',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'View and manage employee information',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Search and filter UI
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search employees',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.greyColor,
                    ),
                    suffixIcon: const Icon(
                      Icons.tune,
                      color: AppColors.greyColor,
                    ),
                    filled: true,
                    fillColor: AppColors.whiteColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    prefixIcon: const Icon(
                      Icons.business_outlined,
                      color: AppColors.greyColor,
                    ),
                    filled: true,
                    fillColor: AppColors.whiteColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: 'All Departments',
                      child: Text('All Departments'),
                    ),
                    ...departments.map((department) {
                      return DropdownMenuItem<String>(
                        value: department,
                        child: Text(department),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    // Filter functionality will be added later.
                    if (value != null) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // Employee count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
                const SizedBox(width: 8),
                const Text(
                  'All Employees',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${employees.length} Members',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Employee list
          Expanded(
            child: employees.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: const BoxDecoration(
                              color: AppColors.lightBlueColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.people_outline,
                              size: 48,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Employees Yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add your first employee to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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
                              builder: (context) =>
                                  EmployeeDetailScreen(
                                employee: employee,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
