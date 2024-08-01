import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/task.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [];

  TaskData() {
    loadTasks();
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    saveTasks();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    saveTasks();
    notifyListeners();
  }

  // Save tasks to SharedPreferences
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = _tasks.map((task) => task.toMap()).toList();
    final taskListString = jsonEncode(taskList);
    print('Saving tasks: $taskListString');
    await prefs.setString('tasks', taskListString);
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListString = prefs.getString('tasks');
    if (taskListString != null) {
      print('Loading tasks: $taskListString');
      final List<dynamic> taskList = jsonDecode(taskListString);
      _tasks.clear();
      _tasks.addAll(taskList.map((task) => Task.fromMap(task)).toList());
      notifyListeners();
    } else {
      print('No tasks found in SharedPreferences');
    }
  }
}
