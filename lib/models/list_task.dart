import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';

class ListTask extends ChangeNotifier{
  final List<Task> listTask = [];

  void add(Task task) {
    if (task.title == "") {
      return;
    }
    int index = -1;
    index = listTask.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      return;
    }
    listTask.add(task);
    notifyListeners();
  }
  void update(Task task) {
    if (task.title == "") {
      return;
    }
    int index = -1;
    index = listTask.indexWhere((element) => element.id == task.id);
    if (index == -1) {
      return;
    }
    listTask[index] = task;
    notifyListeners();
  }
  void remove(Task task) {
    int index = -1;
    index = listTask.indexWhere((element) => element.id == task.id);
    if (index == -1) {
      return;
    }
    listTask.removeAt(index);
    notifyListeners();
  }
  void setItems(List<Task> items) {
    listTask.clear();
    listTask.addAll(items);
    notifyListeners();
  }
}