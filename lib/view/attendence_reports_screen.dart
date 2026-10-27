
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../custom_widgets/summary_card.dart';
import '../custom_widgets/bottom_nav_bar.dart';
import '../model/employee_model.dart';
import '../repo/employee_api_repo.dart';
import '../repo/attendance_api_repo.dart';
import '../repo/employee_repo.dart';

import 'dashboard_screen.dart';
import 'employee_list_screen.dart';
import 'attendence_screen.dart';
import 'profile_screen.dart';

class AttendenceReportsScreen extends StatefulWidget {
  const AttendenceReportsScreen({super.key});

  @override
  State<AttendenceReportsScreen> createState() =>
      _AttendenceReportsScreenState();
}

class _AttendenceReportsScreenState
    extends State<AttendenceReportsScreen> {
  final AttendanceApiRepo attendanceApiRepo = AttendanceApiRepo();
  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();
  final EmployeeRepo employeeRepo = EmployeeRepo();

  DateTime selectedMonth = DateTime.now();

  List<Map<String, dynamic>> attendanceRecords = [];
  List<EmployeeModel> employees = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadReports();
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
              employeeRepo: employeeRepo,
            ),
          ),
        );
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AttendenceScreen(),
          ),
        );
        break;

      case 3:
    
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

  String formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }


  Future<void> loadReports() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final employeeData =
          await employeeApiRepo.getEmployeesFromApi();

      final firstDay = DateTime(
        selectedMonth.year,
        selectedMonth.month,
        1,
      );

      final lastDay = DateTime(
        selectedMonth.year,
        selectedMonth.month + 1,
        0,
      );

      final requests = <Future<List<Map<String, dynamic>>>>[];

      for (int day = 0; day < lastDay.day; day++) {
        final date = firstDay.add(Duration(days: day));

        requests.add(
          attendanceApiRepo.getAttendance(formatDate(date)),
        );
      }

      final monthlyRecords = await Future.wait(requests);

      final allRecords = monthlyRecords
          .expand((dailyRecords) => dailyRecords)
          .toList();

      allRecords.sort((a, b) {
        return (b['date'] as String)
            .compareTo(a['date'] as String);
      });

      if (!mounted) return;

      setState(() {
        employees = employeeData;
        attendanceRecords = allRecords;
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Attendance report error: $error');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            'Could not load reports. Check your backend and try again.';
      });
    }
  }

  
  int get presentCount => attendanceRecords
      .where((record) => record['status'] == 'Present')
      .length;

  int get absentCount => attendanceRecords
      .where((record) => record['status'] == 'Absent')
      .length;

  int get leaveCount => attendanceRecords
      .where((record) => record['status'] == 'On Leave')
      .length;

  int get totalRecords => attendanceRecords.length;

  double get attendancePercentage {
    if (totalRecords == 0) return 0;
    return (presentCount / totalRecords) * 100;
  }

 
  String get monthLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[selectedMonth.month - 1]} ${selectedMonth.year}';
  }

  Future<void> selectMonth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Select a date in the report month',
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      selectedMonth = DateTime(
        pickedDate.year,
        pickedDate.month,
        1,
      );
    });

    await loadReports();
  }


  String employeeName(int employeeId) {
    for (final employee in employees) {
      if (employee.id == employeeId) {
        return employee.name;
      }
    }

    return 'Employee #$employeeId';
  }


  Color statusColor(String status) {
    switch (status) {
      case 'Present':
        return AppColors.greenColor;
      case 'Absent':
        return AppColors.redColor;
      case 'On Leave':
        return AppColors.orangeColor;
      default:
        return AppColors.greyColor;
    }
  }

 
  Widget buildDistributionRow(
    String title,
    int count,
    Color color,
  ) {
    final percentage =
        totalRecords == 0 ? 0.0 : count / totalRecords;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                '$count (${(percentage * 100).toStringAsFixed(1)}%)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: AppColors.backgroundColor,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

 
  Widget buildReportDetails() {
    if (attendanceRecords.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 48,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 12),
            Text(
              'No Attendance Reports Yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Saved attendance records for this month '
              'will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.greyColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: attendanceRecords.map((record) {
        final employeeId =
            (record['employee_id'] as num).toInt();

        final name = employeeName(employeeId);
        final status = record['status'] as String;
        final date = record['date'].toString();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    statusColor(status).withValues(alpha: 0.12),
                child: Icon(
                  Icons.person_outline,
                  color: statusColor(status),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      date,
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
                  color: statusColor(status)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor(status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
        title: const Text(AppStrings.attendanceReports),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: isLoading ? null : loadReports,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh reports',
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
                          onPressed: loadReports,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadReports,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly Reports',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Review and monitor employee attendance.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.greyColor,
                          ),
                        ),
                        const SizedBox(height: 22),

                      
                        InkWell(
                          onTap: selectMonth,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: double.infinity,
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
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBlueColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppColors.primaryColor,
                                    size: 25,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Report Period',
                                        style: TextStyle(
                                          color: AppColors.greyColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        monthLabel,
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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

                        const SizedBox(height: 24),
                        const Text(
                          'Attendance Overview',
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
                                title: 'Present',
                                value: '$presentCount',
                                icon: Icons.check_circle_outline,
                                iconColor: AppColors.greenColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SummaryCard(
                                title: 'Absent',
                                value: '$absentCount',
                                icon: Icons.cancel_outlined,
                                iconColor: AppColors.redColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'On Leave',
                                value: '$leaveCount',
                                icon: Icons.event_busy_outlined,
                                iconColor: AppColors.orangeColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SummaryCard(
                                title: 'Total Records',
                                value: '$totalRecords',
                                icon: Icons.assignment_outlined,
                                iconColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
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
                              const Icon(
                                Icons.percent,
                                color: AppColors.primaryColor,
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Present Record Percentage',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '${attendancePercentage.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),
                        const Text(
                          'Monthly Breakdown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Attendance Distribution',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 22),
                              buildDistributionRow(
                                'Present',
                                presentCount,
                                AppColors.greenColor,
                              ),
                              buildDistributionRow(
                                'Absent',
                                absentCount,
                                AppColors.redColor,
                              ),
                              buildDistributionRow(
                                'On Leave',
                                leaveCount,
                                AppColors.orangeColor,
                              ),
                              if (totalRecords == 0)
                                const Center(
                                  child: Text(
                                    'No records available for this month.',
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        const Text(
                          'Report Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                          ),
                          child: buildReportDetails(),
                        ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 3,
        onItemTapped: handleNavigation,
      ),
    );
  }
}
