
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../custom_widgets/summary_card.dart';
import '../custom_widgets/employee_card.dart';
import '../custom_widgets/bottom_nav_bar.dart';
import '../model/employee_model.dart';
import '../repo/employee_repo.dart';
import '../repo/employee_api_repo.dart';
import '../repo/attendance_api_repo.dart';

import 'add_employee_screen.dart';
import 'employee_list_screen.dart';
import 'attendence_screen.dart';
import 'attendence_reports_screen.dart';
import 'profile_screen.dart';
import 'activity_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EmployeeRepo employeeRepo = EmployeeRepo();
  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();
  final AttendanceApiRepo attendanceApiRepo = AttendanceApiRepo();

  List<EmployeeModel> employees = [];

  int selectedIndex = 0;
  int presentCount = 0;
  int onLeaveCount = 0;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  // Load real employees and today's attendance from the API.
  Future<void> loadDashboardData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final List<EmployeeModel> apiEmployees =
          await employeeApiRepo.getEmployeesFromApi();

      final DateTime today = DateTime.now();

      final String todayDate =
          '${today.year}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';

      final records =
          await attendanceApiRepo.getAttendance(todayDate);

      int present = 0;
      int onLeave = 0;

      for (final record in records) {
        final String status =
            (record['status'] ?? '')
                .toString()
                .trim()
                .toLowerCase();

        if (status == 'present') {
          present++;
        } else if (status == 'on leave') {
          onLeave++;
        }
      }

      if (!mounted) return;

      setState(() {
        employees = apiEmployees;
        presentCount = present;
        onLeaveCount = onLeave;
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Dashboard API error: $error');

      if (!mounted) return;

      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  // Open Add Employee screen.
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
      await loadDashboardData();
    }
  }

  // Open Employee List screen.
  Future<void> openEmployeeList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeListScreen(
          employeeRepo: employeeRepo,
        ),
      ),
    );

    if (mounted) {
      await loadDashboardData();
    }
  }

  // Open Attendance screen.
  Future<void> openAttendance() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AttendenceScreen(),
      ),
    );

    if (mounted) {
      await loadDashboardData();
    }
  }

  // Open Attendance Reports screen.
  Future<void> openAttendanceReports() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AttendenceReportsScreen(),
      ),
    );

    if (mounted) {
      await loadDashboardData();
    }
  }

  // Open Profile screen.
  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  // Open Activity History screen.
  void openActivityHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActivityHistoryScreen(),
      ),
    );
  }

  // Handle bottom navigation.
  void handleNavigation(int index) {
    if (index == 0) {
      setState(() {
        selectedIndex = 0;
      });
      loadDashboardData();
    } else if (index == 1) {
      openEmployeeList();
    } else if (index == 2) {
      openAttendance();
    } else if (index == 3) {
      openAttendanceReports();
    } else if (index == 4) {
      openProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> departments = employees
        .map((employee) => employee.department.trim())
        .where((department) => department.isNotEmpty)
        .toSet();

    final int departmentCount = departments.length;

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
            onPressed: openActivityHistory,
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Activity History',
          ),
          IconButton(
            onPressed: openProfile,
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_outlined,
                          size: 48,
                          color: AppColors.greyColor,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Could not load dashboard data.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: loadDashboardData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadDashboardData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                            Expanded(
                              child: SummaryCard(
                                title: AppStrings.presentToday,
                                value: '$presentCount',
                                icon: Icons.check_circle_outline,
                                iconColor: AppColors.greenColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: AppStrings.onLeave,
                                value: '$onLeaveCount',
                                icon: Icons.event_busy_outlined,
                                iconColor: AppColors.orangeColor,
                              ),
                            ),
                            const SizedBox(width: 20),
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
                                icon: const Icon(
                                  Icons.person_add_alt_1,
                                ),
                                label: const Text(
                                  AppStrings.addEmployee,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.primaryColor,
                                  foregroundColor:
                                      AppColors.whiteColor,
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
                                icon: const Icon(
                                  Icons.people_outline,
                                ),
                                label: const Text('View Employees'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      AppColors.primaryColor,
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
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
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
                ),

      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: handleNavigation,
      ),
    );
  }
}
