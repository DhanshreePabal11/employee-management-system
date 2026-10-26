
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/employee_model.dart';

class EmployeeApiRepo {
  final String baseUrl = 'http://127.0.0.1:8000/employees';

  // GET API: Fetch all employees
  Future<List<EmployeeModel>> getEmployeesFromApi() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) {
          return EmployeeModel(
            id: (item['id'] as num).toInt(),
            name: item['name']?.toString() ?? '',
            email: item['email']?.toString() ?? '',
            phone: item['phone']?.toString() ?? '',
            department: item['department']?.toString() ?? '',
            salary: (item['salary'] as num?)?.toDouble() ?? 0.0,
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to fetch employees: ${response.statusCode}',
        );
      }
    } catch (error) {
      throw Exception('Error fetching employees: $error');
    }
  }

  // POST API: Add employee
  Future<bool> addEmployeeToApi(EmployeeModel employee) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': employee.name,
        'email': employee.email,
        'phone': employee.phone,
        'department': employee.department,
        'salary': employee.salary,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Employee added successfully!');
      print(response.body);
      return true;
    } else {
      throw Exception(
        'Failed to add employee: ${response.body}',
      );
    }
  }

  // PUT API: Update employee
  Future<bool> updateEmployeeInApi(
    int employeeId,
    EmployeeModel employee,
  ) async {
    final url = Uri.parse('$baseUrl/$employeeId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': employee.name,
        'email': employee.email,
        'phone': employee.phone,
        'department': employee.department,
        'salary': employee.salary,
      }),
    );

    if (response.statusCode == 200) {
      print('Employee updated successfully!');
      print(response.body);
      return true;
    } else {
      throw Exception(
        'Failed to update employee: ${response.body}',
      );
    }
  }

  // DELETE API: Delete employee
  Future<bool> deleteEmployeeFromApi(int employeeId) async {
    final url = Uri.parse('$baseUrl/$employeeId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Employee deleted successfully!');
      return true;
    } else {
      throw Exception(
        'Failed to delete employee: ${response.body}',
      );
    }
  }
}
