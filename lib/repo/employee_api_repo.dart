
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/employee_model.dart';

class EmployeeApiRepo {
  Future<List<EmployeeModel>> getEmployeesFromApi() async {
    final url = Uri.parse(
      'https://jsonplaceholder.typicode.com/users',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((user) {
        return EmployeeModel(
          name: user['name'] ?? '',
          email: user['email'] ?? '',
          phone: user['phone'] ?? '',
          department: 'General',
          salary: 0.0,
        );
      }).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }
}
