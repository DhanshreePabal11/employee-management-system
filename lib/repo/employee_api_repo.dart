
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/employee_model.dart';

class EmployeeApiRepo {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/users';

  // GET API: Fetch employees
  Future<List<EmployeeModel>> getEmployeesFromApi() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((user) {
          return EmployeeModel(
            id: (user['id'] as num).toInt(),
            name: user['name']?.toString() ?? '',
            email: user['email']?.toString() ?? '',
            phone: user['phone']?.toString() ?? '',
            department: 'General',
            salary: 0.0,
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load employees. Status code: ${response.statusCode}',
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
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode == 201) {
      print('Employee added successfully to dummy API');
      print(response.body);
      return true;
    } else {
      throw Exception(
        'Failed to add employee. Status code: ${response.statusCode}',
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
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode == 200) {
      print('Employee updated successfully in dummy API');
      print(response.body);
      return true;
    } else {
      throw Exception(
        'Failed to update employee. Status code: ${response.statusCode}',
      );
    }
  }
}
