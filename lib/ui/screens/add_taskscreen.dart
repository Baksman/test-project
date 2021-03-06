import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:project/models/task.dart';
import 'package:project/ui/widget/snackbar_utils.dart';
import 'package:project/utils/mediaquery_ext.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatefulWidget {
  final bool isNew;
  final TaskModel task;

  const AddTaskPage({Key key, this.isNew, this.task}) : super(key: key);
  @override
  _AddTaskPage createState() => _AddTaskPage();
}

class _AddTaskPage extends State<AddTaskPage> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  bool isCompleted;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _titleController =
        TextEditingController(text: widget.isNew ? "" : widget.task.title);
    _descriptionController = TextEditingController(
        text: widget.isNew ? "" : widget.task.description);
    isCompleted = widget.task?.isTaskCompleted ?? false;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskViewModel>(context);

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          key: Key("add-task"),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            height: context.height,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    key: Key("input1"),
                    validator: _validator,
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: Key("input2"),
                    controller: _descriptionController,
                    validator: _validator,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    minLines: 5,
                    maxLines: 10,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Completed ?'),
                      CupertinoSwitch(
                        value: isCompleted,
                        onChanged: (val) {
                          setState(() {
                            isCompleted = val;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  // Spacer(),
                  ElevatedButton(
                    key: Key("submit"),
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState.validate()) {
                              await submit(provider);
                            }
                          },
                    child: Center(
                        child: provider.isLoading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.teal,
                                key: Key("progressI"),
                              )
                            : Text(
                                widget.isNew ? 'Create' : 'Update',
                                key: Key("btn-text"),
                              )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _validator(String text) {
    if (text.trim().isEmpty) {
      return "invalid";
    }
    return null;
  }

  Future<void> submit(TaskViewModel taskViewModel) async {
    TaskModel task;
    if (!widget.isNew) {
      task = widget.task.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          isCompleted: isCompleted);
    } else {
      task = TaskModel(
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: isCompleted,
      );
    }

    final result = await taskViewModel.addTask(task);
    result.fold(
        (l) => showKeySnackbar(
            widget.isNew
                ? "Error occured couldnt create successfully"
                : "Error occured couldnt update successfully",
            scaffoldMessengerKey),
        (r) => showKeySnackbar(
            widget.isNew ? "Created successfully" : "Updated successfully",
            scaffoldMessengerKey));
  }
}
