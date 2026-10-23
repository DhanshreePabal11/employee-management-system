
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../custom_widgets/summary_card.dart';
import '../custom_widgets/employee_card.dart';
import '../model/employee_model.dart';
import '../repo/employee_repo.dart';
import 'add_employee_screen.dart';
import 'employee_list_screen.dart';
import 'attendence_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EmployeeRepo employeeRepo = EmployeeRepo();

  int selectedIndex = 0;

  Future<void> openAddEmployee() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEmployeeScreen(
          employeeRepo: employeeRepo,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  void openEmployeeList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeListScreen(
          employeeRepo: employeeRepo,
        ),
      ),
    );
  }

  void openAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AttendenceScreen(),
      ),
    );
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  void handleNavigation(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 1) {
      openEmployeeList();
    } else if (index == 2) {
      openAttendance();
    } else if (index == 3) {
      openProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<EmployeeModel> employees =
        employeeRepo.getEmployees();

    final int departmentCount =
        employees.map((employee) => employee.department).toSet().length;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.dashboard,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppStrings.dashboardSubtitle,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: openProfile,
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning!',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 6),

            const Text(
              'Here is what is happening in your workplace today.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Workforce Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: AppStrings.totalEmployees,
                    value: '${employees.length}',
                    icon: Icons.groups_rounded,
                    iconColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: SummaryCard(
                    title: AppStrings.presentToday,
                    value: '0',
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.greenColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Expanded(
                  child: SummaryCard(
                    title: AppStrings.onLeave,
                    value: '0',
                    icon: Icons.event_busy_outlined,
                    iconColor: AppColors.orangeColor,
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: AppStrings.departments,
                    value: '$departmentCount',
                    icon: Icons.business_outlined,
                    iconColor: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: openAddEmployee,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text(AppStrings.addEmployee),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.whiteColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: openEmployeeList,
                    icon: const Icon(Icons.people_outline),
                    label: const Text('View Employees'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                  ),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                TextButton(
                  onPressed: openEmployeeList,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (employees.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(AppStrings.noEmployees),
              )
            else
              ...employees.take(3).map(
                (employee) => EmployeeCard(
                  name: employee.name,
                  department: employee.department,
                  onTap: openEmployeeList,
                ),
              ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.greyColor,
        onTap: handleNavigation,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
