
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../custom_widgets/custom_button.dart';
import '../custom_widgets/custom_text_field.dart';
import '../model/employee_model.dart';
import '../repo/employee_repo.dart';
import '../repo/employee_api_repo.dart';

class AddEmployeeScreen extends StatefulWidget {
  final EmployeeRepo employeeRepo;

  const AddEmployeeScreen({
    super.key,
    required this.employeeRepo,
  });

  @override
  State<AddEmployeeScreen> createState() =>
      _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final salaryController = TextEditingController();

  final EmployeeApiRepo employeeApiRepo = EmployeeApiRepo();

  String? department;
  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  Future<void> saveEmployee() async {
    if (isSaving) return;

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final employee = EmployeeModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        department: department!,
        salary: double.parse(salaryController.text.trim()),
      );

      
      await employeeApiRepo.addEmployeeToApi(employee);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

  
      Navigator.pop(context, true);
    } catch (error) {
      debugPrint('Failed to add employee: $error');

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not save employee. $error',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.addEmployee),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.person_add_alt_1,
                      color: AppColors.whiteColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Employee',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Enter employee details to create a profile.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                 
                    const Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    CustomTextField(
                      controller: nameController,
                      label: 'Full Name',
                      prefixIcon: Icons.badge_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter employee name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: emailController,
                      label: AppStrings.email,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter email';
                        }

                        if (!RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(value.trim())) {
                          return 'Enter a valid email';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: phoneController,
                      label: AppStrings.phone,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^\d{10}$')
                                .hasMatch(value.trim())) {
                          return 'Enter a valid 10-digit phone number';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    const Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Work Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    DropdownButtonFormField<String>(
                      initialValue: department,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: AppStrings.department,
                        prefixIcon: const Icon(
                          Icons.business_outlined,
                          color: AppColors.greyColor,
                        ),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
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

                    CustomTextField(
                      controller: salaryController,
                      label: 'Monthly Salary',
                      prefixIcon: Icons.currency_rupee,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        final salary =
                            double.tryParse(value?.trim() ?? '');

                        if (salary == null || salary <= 0) {
                          return 'Enter a valid salary';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                 CustomButton(
  text: isSaving ? 'Saving...' : 'Save Employee',
  onPressed: saveEmployee,
),
                    const SizedBox(height: 12),

            
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: isSaving
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          side: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
