
import 'dart:convert';

import 'package:http/http.dart' as http;

class AttendanceApiRepo {
  static const String baseUrl =
    'https://employee-management-system-backend-beryl.vercel.app/attendance';

  Future<List<Map<String, dynamic>>> getAttendance(String date) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {'attendance_date': date},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    throw Exception('Failed to load attendance: ${response.body}');
  }

  Future<Map<String, dynamic>> addAttendance({
    required int employeeId,
    required String date,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employee_id': employeeId,
        'date': date,
        'status': status,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    }

    throw Exception('Failed to save attendance: ${response.body}');
  }

  Future<Map<String, dynamic>> updateAttendance({
    required int attendanceId,
    required int employeeId,
    required String date,
    required String status,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$attendanceId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employee_id': employeeId,
        'date': date,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    }

    throw Exception('Failed to update attendance: ${response.body}');
  }
}
