
class EmployeeModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final double salary;

  EmployeeModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.salary,
  });

 
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'salary': salary,
    };
  }
 
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] == null
          ? null
          : (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      department: json['department']?.toString() ?? 'General',
      salary: json['salary'] is num
          ? (json['salary'] as num).toDouble()
          : double.tryParse(
                json['salary']?.toString() ?? '',
              ) ??
              0.0,
    );
  }
}
