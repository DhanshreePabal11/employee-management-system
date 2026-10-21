import 'package:flutter/material.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = [
      ['Rahul Sharma', 'Software Developer', 'IT'],
      ['Priya Singh', 'HR Manager', 'HR'],
      ['Amit Kumar', 'Accountant', 'Finance'],
      ['Sneha Patil', 'UI Designer', 'Design'],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: const Color(0xFF17365D),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Employee Directory',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),


            const SizedBox(height: 6),


            const Text(
              'Manage your team members',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];

                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFE3ECFF),
                        child: Text(
                          employee[0][0],
                          style: const TextStyle(
                            color: Color(0xFF17365D),
                            fontWeight: FontWeight.bold,
                          ),

                        ),

                      ),

                      title: Text(
                        employee[0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(
                        '${employee[1]}\n${employee[2]} Department',
                      ),

                      isThreeLine: true,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),

                  );

                },
              ),

            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF17365D),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
