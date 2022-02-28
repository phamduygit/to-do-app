import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';

import '../data/task_database.dart';

class DetailTask extends StatefulWidget {
  const DetailTask({Key? key, required this.task}) : super(key: key);
  final Task task;

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  final _formKey = GlobalKey<FormState>();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.task.completeDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.task.completeDate),
    );
    if (pickedTime != null && pickedDate != null) {
      setState(() {
        widget.task.completeDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var tasks = context.watch<ListTask>();
    return Scaffold(
      key: const Key("detail 1"),
      appBar: AppBar(
        title: const Text("Detail Task"),
        actions: [
          IconButton(
            onPressed: () async {
              if (widget.task.status == 0) {
                widget.task.status = 1;
              } else {
                widget.task.status = 0;
              }
              tasks.update(widget.task);
              await ListTaskDAO().update(widget.task);
              await ListTaskDAO().close();
            },
            icon: Icon(widget.task.status == 1 ? Icons.check : Icons.close),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                key: const Key('titleField'),
                initialValue: widget.task.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                onSaved: (value) {
                  widget.task.title = value!;
                  tasks.update(widget.task);
                  var tasksDAO = ListTaskDAO();
                  tasksDAO.update(widget.task);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "New task",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFormField(
              key: const Key('descriptionField'),
              initialValue: widget.task.description,
              onSaved: (value) {
                widget.task.description = value!;
                tasks.update(widget.task);
                var tasksDAO = ListTaskDAO();
                tasksDAO.update(widget.task);
              },
              decoration: const InputDecoration(
                hintText: "Detailed task",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.menu_sharp),
              ),
            ),
            InkWell(
              onTap: () async {
                await _selectDate(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Chip(
                          label: Text(DateFormat('hh:mm, EEE, dd MMM')
                              .format(widget.task.completeDate)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete task'),
                          content: const Text('You want to delete this task'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                tasks.remove(widget.task);
                                var tasksDAO = ListTaskDAO();
                                tasksDAO.delete(widget.task.id);
                                int count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          tasks.update(widget.task);
                          var tasksDAO = ListTaskDAO();
                          await tasksDAO.close();
                          const snackBar = SnackBar(
                            content: Text('Update successful'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
