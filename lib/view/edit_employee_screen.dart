
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../model/employee_model.dart';
import '../repo/employee_api_repo.dart';

class EditEmployeeScreen extends StatefulWidget {
  final EmployeeModel employee;
  final int employeeId;

  const EditEmployeeScreen({
    super.key,
    required this.employee,
    required this.employeeId,
  });

  @override
  State<EditEmployeeScreen> createState() =>
      _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final formKey = GlobalKey<FormState>();
  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController salaryController;

  final List<String> departments = [
    'Human Resources',
    'Information Technology',
    'Finance',
    'Marketing',
    'Sales',
    'Operations',
    'General',
  ];

  String? selectedDepartment;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.employee.name);
    emailController =
        TextEditingController(text: widget.employee.email);
    phoneController =
        TextEditingController(text: widget.employee.phone);
    salaryController = TextEditingController(
      text: widget.employee.salary.toString(),
    );

    selectedDepartment = departments.contains(
      widget.employee.department,
    )
        ? widget.employee.department
        : 'General';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  Future<void> updateEmployee() async {
    if (isUpdating) return;

    if (!formKey.currentState!.validate()) return;

    setState(() {
      isUpdating = true;
    });

    try {
      final updatedEmployee = EmployeeModel(
        id: widget.employeeId,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        department: selectedDepartment!,
        salary: double.parse(salaryController.text.trim()),
      );

      final success =
          await employeeApiRepo.updateEmployeeInApi(
        widget.employeeId,
        updatedEmployee,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, updatedEmployee);
      }
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update employee: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Employee'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Employee Details',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Edit the information below and save your changes.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyColor,
                ),
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
              ),
              _buildTextField(
                controller: emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email address';
                  }

                  if (!value.contains('@') ||
                      !value.contains('.')) {
                    return 'Please enter a valid email address';
                  }

                  return null;
                },
              ),
              _buildTextField(
                controller: phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Department',
                  prefixIcon: const Icon(
                    Icons.business_outlined,
                    color: AppColors.primaryColor,
                  ),
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: departments.map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: isUpdating
                    ? null
                    : (value) {
                        setState(() {
                          selectedDepartment = value;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a department';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _buildTextField(
                controller: salaryController,
                label: 'Monthly Salary',
                icon: Icons.currency_rupee,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter salary';
                  }

                  final salary = double.tryParse(value.trim());

                  if (salary == null || salary < 0) {
                    return 'Please enter a valid salary';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      isUpdating ? null : updateEmployee,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isUpdating
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Update Employee',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: !isUpdating,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: AppColors.primaryColor,
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
      ),
    );
  }
}
