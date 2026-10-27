
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../custom_widgets/bottom_nav_bar.dart';
import '../model/employee_model.dart';
import '../repo/employee_api_repo.dart';
import '../repo/attendance_api_repo.dart';
import '../repo/employee_repo.dart';

import 'dashboard_screen.dart';
import 'employee_list_screen.dart';
import 'attendence_reports_screen.dart';
import 'profile_screen.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();
  final AttendanceApiRepo attendanceApiRepo = AttendanceApiRepo();

  DateTime selectedDate = DateTime.now();

  List<EmployeeModel> employees = [];

  final Map<int, String> attendance = {};
  final Map<int, int> attendanceRecordIds = {};

  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> fetchData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final employeeData =
          await employeeApiRepo.getEmployeesFromApi();

      final records = await attendanceApiRepo.getAttendance(
        formatDate(selectedDate),
      );

      final Map<int, String> loadedAttendance = {};
      final Map<int, int> loadedRecordIds = {};

      for (final employee in employeeData) {
        if (employee.id != null) {
          loadedAttendance[employee.id!] = 'Present';
        }
      }

      for (final record in records) {
        final employeeId = record['employee_id'];
        final recordId = record['id'];

        if (employeeId is num) {
          final id = employeeId.toInt();

          loadedAttendance[id] =
              record['status']?.toString() ?? 'Present';

          if (recordId is num) {
            loadedRecordIds[id] = recordId.toInt();
          }
        }
      }

      if (!mounted) return;

      setState(() {
        employees = employeeData;

        attendance
          ..clear()
          ..addAll(loadedAttendance);

        attendanceRecordIds
          ..clear()
          ..addAll(loadedRecordIds);

        isLoading = false;
      });
    } catch (error) {
      debugPrint('Attendance loading error: $error');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            'Could not load attendance. Check your backend and try again.';
      });
    }
  }

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      selectedDate = pickedDate;
    });

    await fetchData();
  }

  void updateStatus(int employeeId, String status) {
    setState(() {
      attendance[employeeId] = status;
    });
  }

  Future<void> saveAttendance() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      final date = formatDate(selectedDate);

      for (final employee in employees) {
        final employeeId = employee.id;

        if (employeeId == null) continue;

        final status = attendance[employeeId] ?? 'Present';
        final recordId = attendanceRecordIds[employeeId];

        Map<String, dynamic> savedRecord;

        if (recordId != null) {
          savedRecord = await attendanceApiRepo.updateAttendance(
            attendanceId: recordId,
            employeeId: employeeId,
            date: date,
            status: status,
          );
        } else {
          savedRecord = await attendanceApiRepo.addAttendance(
            employeeId: employeeId,
            date: date,
            status: status,
          );
        }

        final savedId = savedRecord['id'];

        if (savedId is num) {
          attendanceRecordIds[employeeId] = savedId.toInt();
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      await fetchData();
    } catch (error) {
      debugPrint('Save attendance error: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save attendance: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }


  void goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );
  }


  void handleNavigation(int index) {
    switch (index) {
      case 0:
        goToDashboard();
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeListScreen(
              employeeRepo: EmployeeRepo(),
            ),
          ),
        );
        break;

      case 2:
       
        break;

      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AttendenceReportsScreen(),
          ),
        );
        break;

      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
        break;
    }
  }

  int get presentCount {
    return attendance.values
        .where((status) => status == 'Present')
        .length;
  }

  int get absentCount {
    return attendance.values
        .where((status) => status == 'Absent')
        .length;
  }

  int get leaveCount {
    return attendance.values
        .where((status) => status == 'On Leave')
        .length;
  }

  Widget buildStatusButton(
    int employeeId,
    String status,
    Color color,
  ) {
    final isSelected = attendance[employeeId] == status;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: OutlinedButton(
          onPressed: isSaving
              ? null
              : () => updateStatus(employeeId, status),
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected
                ? color.withValues(alpha: 0.12)
                : Colors.white,
            foregroundColor: color,
            side: BorderSide(
              color: isSelected ? color : AppColors.borderColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            status,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }

  Widget buildEmployeeCard(EmployeeModel employee) {
    final employeeId = employee.id;

    if (employeeId == null) {
      return const SizedBox.shrink();
    }

    final status = attendance[employeeId] ?? 'Present';

    Color statusColor;

    switch (status) {
      case 'Present':
        statusColor = AppColors.greenColor;
        break;
      case 'Absent':
        statusColor = AppColors.redColor;
        break;
      case 'On Leave':
        statusColor = AppColors.orangeColor;
        break;
      default:
        statusColor = AppColors.greyColor;
    }

    return Container(
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
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              buildStatusButton(
                employeeId,
                'Present',
                AppColors.greenColor,
              ),
              buildStatusButton(
                employeeId,
                'Absent',
                AppColors.redColor,
              ),
              buildStatusButton(
                employeeId,
                'On Leave',
                AppColors.orangeColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard(
    String title,
    int count,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
     
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Dashboard',
          onPressed: goToDashboard,
        ),
        title: const Text('Attendance'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: isLoading ? null : fetchData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh attendance',
          ),
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
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.redColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchData,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchData,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'Manage Attendance',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Mark and save employee attendance.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.greyColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: selectDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  formatDate(selectedDate),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: buildSummaryCard(
                              'Present',
                              presentCount,
                              AppColors.greenColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildSummaryCard(
                              'Absent',
                              absentCount,
                              AppColors.redColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildSummaryCard(
                              'On Leave',
                              leaveCount,
                              AppColors.orangeColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Employee Attendance',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            '${employees.length} employees',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (employees.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text('No employees found.'),
                          ),
                        )
                      else
                        for (final employee in employees)
                          buildEmployeeCard(employee),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: isSaving ? null : saveAttendance,
                          icon: isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(
                            isSaving
                                ? 'Saving Attendance...'
                                : 'Save Attendance',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        onItemTapped: handleNavigation,
      ),
    );
  }
}
