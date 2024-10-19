import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseURL;

  ApiService(this.baseURL);

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseURL/tasks'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json
          .decode(response.body)['tasks']; // Assuming tasks come as an array
      return jsonResponse.map((task) {
        return {
          'id': task['id'], // Extract task ID
          'taskContent': task['taskContent'], // Extract task content
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<int> addTask(Map<String, dynamic> task) async {
    final taskContent = task['taskContent'];
    final response = await http.post(
      Uri.parse('$baseURL/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'taskContent': taskContent}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    } else {
      int jsonResponse = json.decode(response.body)['taskId'];
      return jsonResponse;
    }
  }

  Future<void> removeTask(int id) async {
    final response = await http.delete(
      Uri.parse('${baseURL}/tasks/${id}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    final response = await http.put(Uri.parse('${baseURL}/tasks/${task['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'taskContent': '${task['taskContent']}'}));

    if (response.statusCode != 200) {
      throw Exception('Failed to update the task');
    }
  }
}
