import 'package:path_provider/path_provider.dart';
import 'package:smalltask/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db {
  static final Db instance = Db();

  static Database? _database;
  final String _tableName = "tasks";

  Future<Database?> get _openDb async {
    if (_database != null) return _database!;

    final path = await getApplicationDocumentsDirectory();

    final dataBasePath = join(path.path, "database", "smalltask.db");

    _database =
        await openDatabase(dataBasePath, version: 1, onCreate: _onCreate);

    return _database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, taskName TEXT NOT NULL, isDone BIT(1) NOT NULL)");
  }

  Future<List<Task>> readAll() async {
    List<Task> _data = [];
    final db = await instance._openDb;

    final data = await db!.query(_tableName);

    if (data.isEmpty) return _data;

    for (var i in data) {
      _data.add(
        Task(
          isDone: i['isDone'] == 1 ? true : false,
          taskName: "${i['taskName']}",
          id: int.parse(
            i['id'].toString(),
          ),
        ),
      );
    }

    return _data;
  }

  Future<int> addTask(String task) async {
    final db = await instance._openDb;
    final id = await db!.insert(_tableName, {
      "taskName": task,
      "isDone": 0,
    });

    return id.toInt();
  }

  Future deleteAll() async {
    final db = await instance._openDb;
    await db!.delete(_tableName);
  }

  Future<void> delete(int id) async {
    final db = await instance._openDb;

    await db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  Future toggleDone(bool value, int id) async {
    final db = await instance._openDb;
    db!.update(
        _tableName,
        {
          "isDone": value ? 1 : 0,
        },
        where: "id = ?",
        whereArgs: [id]);
  }

  Future update(String value, int id) async {
    final db = await instance._openDb;

    db!.update(
      _tableName,
      {
        "taskName": value,
      },
      where: "id=?",
      whereArgs: [id],
    );
  }
}
