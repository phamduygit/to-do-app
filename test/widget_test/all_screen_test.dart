import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';

Widget createAllScreen() {
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
      home: MainScreen(),
    ),
  );
}

void main() {
  group('All Screen Widget Tests', () {
    testWidgets('When tap floating button show bottom modal sheet',
        (WidgetTester tester) async {
      ListTask tasks = ListTask();
      tasks.setItems([]);
      await tester.pumpWidget(createAllScreen());
      expect(find.byKey(const Key('bottomModelSheet')), findsNothing);
      final button = find.byIcon(Icons.add);
      await tester.tap(button);
      await tester.pump();
      expect(find.byKey(const Key('bottomModelSheet')), findsOneWidget);
    });
    testWidgets('Testing if ListView shows up', (tester) async {
      await tester.pumpWidget(createAllScreen());
      expect(find.byType(ListView), findsOneWidget);
    });
    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(createAllScreen());
      expect(find.text('Task 1'), findsOneWidget);
      await tester.fling(find.byType(ListView), const Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Task 1'), findsNothing);
    });
    testWidgets('Show list task widget complete and incomplete',
        (WidgetTester tester) async {
      await tester.pumpWidget(createAllScreen());
      expect(find.text("Task 1"), findsOneWidget);
      expect(find.text("Task 2"), findsOneWidget);
    });
    testWidgets("Change status complete and of task widget on all screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(createAllScreen());
      final checkbox = find.byKey(const Key("checkbox 1"));
      await tester.tap(checkbox);
      await tester.pump();
      var icon = find.ancestor(
          of: find.byIcon(Icons.square_outlined), matching: checkbox);
      expect(icon, findsOneWidget);
      await tester.tap(checkbox);
      await tester.pump();
      icon =
          find.ancestor(of: find.byIcon(Icons.check_box), matching: checkbox);
      expect(icon, findsOneWidget);
    });
    // testWidgets('When tap floating button and add new task',
    //     (WidgetTester tester) async {
    //   ListTask tasks = ListTask();
    //   tasks.setItems([]);
    //   await tester.pumpWidget(createAllScreen());
    //   final button = find.byType(FloatingActionButton);
    //   await tester.tap(button);
    //   await tester.pump();
    //   expect(find.byKey(const Key('bottomModelSheet')), findsOneWidget);
    //   var titleTextField = find.byKey(const Key('title'));
    //   var descriptionTextField = find.byKey(const Key('description'));
    //   await tester.enterText(titleTextField, 'Do something');
    //   await tester.enterText(descriptionTextField, 'Write widget test');
    //   var saveButton = find.byKey(const Key('saveButton'));
    //   // expect(saveButton, findsOneWidget);
    //   await tester.tap(saveButton);
    //   await tester.pump();
    //   await tester.fling(find.byType(ListView), const Offset(0, -200), 3000);
    //   expect(find.text('Do something'), true);
    //   expect(find.text('Write widget test'), true);
    // });
  });
}
