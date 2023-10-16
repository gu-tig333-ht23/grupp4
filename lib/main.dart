import 'package:flutter/material.dart';
import 'add_question_screen.dart';  // Make sure to import the AddQuestionScreen file

void main() => runApp(QuestionApp());

class QuestionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Question App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AddQuestionScreen(),  // Updated this line
    );
  }
}
