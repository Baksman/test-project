import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPage createState() => _AddTaskPage();
}

class _AddTaskPage extends State<AddTaskPage> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            SizedBox(height: _padding),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              minLines: 5,
              maxLines: 10,
            ),
            SizedBox(height: _padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Completed ?'),
                CupertinoSwitch(
                  value: task.isCompleted,
                  onChanged: (_) {
                    setState(() {
                      task.toggleComplete();
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => _save(context),
              child: Container(
                width: double.infinity,
                child: Center(child: Text(task.isNew ? 'Create' : 'Update')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
