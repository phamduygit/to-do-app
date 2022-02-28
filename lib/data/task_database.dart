import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/models/task.dart';

class ListTaskDAO {
  Database? database;
  final databaseName = 'tasks.db';
  Future open(String databaseName) async {
    database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, completeDate TEXT, status integer)');
      },
    );
  }

  Future<bool> isNotExists(String id) async {
    await open(databaseName);
    final List<Map<String, dynamic>>? mapTasks =
        await database?.query('tasks', where: 'id = ?', whereArgs: [id]);
    await close();
    if (mapTasks!.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> insert(Task task) async {
    if (task.title == "") {
      return;
    }
    bool isNotExistsID = await isNotExists(task.id);
    await open(databaseName);
    if (isNotExistsID) {
      await database?.insert("tasks", task.toMap());
    }
    await close();
  }

  Future<void> delete(String id) async {
    bool isNotExistsID = await isNotExists(id);
    if (isNotExistsID) {
      return;
    }
    await open(databaseName);
    await database?.delete('tasks', where: 'id = ?', whereArgs: [id]);
    await close();
  }

  Future<void> update(Task task) async {
    if (task.title == "") {
      return;
    }
    
    bool isNotExistsID = await isNotExists(task.id);
    if (isNotExistsID) {
      return;
    }
    await open(databaseName);
    await database
        ?.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    // await close();
  }

  Future<List<Task>> getListTask() async {
    await open(databaseName);
    final List<Map<String, dynamic>>? mapTasks = await database?.query('tasks');
    await close();
    return List.generate(
      mapTasks!.length,
      (index) => Task(
        id: mapTasks[index]['id'],
        title: mapTasks[index]['title'],
        description: mapTasks[index]['description'],
        completeDate: DateFormat("yyyy-MM-DD HH:mm:ss")
            .parse(mapTasks[index]['completeDate']),
        status: mapTasks[index]['status'],
      ),
    );
  }

  Future<void> clearAll() async {
    await open(databaseName);
    await database?.execute("delete from tasks");
    await close();
  }

  Future close() async {
    database?.close();
  }
}
