import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/widgets/add_button.dart';
import 'package:to_do_app/widgets/detail_task.dart';
import 'package:to_do_app/widgets/task_card.dart';

class IncompleteScreen extends StatelessWidget {
  const IncompleteScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listIncompleteTask = context
        .watch<ListTask>()
        .listTask
        .where((element) => element.status == 0)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incomplete"),
        actions: const [
          AddButton(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: listIncompleteTask.length,
                itemBuilder: (context, index) => GestureDetector(
                  child: TaskCard(task: listIncompleteTask[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTask(
                          task: listIncompleteTask[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

