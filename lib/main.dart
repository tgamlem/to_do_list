// Tyler Gamlem
// Flutter Exam
// Last Modified: 04/26/2020

// This app is a basic To Do List that allows the user to add as many 
// tasks as needed. Tasks can be reordered, checked off, and deleted

import 'package:flutter/material.dart';
import 'todolist.dart';

void main() {
  runApp(MaterialApp(
    title: "To Do List", 
    // set color scheme for app
    theme: ThemeData(
      primaryColor: Colors.amber[400],
      accentColor: Colors.cyan[600],
    ),
    home: ToDoList()
    )
  );
}
