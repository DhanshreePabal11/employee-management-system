
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../custom_widgets/custom_button.dart';
import '../custom_widgets/custom_text_field.dart';
import '../model/employee_model.dart';
import '../repo/employee_repo.dart';

class AddEmployeeScreen extends StatefulWidget {
  final EmployeeRepo employeeRepo;

  const AddEmployeeScreen({
    super.key,
    required this.employeeRepo,
  });

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final salaryController = TextEditingController();

  String? department;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  void saveEmployee() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final employee = EmployeeModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      department: department!,
      salary: double.parse(salaryController.text.trim()),
    );

    widget.employeeRepo.addEmployee(employee);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.employeeAdded),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: const Text(AppStrings.addEmployee),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Employee Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter the details below to add a new employee.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyColor,
                ),
              ),

              const SizedBox(height: 24),

              // Employee name
              CustomTextField(
                controller: nameController,
                label: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter employee name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Employee email
              CustomTextField(
                controller: emailController,
                label: AppStrings.email,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter email';
                  }

                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Employee phone
              CustomTextField(
                controller: phoneController,
                label: AppStrings.phone,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                    return 'Enter a valid 10-digit phone number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Department dropdown
              DropdownButtonFormField<String>(
                value: department,
                decoration: InputDecoration(
                  labelText: AppStrings.department,
                  prefixIcon: const Icon(Icons.business_outlined),
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.borderColor,
                    ),
                  ),
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'HR',
                    child: Text('Human Resources'),
                  ),
                  DropdownMenuItem(
                    value: 'IT',
                    child: Text('Information Technology'),
                  ),
                  DropdownMenuItem(
                    value: 'Finance',
                    child: Text('Finance'),
                  ),
                  DropdownMenuItem(
                    value: 'Marketing',
                    child: Text('Marketing'),
                  ),
                  DropdownMenuItem(
                    value: 'Sales',
                    child: Text('Sales'),
                  ),
                  DropdownMenuItem(
                    value: 'Operations',
                    child: Text('Operations'),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    department = value;
                  });
                },

                validator: (value) {
                  if (value == null) {
                    return 'Select department';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Employee salary
              CustomTextField(
                controller: salaryController,
                label: 'Monthly Salary',
                prefixIcon: Icons.currency_rupee,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final salary = double.tryParse(value?.trim() ?? '');

                  if (salary == null || salary <= 0) {
                    return 'Enter a valid salary';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 28),

              // Save employee button
              CustomButton(
                text: 'Save Employee',
                onPressed: saveEmployee,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
