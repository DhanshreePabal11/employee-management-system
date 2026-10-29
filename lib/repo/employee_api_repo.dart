import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/employee_model.dart';

class EmployeeApiRepo {
  final String baseUrl =
      'https://employee-management-system-backend-beryl.vercel.app/employees';

  // GET API - Load all employees
  Future<List<EmployeeModel>> getEmployeesFromApi() async {
    try {
      debugPrint('Fetching employees from: $baseUrl');

      final response = await http.get(
        Uri.parse(baseUrl),
      );

      // Debug messages
      debugPrint('Employee API status: ${response.statusCode}');
      debugPrint('Employee API response: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch employees: '
          '${response.statusCode} ${response.body}',
        );
      }

      final dynamic decoded = jsonDecode(response.body);
      dynamic data = decoded;

      // Handle different API response formats
      if (decoded is Map) {
        data = decoded['employees'] ?? decoded['data'];
      }

      if (data is! List) {
        throw const FormatException(
          'Expected a list of employees from the API.',
        );
      }

      // Convert API data into EmployeeModel objects
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
    } catch (error, stackTrace) {
      debugPrint('Employee API error: $error');
      debugPrint('Employee API stack trace: $stackTrace');
      rethrow;
    }
  }

  // POST API - Add employee
  Future<bool> addEmployeeToApi(EmployeeModel employee) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': employee.name,
          'email': employee.email,
          'phone': employee.phone,
          'department': employee.department,
          'salary': employee.salary,
        }),
      );

      debugPrint('Add employee status: ${response.statusCode}');
      debugPrint('Add employee response: ${response.body}');

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        debugPrint('Employee added successfully.');
        return true;
      }

      throw Exception(
        'Failed to add employee: ${response.body}',
      );
    } catch (error) {
      debugPrint('Add employee API error: $error');
      rethrow;
    }
  }

  // PUT API - Update employee
  Future<bool> updateEmployeeInApi(
    int employeeId,
    EmployeeModel employee,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$employeeId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': employee.name,
          'email': employee.email,
          'phone': employee.phone,
          'department': employee.department,
          'salary': employee.salary,
        }),
      );

      debugPrint('Update employee status: ${response.statusCode}');
      debugPrint('Update employee response: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Employee updated successfully.');
        return true;
      }

      throw Exception(
        'Failed to update employee: ${response.body}',
      );
    } catch (error) {
      debugPrint('Update employee API error: $error');
      rethrow;
    }
  }

  // DELETE API - Delete employee
  Future<bool> deleteEmployeeFromApi(int employeeId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$employeeId'),
      );

      debugPrint('Delete employee status: ${response.statusCode}');
      debugPrint('Delete employee response: ${response.body}');

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        debugPrint('Employee deleted successfully.');
        return true;
      }

      throw Exception(
        'Failed to delete employee: ${response.body}',
      );
    } catch (error) {
      debugPrint('Delete employee API error: $error');
      rethrow;
    }
  }
}
