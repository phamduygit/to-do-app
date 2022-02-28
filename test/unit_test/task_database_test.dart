import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:to_do_app/data/task_database.dart';
import 'package:to_do_app/models/task.dart';
import 'package:uuid/uuid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('Testing App for local database', () {
    setUpAll(() {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;
    });
    var listTaskDB = ListTaskDAO();
    test('Insert task to tasks table', () async {
      listTaskDB.clearAll();
      var task = Task(
        id: const Uuid().v1(),
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      await listTaskDB.insert(task);
      List<Task> listTask = await listTaskDB.getListTask();
      int index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index != -1, true);
    });
    test('Insert task to tasks table without title', () async {
      listTaskDB.clearAll();
      var task = Task(
        id: const Uuid().v1(),
        title: "",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      await listTaskDB.insert(task);
      List<Task> listTask = await listTaskDB.getListTask();
      int index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index != -1, false);
    });
    test('Insert two task same id', () async {
      await listTaskDB.clearAll();
      var task = Task(
        id: const Uuid().v1(),
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      await listTaskDB.insert(task);
      await listTaskDB.insert(task);
      List<Task> listTask = await listTaskDB.getListTask();
      int index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index != -1, true);
    });
    test('Delete task from tasks table', () async {
      listTaskDB.clearAll();
      var task = Task(
        id: const Uuid().v1(),
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      await listTaskDB.insert(task);
      List<Task> listTask = await listTaskDB.getListTask();
      int index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index != -1, true);
      await listTaskDB.delete(task.id);
      listTask = await listTaskDB.getListTask();
      expect(listTask.length, 0);
    });
    test('Delete task by not existed id', () async {
      listTaskDB.clearAll();
      var task = Task(
        id: const Uuid().v1(),
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      await listTaskDB.insert(task);
      List<Task> listTask = await listTaskDB.getListTask();
      int index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index != -1, true);
      await listTaskDB.delete("asdfasd");
      listTask = await listTaskDB.getListTask();
      expect(listTask.length, 1);
    });
    test('Update task from tasks table', () async {
      listTaskDB.clearAll();
      var task = Task(
        id: const Uuid().v1(),
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      await listTaskDB.insert(task);
      List<Task> listTask = await listTaskDB.getListTask();
      int index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index != -1, true);
      task.description = "Learn flutter";
      await listTaskDB.update(task);
      listTask = await listTaskDB.getListTask();
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(listTask[index].description == task.description, true);
    });
    test('Update task by not exists id', () async {
      listTaskDB.clearAll();

      //  create and add new task
      var task = Task(
        id: const Uuid().v1(),
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      await listTaskDB.insert(task);
      List<Task> listTask = await listTaskDB.getListTask();
      int index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index != -1, true);

      // update descriptio of task with id = 12341234
      task.description = "Learn flutter";
      task.id = "12341234";
      await listTaskDB.update(task);
      listTask = await listTaskDB.getListTask();
      index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index == -1, true);
    });
    test('Update task from the table without title', () async {
      listTaskDB.clearAll();
      
      //  create and add new task
      var task = Task(
        id: const Uuid().v1(),
        title: "Do something",
        description: "Learn English",
        completeDate: DateTime.now(),
        status: 0,
      );
      await listTaskDB.insert(task);
      List<Task> listTask = await listTaskDB.getListTask();
      int index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index != -1, true);

      // update descriptio of task with id = 12341234
      task.description = "";
      await listTaskDB.update(task);
      listTask = await listTaskDB.getListTask();
      index = -1;
      index = listTask.indexWhere((element) => element.id == task.id);
      expect(index == -1, false);
    });
  });
}
