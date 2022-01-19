class Todo {
  int id = 0;
  String work = '';
  bool isDone = false;

  Todo({this.id = 0, this.work = '', this.isDone = false});

  Todo.fromJson(Map json) {
    id = json['id'];
    work = json['work'];
    isDone = json['isDone'];
  }
}

List<Todo> todos = [];