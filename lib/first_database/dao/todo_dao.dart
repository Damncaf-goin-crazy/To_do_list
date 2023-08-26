import 'dart:async';
import 'package:todo_list/first_database/database/database.dart';
import 'package:todo_list/first_database/model/todo.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new To_do records
  Future<int> createTodo(Todo todo) async {
    //Get a reference to the database.
    final db = await dbProvider.database;
    //Insert into the correct table
    var result = db.insert(todoTABLE, todo.toDatabaseJson());
    return result;
  }

  //Get All To_do items
  //Searches if query string was passed
  Future<List<Todo>> getTodos({List<String>? columns,String? query}) async {
    //Get a reference to the database.
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];


    //I USED query = STRING 'null'
    if (query != null) {
      if (query.isNotEmpty) {
        //query the table
        result = await db.query(todoTABLE,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
      }
    } else {
      result = await db.query(todoTABLE, columns: columns);
    }

    List<Todo> todos = result.isNotEmpty
        ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
        : [];
    return todos;
  }

  //Update To_do record
  Future<int> updateTodo(Todo todo) async {
    //Get a reference to the database.
    final db = await dbProvider.database;
    //update the given to_do, ensuring that the id is matching and pass the
    //to_do id as a whereArg to prevent SQL injection.
    var result = await db.update(todoTABLE, todo.toDatabaseJson(),
        where: "id = ?", whereArgs: [todo.id]);

    return result;
  }

  //Delete To_do records
  Future<int> deleteTodo(int id) async {
    //Get a reference to the database.
    final db = await dbProvider.database;
    //remove to_do from the database, passing the id
    var result = await db.delete(todoTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

}