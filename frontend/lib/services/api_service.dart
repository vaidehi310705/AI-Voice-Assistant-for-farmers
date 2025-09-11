import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl =
      "http://192.168.1.5:8000"; // Replace with your system IP

  static Future<String> getSolution(String prompt) async {
    final response = await http.post(
      Uri.parse("$baseUrl/solution/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"prompt": prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["solution"];
    } else {
      throw Exception("Failed to fetch solution");
    }
  }
}
