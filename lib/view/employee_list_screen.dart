
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../custom_widgets/employee_card.dart';
import '../custom_widgets/bottom_nav_bar.dart';
import '../model/employee_model.dart';
import '../repo/employee_repo.dart';
import '../repo/employee_api_repo.dart';

import 'add_employee_screen.dart';
import 'employee_details_screen.dart';
import 'dashboard_screen.dart';
import 'attendence_screen.dart';
import 'attendence_reports_screen.dart';
import 'profile_screen.dart';

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

class _EmployeeListScreenState
    extends State<EmployeeListScreen> {
  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();

  final TextEditingController searchController =
      TextEditingController();

  List<EmployeeModel> employees = [];

  bool isLoading = true;
  String? errorMessage;
  String selectedDepartment = 'All';

  final List<String> departments = [
    'All',
    'Human Resources',
    'Information Technology',
    'Finance',
    'Marketing',
    'Sales',
    'Operations',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fetch employees from FastAPI.
  Future<void> fetchEmployees() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiEmployees =
          await employeeApiRepo.getEmployeesFromApi();

      if (!mounted) return;

      setState(() {
        employees = apiEmployees;
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Employee loading error: $error');

      if (!mounted) return;

      setState(() {
        errorMessage =
            'Could not load employees. Check your API connection.';
        isLoading = false;
      });
    }
  }

  void navigateToScreen(int index) {
    if (index == 1) return;

    late final Widget screen;

    switch (index) {
      case 0:
        screen = const DashboardScreen();
        break;

      case 2:
        screen = const AttendenceScreen();
        break;

      case 3:
        screen = const AttendenceReportsScreen();
        break;

      case 4:
        screen = const ProfileScreen();
        break;

      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  Future<void> openAddEmployeeScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEmployeeScreen(
          employeeRepo: widget.employeeRepo,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await fetchEmployees();
    }
  }

  Future<void> openEmployeeDetails(
    EmployeeModel employee,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailScreen(
          employee: employee,
        ),
      ),
    );

    if (!mounted) return;

    await fetchEmployees();
  }

  List<EmployeeModel> get filteredEmployees {
    final searchText =
        searchController.text.toLowerCase().trim();

    return employees.where((employee) {
      final matchesSearch =
          employee.name.toLowerCase().contains(searchText) ||
          employee.email.toLowerCase().contains(searchText) ||
          employee.department.toLowerCase().contains(searchText);

      final matchesDepartment =
          selectedDepartment == 'All' ||
          employee.department == selectedDepartment;

      return matchesSearch && matchesDepartment;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedEmployees = filteredEmployees;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Dashboard',
          onPressed: () => navigateToScreen(0),
        ),
        title: const Text('Employee List'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: isLoading ? null : fetchEmployees,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh employees',
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search employees...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: DropdownButtonFormField<String>(
              initialValue: selectedDepartment,
              decoration: InputDecoration(
                labelText: 'Filter by Department',
                prefixIcon: const Icon(
                  Icons.business_outlined,
                  color: AppColors.primaryColor,
                ),
                filled: true,
                fillColor: AppColors.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: departments.map((department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedDepartment = value;
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Employees',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                Text(
                  '${displayedEmployees.length} found',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchEmployees,
              child: isLoading
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 180),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text('Loading employees...'),
                        ),
                      ],
                    )
                  : errorMessage != null
                      ? ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 100),
                            const Icon(
                              Icons.cloud_off,
                              size: 55,
                              color: AppColors.greyColor,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: fetchEmployees,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Try Again'),
                              ),
                            ),
                          ],
                        )
                      : displayedEmployees.isEmpty
                          ? ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 100),
                                const Icon(
                                  Icons.people_outline,
                                  size: 65,
                                  color: AppColors.greyColor,
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: Text(
                                    employees.isEmpty
                                        ? 'No employees found.'
                                        : 'No matching employees found.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ),
                                if (employees.isEmpty) ...[
                                  const SizedBox(height: 16),
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed:
                                          openAddEmployeeScreen,
                                      icon: const Icon(Icons.add),
                                      label: const Text(
                                        'Add Employee',
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : ListView.builder(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                4,
                                16,
                                90,
                              ),
                              itemCount: displayedEmployees.length,
                              itemBuilder: (context, index) {
                                final employee =
                                    displayedEmployees[index];

                                return Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: EmployeeCard(
                                    name: employee.name,
                                    department:
                                        employee.department,
                                    onTap: () {
                                      openEmployeeDetails(
                                        employee,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddEmployeeScreen,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        tooltip: 'Add Employee',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onItemTapped: navigateToScreen,
      ),
    );
  }
}
