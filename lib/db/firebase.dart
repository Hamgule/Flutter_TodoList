import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/data/todo.dart';
import 'package:todolist/screen/list_screen.dart';

final coll = FirebaseFirestore
    .instance.collection('todolist');

String getDocId(todo) => todo.id.toString().padLeft(5, '0');

Future<void> createTodoFB(Todo todo) async {
  coll.doc(getDocId(todo)).set({
    'id': todo.id,
    'work': todo.work,
    'isDone': todo.isDone,
  });

  __logState('create', todo);
  await readAllTodoFB();
}

Future<void> readAllTodoFB() async {
  QuerySnapshot querySnapshot = await coll.get();
  final data = querySnapshot.docs.map((doc) => doc.data()).toList();

  todos = [];

  for (var datum in data) {
    todos.add(Todo.fromJson(datum));
    addThings(
      Todo(
        id: todos.last.id,
        work: todos.last.work,
      ),
    );
  }
}

Future<void> updateTodoFB(Todo todo) async {
  coll.doc(getDocId(todo)).update({
    'id': todo.id,
    'work': todo.work,
    'isDone': todo.isDone,
  });

  __logState('update', todo);
  await readAllTodoFB();
}

Future<void> deleteTodoFB(Todo todo) async {
  coll.doc(getDocId(todo)).delete();

  __logState('delete', todo);
  await readAllTodoFB();
}

Future<void> toggleTodoFB(Todo todo) async {
  coll.doc(getDocId(todo)).update({
    'isDone': !todo.isDone,
  });

  __logState('toggle', todo);
  await readAllTodoFB();
}

void __logState(String cud, Todo todo) {
  bool isUpdate = cud == 'update';
  String id = '${todo.id}';
  String befWork = isUpdate ? todos[todo.id].work : todo.work;
  String aftWork = isUpdate ? "to '${todo.work}'" : '';

  String msg = "id #$id '$befWork' ${cud}d $aftWork";

  print(msg);
}