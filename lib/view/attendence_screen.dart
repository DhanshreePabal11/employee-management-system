
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../custom_widgets/bottom_nav_bar.dart';
import '../model/employee_model.dart';
import '../repo/employee_api_repo.dart';
import 'profile_screen.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();

  DateTime selectedDate = DateTime.now();

  List<EmployeeModel> employees = [];

  // Attendance is held in memory until backend integration.
  final Map<int, String> attendance = {};

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await employeeApiRepo.getEmployeesFromApi();

      if (!mounted) return;

      setState(() {
        employees = result;

        // Default employees to Present until a status is selected.
        for (final employee in employees) {
          if (employee.id != null) {
            attendance.putIfAbsent(employee.id!, () => 'Present');
          }
        }

        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load employees. Check your API connection.';
        isLoading = false;
      });
    }
  }

  Future<void> selectDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null && mounted) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void updateAttendance(int employeeId, String status) {
    setState(() {
      attendance[employeeId] = status;
    });
  }

  int get presentCount =>
      attendance.values.where((status) => status == 'Present').length;

  int get absentCount =>
      attendance.values.where((status) => status == 'Absent').length;

  int get leaveCount =>
      attendance.values.where((status) => status == 'On Leave').length;

  void handleNavigation(int index) {
    if (index == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Open Employees from the Dashboard.'),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.attendance),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: fetchEmployees,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh employees',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchEmployees,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Attendance Overview',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage and review daily employee attendance.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyColor,
                ),
              ),
              const SizedBox(height: 24),

              // Date selector.
              InkWell(
                onTap: selectDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 28,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected Date',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.greyColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Attendance Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              summaryCard(
                title: 'Present',
                count: presentCount.toString(),
                icon: Icons.check_circle_outline,
                color: AppColors.greenColor,
                backgroundColor: const Color(0xFFE8F7ED),
              ),
              const SizedBox(height: 14),
              summaryCard(
                title: 'Absent',
                count: absentCount.toString(),
                icon: Icons.cancel_outlined,
                color: AppColors.redColor,
                backgroundColor: const Color(0xFFFDECEC),
              ),
              const SizedBox(height: 14),
              summaryCard(
                title: 'On Leave',
                count: leaveCount.toString(),
                icon: Icons.event_busy_outlined,
                color: AppColors.orangeColor,
                backgroundColor: const Color(0xFFFFF1E5),
              ),

              const SizedBox(height: 28),

              const Text(
                'Employee Attendance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select an attendance status for each employee.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.greyColor,
                ),
              ),
              const SizedBox(height: 16),

              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (errorMessage != null)
                Center(
                  child: Column(
                    children: [
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.redColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: fetchEmployees,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              else if (employees.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No employees found.'),
                  ),
                )
              else
                ...employees.map((employee) {
                  if (employee.id == null) {
                    return const SizedBox.shrink();
                  }

                  final status =
                      attendance[employee.id!] ?? 'Present';

                  return employeeAttendanceCard(
                    employee: employee,
                    status: status,
                  );
                }),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Attendance is not saved yet. Backend integration is the next step.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Attendance'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        onItemTapped: handleNavigation,
      ),
    );
  }

  Widget employeeAttendanceCard({
    required EmployeeModel employee,
    required String status,
  }) {
    Color statusColor;

    if (status == 'Present') {
      statusColor = AppColors.greenColor;
    } else if (status == 'Absent') {
      statusColor = AppColors.redColor;
    } else {
      statusColor = AppColors.orangeColor;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFE8ECF5),
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.primaryColor,
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.department,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: statusButton(
                  label: 'Present',
                  selected: status == 'Present',
                  color: AppColors.greenColor,
                  onPressed: () => updateAttendance(
                    employee.id!,
                    'Present',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: statusButton(
                  label: 'Absent',
                  selected: status == 'Absent',
                  color: AppColors.redColor,
                  onPressed: () => updateAttendance(
                    employee.id!,
                    'Absent',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: statusButton(
                  label: 'Leave',
                  selected: status == 'On Leave',
                  color: AppColors.orangeColor,
                  onPressed: () => updateAttendance(
                    employee.id!,
                    'On Leave',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statusButton({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 10,
        ),
        foregroundColor: selected ? Colors.white : color,
        backgroundColor: selected ? color : Colors.transparent,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget summaryCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
              ),
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
