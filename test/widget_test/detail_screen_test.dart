import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/widgets/detail_task.dart';

Widget createDetailScreen() {
  ListTask listTask = ListTask();
  Task task = Task(
    id: "1234",
    title: "Task abc",
    description: "Do homework",
    completeDate: DateTime.now(),
    status: 0,
  );
  listTask.add(task);
  return ChangeNotifierProvider<ListTask>(
    create: (context) => listTask,
    child: MaterialApp(
      home: DetailTask(
        task: task,
      ),
    ),
  );
}

void main() {
  group('Detail screen Widget Test', () {
    testWidgets('Testing if detail screen shows up',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDetailScreen());
      expect(find.text('Task abc'), findsOneWidget);
      expect(find.text('Do homework'), findsOneWidget);
    });
    testWidgets('When press change title, description and press save',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDetailScreen());
      var titleField = find.byKey(const Key('titleField'));
      var descriptionField = find.byKey(const Key('descriptionField'));
      await tester.enterText(titleField, 'Hello world');
      await tester.enterText(descriptionField, 'Hi');
      var saveButton = find.text('Save');
      await tester.tap(saveButton);
      await tester.pump();
      expect(find.text('Update successful'), findsOneWidget);
    });
    testWidgets('When change title = null , description and press save',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDetailScreen());
      var titleField = find.byKey(const Key('titleField'));
      var descriptionField = find.byKey(const Key('descriptionField'));
      await tester.enterText(titleField, '');
      await tester.enterText(descriptionField, 'Hi');
      var saveButton = find.text('Save');
      await tester.tap(saveButton);
      await tester.pump();
      expect(find.text('Please enter some text'), findsOneWidget);
      expect(find.text('Update successful'), findsNothing);
    });
    testWidgets('When press delete task', (WidgetTester tester) async {
      await tester.pumpWidget(createDetailScreen());
      var deleteButton = find.text('Delete');
      await tester.tap(deleteButton);
      await tester.pump();
      expect(find.text('Delete task'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
    testWidgets('When press complte or incomplete',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDetailScreen());
      var incompleteButton = find.byType(IconButton);
      expect(incompleteButton, findsOneWidget);
      await tester.tap(incompleteButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
