import 'package:flutter/material.dart';
import 'package:tasks/core/app_theme.dart';
import 'package:tasks/core/ttotoy_entity.dart';
import 'package:tasks/view_todo/home_todo/todo_dialog.dart';
import 'package:tasks/view_todo/home_todo/no_todo.dart';
import 'package:tasks/view_todo/home_todo/todo_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDoEntity> todos = [];

  Future<void> _addTodo() async {
    final newTodo = await showModalBottomSheet(
      context: context,
      builder: (context) => AddToDoDialog(),
    );
    if (newTodo != null) {
      setState(() {
        todos.add(newTodo);
      });
    }
  }

  void toggleFavorite(ToDoEntity todo) {
    setState(() {
      final index = todos.indexOf(todo);
      todos[index] = ToDoEntity(
        title: todo.title,
        description: todo.description,
        isFavorite: !todo.isFavorite,
        isDone: todo.isDone,
      );
    });
  }

  void toggleDone(ToDoEntity todo) {
    setState(() {
      final index = todos.indexOf(todo);
      todos[index] = ToDoEntity(
        title: todo.title,
        description: todo.description,
        isFavorite: todo.isFavorite,
        isDone: !todo.isDone,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: vrc(context).background300,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: vrc(context).background200,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            color: vrc(context).textColor200,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: todos.isEmpty
          ? NoToDo(title: widget.title)
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) => ToDoView(
                  toDo: todos[index],
                  onToggleFavorite: () => toggleFavorite(todos[index]),
                  onToggleDone: () => toggleDone(todos[index]),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: fxc(context).brandColor,
        shape: CircleBorder(),
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add_rounded, size: 24),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
