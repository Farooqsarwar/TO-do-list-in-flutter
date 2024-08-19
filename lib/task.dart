import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'lists.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}
class _TaskState extends State<Task> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  String? _selectedItem;
  final List<String> _items = ['Default', 'Personal', 'Shopping', 'Wishlist', 'Work',];
  final Uuid uuid = Uuid(); // Initialize uuid generator
  @override
  Widget build(BuildContext context) {
    var userLists = Provider.of<Userlists>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Task",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.withBlue(53).withGreen(13).withRed(8),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, top: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What Is To Be Done?",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _taskController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Enter Task Here",
                    labelStyle: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
                    suffixIcon: Icon(Icons.arrow_right_outlined, size: 35, color: Colors.white),
                    iconColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Due Date",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                    labelText: "Select Date",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white70),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      barrierColor: Colors.black,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(3000),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Due Time",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.access_time, color: Colors.white),
                    labelText: "Select Time",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white70),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(

                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _timeController.text = pickedTime.format(context);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select List",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              DropdownButton<String>(
                dropdownColor: Colors.indigo,
                style: const TextStyle(color: Colors.white, fontSize: 22),
                hint: const Text(
                  "Select List",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                value: _selectedItem,
                items: _items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_taskController.text.isNotEmpty && _selectedItem != null) {
                    var newTask = {
                      'id': uuid.v4(),
                      'task': _taskController.text,
                      'date': _dateController.text,
                      'time': _timeController.text,
                    };

                    userLists.addTaskToList(_selectedItem!, newTask);
                   Timer(const Duration(seconds :5),(){
                   Navigator.pop(context);
                   });
                  } else {
                    // Handle validation or missing information
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in all details")),
                    );
                  }
                },
                child: const Text(
                  "Add Task",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
