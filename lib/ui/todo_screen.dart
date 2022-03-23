import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({
    Key? key,
  }) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late TodoProvider todoProviderRead;
  late TodoProvider todoProviderWatch;
  TextEditingController textCtr = TextEditingController();
  FocusNode inputNode = FocusNode();

  bool isEdit = false;

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      todoProviderRead.clearTodoData();
      todoProviderRead = context.read<TodoProvider>();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    todoProviderWatch = context.watch<TodoProvider>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
        title: const Text(
          "Todo App",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 13, bottom: 13),
          child: Column(
            children: [
              _buildAddItem(context),
              _buildTodo(context),
              _buildCompleted(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          todoHeader(context, "Add Task"),
          todoDivider(context),
          addTodoTask(context),
        ],
      ),
    );
  }

  Widget addTodoTask(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        addTaskField(),
        addTaskButton(),
      ],
    );
  }

  Expanded addTaskButton() {
    return Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            if (!isEdit) {
              FocusScope.of(context).requestFocus(FocusNode());
              if (textCtr.text.isNotEmpty) {
                todoProviderWatch.addTodoTask(
                    textCtr.text.toString(), true, false);
                textCtr.clear();
              }
            } else {
              FocusScope.of(context).requestFocus(FocusNode());
              if (textCtr.text.isNotEmpty) {
                todoProviderWatch.editTodoTask(
                    todoProviderWatch
                        .arrTodoModel[todoProviderWatch.editTaskIndex].id,
                    textCtr.text.toString(),
                    true,
                    false);
                textCtr.clear();
                isEdit = false;
              }
              Future.delayed(const Duration(seconds: 1), () {
                EasyLoading.showSuccess('Task\nUpdated');
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.only(left: 30, right: 10),
            child: Text(
              isEdit ? "Edit" : "Add",
              style: TextStyle(
                  color: isEdit ? Colors.redAccent : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }

  Expanded addTaskField() {
    return Expanded(
      flex: 4,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: textCtr,
          focusNode: inputNode,
          autofocus: true,
          cursorColor: Colors.black,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Enter Tasks',
            hintStyle: const TextStyle(color: Colors.black, fontSize: 15),
            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              todoHeader(context, "Todo"),
              const Spacer(),
              totalCount(context, todoProviderWatch.totalTodo),
            ],
          ),
          todoDivider(context),
          todoList(context),
        ],
      ),
    );
  }

  Widget totalCount(BuildContext context, int count) {
    return count > 0
        ? Text(
            count.toString(),
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          )
        : const SizedBox.shrink();
  }

  Widget todoHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
    );
  }

  Widget todoList(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: todoProviderWatch.arrTodoModel.length,
        itemBuilder: (BuildContext context, int index) {
          return todoProviderWatch.arrTodoModel[index].isTodo
              ? InkWell(
                  onTap: () {
                    Future.delayed(const Duration(seconds: 1), () {
                      todoProviderWatch.updateTodoTask(false, index);
                    });
                    EasyLoading.showSuccess('Task\nCompleted');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 7, right: 7, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.black)),
                          margin: const EdgeInsets.only(right: 20),
                          child: Icon(Icons.check,
                              size: 13,
                              color:
                                  todoProviderWatch.arrTodoModel[index].isTodo
                                      ? Colors.transparent
                                      : Colors.black),
                        ),
                        Text(
                          todoProviderWatch.arrTodoModel[index].title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(inputNode);
                            textCtr.text =
                                todoProviderWatch.arrTodoModel[index].title;
                            todoProviderWatch.getTaskIndex(index);
                            isEdit = true;
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container();
        });
  }

  Widget _buildCompleted(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              todoHeader(context, "Completed"),
              const Spacer(),
              totalCount(context, todoProviderWatch.totalCompletedTodo),
            ],
          ),
          todoDivider(context),
          completedTodoList(context),
        ],
      ),
    );
  }

  Widget completedTodoList(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: todoProviderWatch.arrTodoModel.length,
        itemBuilder: (BuildContext context, int index) {
          return todoProviderWatch.arrTodoModel[index].isCompleted
              ? InkWell(
                  onTap: () {
                    Future.delayed(const Duration(seconds: 1), () {
                      todoProviderWatch.updateIsCompletedTodo(true, index);
                    });
                    EasyLoading.showSuccess('Mark\nUncompleted');
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 7, right: 7, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.black)),
                          margin: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.check,
                              size: 13, color: Colors.black),
                        ),
                        Text(
                          todoProviderWatch.arrTodoModel[index].title,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink();
        });
  }

  Container todoDivider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3, bottom: 15),
      child: const Divider(
        thickness: 1.0,
        color: Colors.white,
      ),
    );
  }
}
