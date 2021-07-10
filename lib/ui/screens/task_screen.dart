import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project/datasources/failure/error.dart';
import 'package:project/models/task.dart';
import 'package:project/ui/screens/add_taskscreen.dart';
import 'package:project/ui/widget/snackbar_utils.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatelessWidget {
  final bool isAll;
  

  const TasksPage({Key key, this.isAll}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(isAll ? "All tasks" : "Completed tasks"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => navigate(context, true, null),
            )
          ],
        ),
        body: StreamBuilder<Either<AppError, List<TaskModel>>>(
          stream: isAll
              ? taskProvider.getAllTask()
              : taskProvider.getCompletedTask(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error);
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data.fold((l) => Text(l.message), (r) {
              if (r.isEmpty) {
                return Center(
                  child: isAll
                      ? Text('Add your first task')
                      : Text('Add your first completed task'),
                );
              }
              return _itemWidget(r, taskProvider);
            });
          },
        ));
  }

  Widget _itemWidget(List<TaskModel> taskModel, taskProvider) {
    return ListView.builder(
        itemCount: taskModel.length,
        itemBuilder: (ctx, index) {
          return _TaskWidget(taskModel[index], taskProvider);
        });
  }
}

class _TaskWidget extends StatelessWidget {
  final TaskViewModel taskViewModel;
  final TaskModel task;
  _TaskWidget(this.task, this.taskViewModel);

  void _delete(BuildContext context) {
    taskViewModel.deleteTask(task.id);
    showScaffoldSnackbar("Task deleted", context);
  }

  void _toggleComplete(BuildContext context) {
    task.isTaskCompleted
        ? taskViewModel.unCompleteTask(task.id)
        : taskViewModel.completeTask(task.id);
    showScaffoldSnackbar(
        task.isTaskCompleted ? "Task incompleted" : "Task completed", context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => navigate(context, false, task),
      leading: IconButton(
        icon: Icon(
          task.isTaskCompleted
              ? Icons.check_box
              : Icons.check_box_outline_blank,
        ),
        onPressed: () {
          _toggleComplete(context);
        },
      ),
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
        ),
        onPressed: () {
          _delete(context);
        },
      ),
      // onTap: () => _view(context),
    );
  }
}

void navigate(BuildContext context, bool isNew, TaskModel task) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => AddTaskPage(
              task: task,
              isNew: isNew,
            )),
  );
}
