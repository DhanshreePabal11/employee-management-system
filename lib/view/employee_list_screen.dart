
import 'package:flutter/material.dart';

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
  static const Color primaryColor = Color(0xFF172554);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    final List<EmployeeModel> employees =
        widget.employeeRepo.getEmployees();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Employee List'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: employees.isEmpty
          ? const Center(
              child: Text(
                'No employees found.\nPlease add an employee.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];

                return Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE0E7FF),
                      child: Icon(
                        Icons.person,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${employee.department}\n${employee.email}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
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
                  ),
                );
              },
            ),
    );
  }
}
