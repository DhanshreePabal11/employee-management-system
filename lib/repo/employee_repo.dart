
import '../model/employee_model.dart';

class EmployeeRepo {
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

  List<EmployeeModel> getEmployees() {
    return List.unmodifiable(_employees);
  }

  void addEmployee(EmployeeModel employee) {
    _employees.add(employee);
  }
}
