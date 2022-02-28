import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/data/task_database.dart';
// import 'package:to_do_app/data-access/list_task_provider.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';
import 'package:uuid/uuid.dart';
// import 'package:to_do_app/services/notification_service.dart';

class NewTask extends StatefulWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  Task newTask = Task(completeDate: DateTime.now(), id: const Uuid().v1());
  final _formKey = GlobalKey<FormState>();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedDate != null) {
      setState(() {
        newTask.completeDate = DateTime(
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
    return SafeArea(
      child: Padding(
        key: const Key('bottomModelSheet'),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key("title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    newTask.title = value!;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "New task",
                  border: InputBorder.none,
                ),
              ),
              TextFormField(
                key: const Key("description"),
                onSaved: (value) {
                  setState(() {
                    newTask.description = value!;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          _selectDate(context);
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Ink(
                          child: Container(
                            child: const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.blue,
                            ),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Chip(
                        label: Text(DateFormat('hh:mm, EEE, dd MMM')
                            .format(newTask.completeDate)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    key: const Key('saveButton'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        tasks.add(newTask);
                        var tasksDAO = ListTaskDAO();
                        tasksDAO.insert(newTask);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
