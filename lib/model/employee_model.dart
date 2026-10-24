
class EmployeeModel {
  final String name;
  final String email;
  final String phone;
  final String department;
  final double salary;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.salary,
  });

  // Convert an employee object into JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'salary': salary,
    };
  }

  // Convert saved JSON back into an employee object.
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      department: json['department'] as String,
      salary: (json['salary'] as num).toDouble(),
    );
  }
}
