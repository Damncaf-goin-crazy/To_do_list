import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase {
  late final Future<Database> database;

  TodoDatabase() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'todo_database.db');

    database = openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Todos (id INTEGER PRIMARY KEY AUTOINCREMENT, todo TEXT, isDone INTEGER, day INTEGER, month INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertToDo(Todo toDo) async {
    final Database db = await database;

    await db.insert(
      'Todos',
      toDo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> getTodos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Todos');

    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        toDo: maps[i]['todo'],
        isDone: maps[i]['isDone'],
        day: maps[i]['day'],
        month: maps[i]['month'],
      );
    });
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      'Todos',
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodoById(int id) async {
    final db = await database;
    await db.delete(
      'Todos',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

class Todo {
  final int? id;  // Use nullable int for auto-incrementing ID
  String toDo;
  int isDone;
  int day;
  int month;

  Todo({
    this.id,
    required this.toDo,
    this.isDone = 0,
    required this.day,
    required this.month,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': toDo,
      'isDone': isDone,
      'day': day,
      'month': month,
    };
  }

  @override
  String toString() {
    return '{id: $id, todo: $toDo, isDone: $isDone, day: $day, month: $month}';
  }
}
