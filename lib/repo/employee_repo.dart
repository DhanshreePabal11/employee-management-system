
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/employee_model.dart';

class EmployeeRepo {
  static const String _storageKey = 'saved_employees';

  bool _isLoaded = false;

  final List<EmployeeModel> _employees = [
    EmployeeModel(
      name: 'Aarav Sharma',
      email: 'aarav@example.com',
      phone: '9876543210',
      department: 'HR',
      salary: 30000,
    ),
    EmployeeModel(
      name: 'Priya Patil',
      email: 'priya@example.com',
      phone: '9876543211',
      department: 'IT',
      salary: 40000,
    ),
    EmployeeModel(
      name: 'Rohan Verma',
      email: 'rohan@example.com',
      phone: '9876543212',
      department: 'Finance',
      salary: 35000,
    ),
  ];


  Future<void> loadEmployees() async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_storageKey);

    if (savedData != null) {
      final List<dynamic> decodedData = jsonDecode(savedData);

      _employees
        ..clear()
        ..addAll(
          decodedData.map(
            (item) => EmployeeModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          ),
        );
    } else {
    
      await _saveEmployees();
    }

    _isLoaded = true;
  }


  List<EmployeeModel> getEmployees() {
    return List.unmodifiable(_employees);
  }


  Future<void> addEmployee(EmployeeModel employee) async {
    await loadEmployees();

    _employees.add(employee);

    await _saveEmployees();
  }

  Future<void> _saveEmployees() async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(
      _employees.map((employee) => employee.toJson()).toList(),
    );

    await prefs.setString(_storageKey, encodedData);
  }
}
