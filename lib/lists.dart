import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userlists extends ChangeNotifier {
  Map<String, List<Map<String, String>>> taskLists = {
    'Default': [],
    'Personal': [],
    'Shopping': [],
    'Wishlist': [],
    'Work': [],
    'Finished': [],
  };

  String? selectedItem = 'All Lists';

  // Retrieve tasks for the selected list
  List<Map<String, String>> getTasksForSelectedList() {
    if (selectedItem == 'All Lists') {
      return taskLists.values.expand((list) => list).toList();
    }
    return taskLists[selectedItem!] ?? [];
  }

  // Add a task to the selected list
  void addTaskToList(String listName, Map<String, String> task) {
    taskLists[listName]?.add(task);
    notifyListeners();
    saveData();
  }

  // Remove a task by ID from the selected list
  void removeTaskById(String listName, String id) {
    taskLists[listName]?.removeWhere((task) => task['id'] == id);
    notifyListeners();
    saveData();
  }

  // Save data to SharedPreferences
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    taskLists.forEach((key, value) {
      prefs.setString(key, jsonEncode(value));
    });
  }

  // Load data from SharedPreferences
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    taskLists.keys.forEach((key) {
      String jsonString = prefs.getString(key) ?? '[]';
      List<dynamic> jsonList = jsonDecode(jsonString);
      taskLists[key] = jsonList.map((item) {
        return Map<String, String>.from(item as Map<dynamic, dynamic>);
      }).toList();
    });
    notifyListeners();
  }
}
