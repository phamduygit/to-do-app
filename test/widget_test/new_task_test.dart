import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/widgets/new_task.dart';

Widget createNewTaskScreen() {
  ListTask listTask = ListTask();
  for (var i = 1; i < 15; i++) {
    listTask.add(
      Task(
        id: "$i",
        title: "Task $i",
        description: "Do homework",
        completeDate: DateTime.now(),
        status: i % 2,
      ),
    );
  }
  return ChangeNotifierProvider<ListTask>(
    create: (context) => listTask,
    child: const MaterialApp(
      home: Scaffold(body: NewTask()),
    ),
  );
}

void main() {
  group('New task screen widget test', () {
    testWidgets('Test if bottom modal sheet show up',
        (WidgetTester tester) async {
      await tester.pumpWidget(createNewTaskScreen());
      var totalTextField = tester.widgetList(find.byType(TextFormField)).length;
      expect(totalTextField, 2);
      var saveButton = find.byType(TextButton);
      expect(saveButton, findsOneWidget);
    });
    testWidgets('When enter title and description and tap save',
        (WidgetTester tester) async {
      await tester.pumpWidget(createNewTaskScreen());
      var titleTextField = find.byKey(const Key('title'));
      var descriptionTextField = find.byKey(const Key('description'));
      await tester.enterText(titleTextField, 'Do something');
      // await tester.pump();
      await tester.enterText(descriptionTextField, 'Write widget test');
      var saveButton = find.byType(TextButton);
      await tester.tap(saveButton);
      await tester.pump();
      // expect(listTask.listTask.length, 15);
    });
    testWidgets('When enter title = "" and description and tap save',
        (WidgetTester tester) async {
      await tester.pumpWidget(createNewTaskScreen());
      var descriptionTextField = find.byKey(const Key('description'));
      // await tester.enterText(titleTextField, 'Do something');
      // await tester.pump();
      await tester.enterText(descriptionTextField, 'Write widget test');
      var saveButton = find.byType(TextButton);
      await tester.tap(saveButton);
      await tester.pump();
      expect(find.text('Please enter some text'), findsOneWidget);
    });
  });
}
