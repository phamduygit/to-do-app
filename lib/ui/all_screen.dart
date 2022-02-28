import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/widgets/add_button.dart';

import '../models/list_task.dart';
import '../widgets/detail_task.dart';
import '../widgets/task_card.dart';

class AllScreen extends StatelessWidget {
  const AllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listTask = context.watch<ListTask>().listTask;
    return Scaffold(
      appBar: AppBar(
        title: const Text("All"),
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
                itemCount: listTask.length,
                itemBuilder: (context, index) => GestureDetector(
                  child: TaskCard(task: listTask[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTask(
                          task: listTask[index],
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
