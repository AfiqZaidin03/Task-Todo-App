import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTodoPage extends StatefulWidget {
  final int todoId;
  final String title;
  final String desc;
  final bool isDone;
  final Function refreshTodoList;

  const EditTodoPage({
    Key? key,
    required this.todoId,
    required this.title,
    required this.desc,
    required this.isDone,
    required this.refreshTodoList,
  }) : super(key: key);

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descController = TextEditingController(text: widget.desc);
    _isDone = widget.isDone;
  }

  Future<void> updateTodo(
    int id,
    String title,
    String desc,
    bool isDone,
  ) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/tasks/$id/update/'),
      body: {'title': title, 'desc': desc, 'isDone': isDone.toString()},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
    widget.refreshTodoList(); // Trigger a refresh of the todo list
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Checkbox(
              value: _isDone,
              onChanged: (value) {
                setState(() {
                  _isDone = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateTodo(
                  widget.todoId,
                  titleController.text,
                  descController.text,
                  _isDone,
                );
                Navigator.pop(context);
              },
              child: const Text('Update Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
