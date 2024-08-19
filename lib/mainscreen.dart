import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/task.dart';
import 'lists.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  String? _selectedItem = 'All Lists';
  final List<String> _items = [
    'All Lists', 'Default', 'Personal', 'Shopping', 'Wishlist', 'Work', 'Finished'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<Userlists>(context, listen: false).loadData());
  }

  Future<void> deleteTask(Userlists userLists, int index) async {
    var tasks = userLists.getTasksForSelectedList();
    var taskToDelete = tasks[index];
    String listName = _selectedItem ?? 'Default';
    userLists.removeTaskById(listName, taskToDelete['id']!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task deleted")),
    );
  }

  void _showTaskDetails(Map<String, String> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo,
          title: const Text("Task Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Task: ${task['task'] ?? 'Unnamed Task'}"),
              const SizedBox(height: 8),
              Text("Date: ${task['date'] ?? 'No Date'}"),
              const SizedBox(height: 8),
              Text("Time: ${task['time'] ?? 'No Time'}"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var userLists = Provider.of<Userlists>(context);

    return Scaffold(
      backgroundColor: Colors.indigo.withBlue(53).withGreen(13).withRed(8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 15),
            DropdownButton<String>(
              dropdownColor: Colors.indigo,
              style: const TextStyle(color: Colors.white, fontSize: 22),
              hint: const Text(
                "All Lists",
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
                  userLists.selectedItem = newValue;
                  userLists.notifyListeners();
                });
              },
            ),
          ],
        ),
        actions: [
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 28,
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.format_line_spacing_sharp,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
        backgroundColor: Colors.indigo,
      ),
      resizeToAvoidBottomInset: true,
      body: userLists.getTasksForSelectedList().isEmpty
          ? _buildEmptyState()
          : _buildTaskList(userLists),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Task()));
        },
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
      ),
    );
  }

  Widget _buildTaskList(Userlists userLists) {
    List<Map<String, String>> tasks = userLists.getTasksForSelectedList();

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(tasks[index]['id']!),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            // Retrieve the task being dismissed
            final dismissedTask = tasks[index];

            // Add the task to the 'Finished' list
            userLists.addTaskToList('Finished', dismissedTask);
            // Remove the task from the current list
            deleteTask(userLists, index);
          },
          child: Card(
            color: Colors.indigo,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text(
                tasks[index]['task'] ?? 'Unnamed Task',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                _showTaskDetails(tasks[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage("assets/nothing.jpg"),
            radius: 90,
          ),
          SizedBox(height: 10),
          Text(
            "Nothing To Do",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
