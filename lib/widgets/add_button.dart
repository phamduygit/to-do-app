import 'package:flutter/material.dart';

import 'new_task.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return const NewTask();
          },
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
