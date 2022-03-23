import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoModel> arrTodoModel = [];
  int totalTodo = 0;
  int totalCompletedTodo = 0;
  int taskID = 0;
  int editTaskIndex = 0;

  clearTodoData() {
    arrTodoModel.clear();
    totalTodo = 0;
    totalCompletedTodo = 0;
    editTaskIndex = 0;
    taskID = 0;
    notifyListeners();
  }

  void getTaskIndex(int index) {
    editTaskIndex = index;
    notifyListeners();
  }

  void addTodoTask(String task, bool istodo, bool iscompleted) {
    arrTodoModel.add(TodoModel(
        id: taskID++, title: task, isTodo: istodo, isCompleted: iscompleted));
    totalTodo++;
    notifyListeners();
  }

  void editTodoTask(int id, String task, bool istodo, bool isCompleted) {
    for (var arrData in arrTodoModel) {
      if (editTaskIndex == arrData.id) {
        arrTodoModel[editTaskIndex].id = id;
        arrTodoModel[editTaskIndex].title = task;
        arrTodoModel[editTaskIndex].isTodo = istodo;
        arrTodoModel[editTaskIndex].isCompleted = isCompleted;
        notifyListeners();
      }
    }
  }

  void updateTodoTask(bool val, int index) {
    arrTodoModel[index].isTodo = val;
    arrTodoModel[index].isCompleted = true;
    totalTodo--;
    totalCompletedTodo++;
    notifyListeners();
  }

  void updateIsCompletedTodo(bool val, int index) {
    arrTodoModel[index].isTodo = val;
    arrTodoModel[index].isCompleted = false;
    totalTodo++;
    totalCompletedTodo--;
    notifyListeners();
  }
}

class TodoModel {
  late int id;
  late String title;
  late bool isTodo;
  late bool isCompleted;

  TodoModel(
      {required this.id,
      required this.title,
      required this.isTodo,
      required this.isCompleted});
}
