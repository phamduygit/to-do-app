import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/data/task_database.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);
  final Task task;
  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    var tasks = context.watch<ListTask>();
    return Card(
      key: Key(widget.task.id),
      child: ListTile(
        trailing: InkWell(
          key: Key("checkbox ${widget.task.id}"),
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            child: Icon(
              widget.task.status == 0
                  ? Icons.square_outlined
                  : Icons.check_box,
              size: 28,
            ),
          ),
          onTap: () {
            if (widget.task.status == 0) {
              widget.task.status = 1;
            } else {
              widget.task.status = 0;
            }
            tasks.update(widget.task);
            ListTaskDAO().update(widget.task);
          },
        ),
        title: Text(widget.task.title),
        subtitle: Text(
          DateFormat('HH:mm, EEE, dd MMM').format(widget.task.completeDate),
        ),
      ),
    );
  }
}
