import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Objects included in the To Do List
// Created datatype that holds the string value of the task and
// a bool flag to show whether or not the task is completed
class ToDoObject {
  String task;
  bool done;
  ToDoObject(this.task, this.done);
}

// Strikes through tasks after they are checked off as completed
class Strike extends StatelessWidget {
  final String task;
  final bool done;
  Strike(this.task, this.done);

  Widget strikethrough() {
    if (done) {
      return Text(
        task,
        // update style to show task is done
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
          fontStyle: FontStyle.italic,
          fontSize: 22,
          color: Colors.red[200],
        ),
      );
    } else {
      return Text(
        task,
        // update style to show task has not been completed
        style: TextStyle(fontSize: 22),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return strikethrough();
  }
}

class ToDoList extends StatefulWidget {

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // text controller to enter in a task
  TextEditingController textController = TextEditingController();
  // list of objects in the to do list
  List<ToDoObject> taskList = [];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List", style: GoogleFonts.barlow(fontSize: 28)),
      ),
      // plus button at bottom of screen
      // used to add a task to the list
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // show a dialog box to enter new task
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Create New Task", style: GoogleFonts.barlow()),
                    content: TextField(
                      // hint text to show what to enter
                      decoration: InputDecoration(hintText: "Enter Task"),
                      style: GoogleFonts.barlow(fontSize: 22),
                      controller: textController,
                      cursorWidth: 5,
                      autocorrect: true,
                      autofocus: true,
                    ),
                    actions: <Widget>[
                      // button to create a task
                      new FlatButton(
                        child: new Text("Create"),
                        onPressed: () {
                          // add a new object to the list, default it as uncomplete
                          taskList.add(new ToDoObject(textController.text, false));
                          setState(() {
                            // clear textController so it is empty for the next entry
                            textController.clear();
                          });
                          // pop the text entry box from the screen
                          Navigator.of(context).pop();
                        },
                      ),
                      // button to cancel the task
                      new FlatButton(
                        child: new Text("Cancel"),
                        onPressed: () {
                          setState(() {
                            // clear textController so it is empty for the next entry
                            textController.clear();
                          });
                          // pop the text entry box from the screen
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          }),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              // reorderable so that the order of tasks can be changed
              child: ReorderableListView(
            children: <Widget>[
              // print objects as long as there are objects to print
              for (final widget in taskList)
                GestureDetector(
                    key: Key(widget.task),
                    // dismissible to allow user to slide a task to the side and delete it
                    child: Dismissible(
                      key: Key(widget.task),
                      child: CheckboxListTile(
                        value: widget.done,
                        // call strike to tell if the widget should be struck through or not
                        title: Strike(widget.task, widget.done),
                        // set checkbox to lead text
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (checkValue) {
                          // chenge boolean flag 
                          setState(() {
                            if (!checkValue) {
                              widget.done = false;
                            } else {
                              widget.done = true;
                            }
                          });
                        },
                      ),
                      // background behing the tasks
                      // revealed when a task is moved to be dismissed
                      background: Container(
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerLeft,
                        color: Colors.red[700],
                      ),
                      confirmDismiss: (dismissDirection) {
                        // show dialog box to confirm dismissal
                        return showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete task?",
                                    style: GoogleFonts.openSans()),
                                actions: <Widget>[
                                  // button to confirm delete
                                  FlatButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  // button to cancel deleting
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      direction: DismissDirection.startToEnd,
                      movementDuration: const Duration(milliseconds: 200),
                      // remove task when dismissed
                      onDismissed: (dismissDirection) {
                        taskList.remove(widget);
                      },
                    ))
            ],
            onReorder: (oldIndex, newIndex) {
              // logic to reorder tasks based on where a task is moved
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                var replaceWidget = taskList.removeAt(oldIndex);
                taskList.insert(newIndex, replaceWidget);
              });
            },
          )),
        ],
      ),
    );
  }
}
