


import 'package:flutter/material.dart';
import 'package:project/models/task.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("All tasks"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            // onPressed: () => addTask(context),
          )
        ],
      ),
      body: StreamBuilder(
        stream: taskProvider.getAllTask().fold((l) => null, (r) => null),
      )
      // tasks.isEmpty
          // ? Center(
          //     child: Text('Add your first task'),
          //   )
          // : ListView.builder(
          //     itemCount: tasks.length,
          //     itemBuilder: (context, index) {
          //       return _Task(
          //         tasks[index],
          //       );
          //     },
          //   ),
    );
  }
}

class _Task extends StatelessWidget {
  _Task(this.task);

  final Task task;

  void _delete() {
    //TODO implement delete to firestore
  }

  void _toggleComplete() {
    //TODO implement toggle complete to firestore
  }

  void _view(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: _toggleComplete,
      ),
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
        ),
        onPressed: _delete,
      ),
      onTap: () => _view(context),
    );
  }
}
