
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../repo/employee_api_repo.dart';
import '../repo/employee_repo.dart';
import '../model/employee_model.dart';
import '../custom_widgets/bottom_nav_bar.dart';

import 'employee_list_screen.dart';
import 'attendence_screen.dart';
import 'attendence_reports_screen.dart';
import 'profile_screen.dart';
import 'add_employee_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();
  final EmployeeRepo employeeRepo = EmployeeRepo();

  List<EmployeeModel> employees = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      final data = await employeeApiRepo.getEmployeesFromApi();

      if (!mounted) return;

      setState(() {
        employees = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (error) {
      debugPrint('Dashboard loading error: $error');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Could not load employees. Please try again.';
      });
    }
  }

  void handleNavigation(int index) {
    switch (index) {
      case 0:
        // Already on Dashboard.
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmployeeListScreen(
              employeeRepo: employeeRepo,
            ),
          ),
        );
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AttendenceScreen(),
          ),
        );
        break;

      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AttendenceReportsScreen(),
          ),
        );
        break;

      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
        );
        break;
    }
  }

  void openEmployees() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeeListScreen(
          employeeRepo: employeeRepo,
        ),
      ),
    );
  }

  void openAddEmployee() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEmployeeScreen(
          employeeRepo: employeeRepo,
        ),
      ),
    ).then((_) {
      loadDashboardData();
    });
  }

  Widget buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuickAction({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmployeeTile(EmployeeModel employee) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.lightBlueColor,
            child: Text(
              employee.name.isNotEmpty
                  ? employee.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  employee.department,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final departmentNames = <String>{};

    for (final employee in employees) {
      if (employee.department.trim().isNotEmpty) {
        departmentNames.add(employee.department.trim());
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Employee Portal'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: isLoading ? null : loadDashboardData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh dashboard',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Here is your employee management overview.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyColor,
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                'Workforce Overview',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 14),

              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              else if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: loadDashboardData,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildSummaryCard(
                            title: 'Total Employees',
                            value: '${employees.length}',
                            icon: Icons.groups_2_rounded,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildSummaryCard(
                            title: 'Departments',
                            value: '${departmentNames.length}',
                            icon: Icons.apartment_rounded,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 28),

              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildQuickAction(
                    title: 'Add Employee',
                    subtitle: 'Register a new employee',
                    icon: Icons.person_add_alt_rounded,
                    onTap: openAddEmployee,
                  ),
                  const SizedBox(width: 12),
                  buildQuickAction(
                    title: 'View Employees',
                    subtitle: 'Manage employee details',
                    icon: Icons.groups_2_rounded,
                    onTap: openEmployees,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Employees',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: openEmployees,
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              else if (employees.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'No employees found.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.greyColor,
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    for (int i = 0;
                        i < employees.length && i < 5;
                        i++)
                      buildEmployeeTile(employees[i]),
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onItemTapped: handleNavigation,
      ),
    );
  }
}
