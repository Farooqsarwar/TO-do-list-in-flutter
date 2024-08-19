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
    'All Lists': [], // Initialize 'All Lists'
  };

  String? selectedItem = 'All Lists';

  // Combine all lists into 'All Lists' excluding 'Finished'
  void updateAllLists() {
    taskLists['All Lists'] = taskLists.entries
        .where((entry) => entry.key != 'Finished' && entry.key != 'All Lists')
        .expand((entry) => entry.value)
        .toList();
    notifyListeners();
  }

  // Retrieve tasks for the selected list
  List<Map<String, String>> getTasksForSelectedList() {
    return taskLists[selectedItem!] ?? [];
  }

  // Add a task to the selected list
  void addTaskToList(String listName, Map<String, String> task) {
    taskLists[listName]?.add(task);
    updateAllLists(); // Update 'All Lists' after adding a task
    notifyListeners();
    saveData();
  }

  // Remove a task by ID from the selected list
  void removeTaskById(String listName, String id) {
    taskLists[listName]?.removeWhere((task) => task['id'] == id);
    updateAllLists(); // Update 'All Lists' after removing a task
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
    updateAllLists(); // Ensure 'All Lists' is updated after loading data
    notifyListeners();
  }
}
