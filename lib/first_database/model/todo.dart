class Todo {
  int? id;

  //description is the text we see on main screen card text
  String description;

  //isDone used to mark what To_do item is completed
  bool isDone = false;

  Todo({this.id, required this.description, this.isDone = false});

  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
        //convert JSON objects to todo objects
        id: data['id'],
        description: data['description'],
        //0 - false, 1 - true
        isDone: data['is_done'] == 0 ? false : true,
      );

  Map<String, dynamic> toDatabaseJson() => {
        //convert To_do objects in a form of JSON
        "id": id,
        "description": description,
        "is_done": isDone == false ? 0 : 1,
      };
}
