import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';


Widget createMainScreen() {
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
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    // testWidgets('Scrolling test', (tester) async {
    //   await tester.pumpWidget(createMainScreen());

    //   final listFinder = find.byType(ListView);
    //   await binding.watchPerformance(() async {
    //     await tester.fling(listFinder, const Offset(0, -200), 3000);
    //     await tester.pumpAndSettle();

    //     await tester.fling(listFinder, const Offset(0, -200), 3000);
    //     await tester.pumpAndSettle();
    //   }, reportKey: 'scrolling_summary');
    // });
  });
}
