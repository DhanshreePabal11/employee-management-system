import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String department;
  final VoidCallback? onTap;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.department,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: AppColors.borderColor,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        leading: const CircleAvatar(
          backgroundColor: AppColors.lightBlueColor,
          child: Icon(
            Icons.person,
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        subtitle: Text(
          department,
          style: const TextStyle(
            color: AppColors.greyColor,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.greyColor,
        ),
      ),
    );
  }
}