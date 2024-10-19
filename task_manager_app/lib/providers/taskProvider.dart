import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../APIServices/taskServices.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class TaskNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final ApiService apiService;
  final Box tasksBox = Hive.box('tasksBox'); // Reference to Hive box

  TaskNotifier(this.apiService) : super([]) {
    loadLocalTasks();
  }

  // Load tasks from local storage (Hive)
  void loadLocalTasks() {
    final localTasks = tasksBox.values
        .map((task) => Map<String, dynamic>.from(task)) // Ensure proper casting
        .toList();
    if (localTasks.isNotEmpty) {
      state = localTasks;
      print('Loaded tasks from local storage');
    }
  }

  Future<void> loadTasks() async {
    try {
      // Load tasks from the API
      final tasksFromApi = await apiService.fetchTasks();
      state = tasksFromApi;

      tasksBox.clear(); // Clear Hive box to avoid duplicates
      for (var task in tasksFromApi) {
        tasksBox.put('${task['id']}', task);
      }
    } catch (e) {
      // Handle any errors
      print('Failed to load tasks: $e');
      loadLocalTasks();
    }
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    try {
      var uuid = Uuid();
      String uniqueId = uuid.v4();
      task['id'] = uniqueId;

      state = [...state, task]; // Update state after adding
      tasksBox.put('${uniqueId}', task); // Save task to local storage

      int taskId = await apiService.addTask(task);
      tasksBox.putAt(taskId, task);

      // tasksBox
    } catch (err) {
      print("add this task to local storage only!");
    }
  }

  void updateTask(int index, Map<String, dynamic> task) async {
    try {
      final tasks = [...state];
      tasks[index] = task;
      state = tasks;
      // tasksBox.putAt(task['id'], task);
      tasksBox.delete(task['id']);
      tasksBox.put('${task['id']}', task);

      // tasksBox.putAt(task['id'], task);
      await apiService.updateTask(task);
    } catch (err) {
      print('Failed to update task in API: $err');
    }
  }

  void removeTask(Map<String, dynamic> task) async {
    try {
      final tasks = [...state];
      tasks.removeWhere((t) => t['id'] == task['id']);
      state = tasks;

      tasksBox.delete(task['id']);

      // tasksBox.delete(task['id']);
      await apiService.removeTask(task['id']);
    } catch (err) {
      print("Failed to remove the task from mysql!");
    }
  }
}

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Map<String, dynamic>>>((ref) {
  final apiService = ApiService(
      'http://192.168.100.74:3000'); // to use the API on an physical device you should use the ipv4 of the pc
  return TaskNotifier(apiService);
});
