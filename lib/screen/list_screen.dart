import 'package:flutter/material.dart';
import 'package:todolist/config/palette.dart';
import 'package:todolist/data/todo.dart';
import 'package:todolist/db/firebase.dart';

final _formKey = GlobalKey<FormState>();

final Map<int, FocusNode> _focusNodes = {};
final Map<int, TextEditingController> _controllers = {};
final Map<int, GlobalKey<FormState>> _keys = {};

void addThings(Todo todo) {
  _focusNodes[todo.id] = FocusNode();
  _controllers[todo.id] = TextEditingController(text: todo.work);
  _keys[todo.id] = GlobalKey<FormState>();
}

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  TextEditingController addController = TextEditingController();
  String inputTodo = '';
  int editMode = -1;

  Future<void> _addTodo(Todo todo) async {
    addThings(todo);
    await createTodoFB(todo);
  }

  Future<void> _editTodo(Todo todo) async {
    await updateTodoFB(todo);
  }

  Future<void> _delTodo(Todo todo) async {
    await deleteTodoFB(todo);
  }

  Future<void> _toggleTodo(Todo todo) async {
    await toggleTodoFB(todo);
  }

  bool _tryValidation(GlobalKey<FormState> key) {
    final isValid = key.currentState!.validate();
    isValid ? key.currentState!.save() : null;
    return isValid;
  }

  @override
  void dispose() {
    super.dispose();
    for (FocusNode focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Palette.themeColor1,
              Palette.themeColor2,
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 200.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: addController,
                    autofocus: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter something';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      prefixIcon: TextButton(
                        onPressed: () async {
                          if (_tryValidation(_formKey)) {
                            await _addTodo(
                              Todo(
                                id: todos.isEmpty ? 0 : todos.last.id + 1,
                                work: addController.text,
                              )
                            );
                            addController.clear();
                          }
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.add,
                          color: Palette.textColor1,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.deactiveColor,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.textColor1,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'Todo',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Palette.deactiveColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FixedColumnWidth(50.0),// fixed to 100 width
                      1: FlexColumnWidth(),
                      2: FixedColumnWidth(50.0),//fixed to 100 width
                    },
                    children: [
                      for (Todo todo in todos)
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: TextButton(
                              onPressed: () async {
                                if (editMode == todo.id) {
                                  if (_tryValidation(_keys[todo.id]!)) {
                                    await _editTodo(
                                      Todo(
                                        id: todo.id,
                                        work: _controllers[todo.id]!.text,
                                      ),
                                    );
                                    FocusScope.of(context).unfocus();
                                    editMode = -1;
                                  }
                                }
                                else {
                                  await _toggleTodo(todo);
                                }
                                setState(() {});
                              },
                              child: Icon(
                                editMode == todo.id ? Icons.edit : Icons.check,
                                color: editMode == todo.id ? Palette.themeColor1 : (
                                    todo.isDone ? Palette.themeColor1 : Palette.deactiveColor
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Form(
                              key: _keys[todo.id],
                              child: TextFormField(
                                controller: _controllers[todo.id],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter something';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    editMode = todo.id;
                                  });
                                },
                                focusNode: _focusNodes[todo.id],
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: TextButton(
                              onPressed: () async {
                                await _delTodo(
                                  Todo(
                                    id: todo.id,
                                    work: todo.work,
                                  ),
                                );
                                setState(() {});
                              },
                              child: const Icon(Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
