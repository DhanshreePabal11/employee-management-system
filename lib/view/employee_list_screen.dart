
import 'package:flutter/material.dart';
import 'employee_details_screen.dart';
class EmployeeListScreen extends StatelessWidget {
  EmployeeListScreen({super.key});

  final List<Map<String, String>> employees = [
    {
      'id': 'EMP001',
      'name': 'Rahul Sharma',
      'designation': 'Software Developer',
      'email': 'rahul@example.com',
      'phone': '9876543210',
      'department': 'Information Technology',
      'salary': '35000',
    },
    {
      'id': 'EMP002',
      'name': 'Priya Patil',
      'designation': 'HR Executive',
      'email': 'priya@example.com',
      'phone': '9876543211',
      'department': 'Human Resources',
      'salary': '30000',
    },
    {
      'id': 'EMP003',
      'name': 'Amit Deshmukh',
      'designation': 'Accountant',
      'email': 'amit@example.com',
      'phone': '9876543212',
      'department': 'Finance',
      'salary': '32000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF172554);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text('Employee List'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),

              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3ECFF),
                child: Icon(
                  Icons.person,
                  color: primaryColor,
                ),
              ),

              title: Text(
                employee['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${employee['designation']}\n'
                  '${employee['department']}',
                ),
              ),

              isThreeLine: true,

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryColor,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeDetailScreen(
                      name: employee['name']!,
                      email: employee['email']!,
                      phone: employee['phone']!,
                      department: employee['department']!,
                      salary: employee['salary']!,
                      employeeId: employee['id']!,
                      designation: employee['designation']!,
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
