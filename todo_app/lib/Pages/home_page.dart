import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Pages/edit_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key});

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<dynamic> todoList = [];

  @override
  void initState() {
    super.initState();
    fetchTodoList();
  }

  Future<void> fetchTodoList() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/tasks/'));
    if (response.statusCode == 200) {
      setState(() {
        todoList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load todo list');
    }
  }

  Future<void> deleteTodo(int id) async {
    final response =
        await http.delete(Uri.parse('http://10.0.2.2:8000/tasks/$id/delete/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
    fetchTodoList(); // Refresh the list after deleting a task
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoList[index]['title']),
            subtitle: Text(todoList[index]['desc']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(todoList[index]['isDone'] ? 'Completed' : 'Not'),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTodoPage(
                          todoId: todoList[index]['id'],
                          title: todoList[index]['title'],
                          desc: todoList[index]['desc'],
                          isDone: todoList[index]['isDone'],
                          refreshTodoList: fetchTodoList,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await deleteTodo(todoList[index]['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String title = '';
              String desc = '';
              return AlertDialog(
                title: const Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      onChanged: (value) => title = value,
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      onChanged: (value) => desc = value,
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      addTodo(title, desc);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> addTodo(String title, String desc) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/tasks/create/'),
      body: {'title': title, 'desc': desc, 'isDone': 'false'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
    fetchTodoList(); // Refresh the list after adding a task
  }
}
