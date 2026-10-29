
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/employee_model.dart';

class EmployeeApiRepo {
 final String baseUrl =
    'https://employee-management-system-backend-beryl.vercel.app/employees';

  // GET API
  Future<List<EmployeeModel>> getEmployeesFromApi() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch employees: '
          '${response.statusCode} ${response.body}',
        );
      }

      final dynamic decoded = jsonDecode(response.body);
      dynamic data = decoded;

     
      if (decoded is Map) {
        data = decoded['employees'] ?? decoded['data'];
      }

      if (data is! List) {
        throw const FormatException(
          'Expected a list of employees from the API.',
        );
      }

      return data.map<EmployeeModel>((item) {
        if (item is! Map) {
          throw const FormatException(
            'Invalid employee record received from API.',
          );
        }

        final json = Map<String, dynamic>.from(item);

        return EmployeeModel(
          id: json['id'] == null
              ? null
              : (json['id'] as num).toInt(),
          name: json['name']?.toString() ?? '',
          email: json['email']?.toString() ?? '',
          phone: json['phone']?.toString() ?? '',
          department: json['department']?.toString() ?? '',
          salary: json['salary'] is num
              ? (json['salary'] as num).toDouble()
              : double.tryParse(
                    json['salary']?.toString() ?? '',
                  ) ??
                  0.0,
        );
      }).toList();
    } catch (error) {
      debugPrint('Employee API error: $error');
      rethrow;
    }
  }

  // POST API
  Future<bool> addEmployeeToApi(EmployeeModel employee) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': employee.name,
        'email': employee.email,
        'phone': employee.phone,
        'department': employee.department,
        'salary': employee.salary,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      debugPrint('Employee added successfully.');
      return true;
    }

    throw Exception('Failed to add employee: ${response.body}');
  }

  // PUT API
  Future<bool> updateEmployeeInApi(
    int employeeId,
    EmployeeModel employee,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$employeeId'),
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
      debugPrint('Employee updated successfully.');
      return true;
    }

    throw Exception('Failed to update employee: ${response.body}');
  }

  // DELETE API
  Future<bool> deleteEmployeeFromApi(int employeeId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$employeeId'),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204) {
      debugPrint('Employee deleted successfully.');
      return true;
    }

    throw Exception('Failed to delete employee: ${response.body}');
  }
}
