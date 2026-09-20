import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Update the base URL if your backend server URL changes.
  // miski ipaddress
  // final String baseUrl = '192.168.221.51:3000'; // Use your server's IP or domain if hosted remotely
  // test
  final String baseUrl =
      'https://node-firebase-backend-production.up.railway.app'; // Use your server's IP or domain if hosted remotely

  Future<Map<String, dynamic>> saveResult(Map<String, dynamic> result) async {
    final response = await http.post(
      Uri.parse('$baseUrl/results'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(result),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to save result');
    }
  }

  Future<List<Map<String, dynamic>>> getResults() async {
    final response = await http.get(Uri.parse('$baseUrl/results'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load results');
    }
  }
}
