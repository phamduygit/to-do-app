import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime completeDate;
  int status;
  Task({
    this.id = "",
    this.title = "",
    this.description = "",
    required this.completeDate,
    this.status = 0,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id == "" ? const Uuid().v1() : id,
      'title': title,
      'description': description,
      'completeDate': DateFormat('yyyy-MM-DD HH:mm:ss').format(completeDate),
      'status': status,
    };
  }
}
