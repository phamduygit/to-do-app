import 'package:test/test.dart';
import 'package:to_do_app/models/list_task.dart';
import 'package:to_do_app/models/task.dart';

void main() {
  group('Testing App Provider', () {
    var tasks = ListTask();
    test('Add new task to list', () {
      tasks.listTask.clear();
      var task = Task(
        id: "1",
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.add(task);
      expect(tasks.listTask.contains(task), true);
    });
    test('Add new task to list without title', () {
      tasks.listTask.clear();
      var task = Task(
        id: "1",
        title: "",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.add(task);
      expect(tasks.listTask.isEmpty, true);
    });
    test('Add two task same id', () {
      tasks.listTask.clear();
      var task = Task(
        id: "1",
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.add(task);
      tasks.add(task);
      expect(tasks.listTask.length == 1, true);
    });
    test('Delete task from list', () {
      tasks.listTask.clear();
      var task = Task(
        id: "1",
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.add(task);
      expect(tasks.listTask.contains(task), true);
      tasks.remove(task);
      expect(tasks.listTask.contains(task), false);
    });
    test('Delete task by not existed id', () {
      tasks.listTask.clear();
      var task = Task(
        id: "1",
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.add(task);
      expect(tasks.listTask.contains(task), true);
      var task2 = Task(
        id: "2",
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.remove(task2);
      expect(tasks.listTask.length == 1, true);
    });
    test('Update task from list', () {
      tasks.listTask.clear();
      var task = Task(
        id: "1",
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.add(task);
      expect(tasks.listTask.contains(task), true);
      task.description = "Learn Flutter";
      task.status = 1;
      tasks.update(task);
      int index = tasks.listTask.indexOf(task);
      expect("Learn Flutter" == tasks.listTask[index].description, true);
    });
    test('Update task from list without title', () {
      tasks.listTask.clear();
      var task = Task(
        id: "1",
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.add(task);
      expect(tasks.listTask.contains(task), true);
      task = Task(
        id: "1",
        title: "",
        description: "Learn flutter",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.update(task);
      int index = tasks.listTask.indexWhere((element) => element.id == task.id); 
      expect("Learn English" == tasks.listTask[index].description, true);
    });
    test('Update task from list by not not existed id', () {
      tasks.listTask.clear();
      var task = Task(
        id: "1",
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.add(task);
      expect(tasks.listTask.contains(task), true);
      task = Task(
        id: "2",
        title: "",
        description: "Learn flutter",
        completeDate: DateTime.now(),
        status: 0,
      );
      tasks.update(task);
      int index = tasks.listTask.indexWhere((element) => element.id == "1"); 
      expect("Learn English" == tasks.listTask[index].description, true);
    });
  });
}
