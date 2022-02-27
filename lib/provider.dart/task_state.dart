import 'package:flutter/foundation.dart';
import 'package:smalltask/models.dart';

class TaskState with ChangeNotifier {
  List<Task> data = [];

  void setData(final d) async {
    data = d;

    notifyListeners();
  }

  void add(String task, int id) {
    data.add(Task(isDone: false, taskName: task, id: id));

    notifyListeners();
  }

  void update(int id, String value) {
    final d = data.singleWhere((element) => element.id == id);
    d.taskName = value;

    notifyListeners();
  }

  void toggleDone(int id) {
    final d = data.singleWhere((element) => element.id == id);

    d.isDone = !d.isDone;

    notifyListeners();
  }

  void delete(int id) {
    data.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  void deleteAll() {
    data.clear();

    notifyListeners();
  }

  int taskDone() {
    final d = data.where((element) => element.isDone == false);

    return d.length;
  }
}
