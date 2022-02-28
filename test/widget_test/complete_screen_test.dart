import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/complete_screen.dart';


Widget createCompleteScreen() {
  ListTask listTask = ListTask();
  for (var i = 1; i < 30; i++) {
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
      home: CompleteScreen(),
    ),
  );
}

void main() {
  group('Complete screen Widget Test', () {
    testWidgets('Testing if ListView shows up', (tester) async {
      await tester.pumpWidget(createCompleteScreen());
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsNothing);
    });
    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(createCompleteScreen());
      expect(find.text('Task 1'), findsOneWidget);
      await tester.fling(find.byType(ListView), const Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Task 1'), findsNothing);
    });
    testWidgets("Change status complete and of task widget on all screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(createCompleteScreen());
      expect(find.text('Task 1'), findsOneWidget);
      final checkbox = find.byKey(const Key("checkbox 1"));
      await tester.tap(checkbox);
      await tester.pump();
      expect(find.text('Task 1'), findsNothing);
    });
  });
}