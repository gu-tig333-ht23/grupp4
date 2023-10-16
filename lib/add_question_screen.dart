import 'package:flutter/material.dart';
import 'question_model.dart';
import 'question_list_screen.dart';


class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _question = '';
  List<String> _answers = ['', '', '', ''];
  int? _correctAnswerIndex;
  List<bool> _isAnswerSelected = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionList(),
                ),
              );
            },
            )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Text(
              'Enter your question and provide four possible answers. Mark the correct answer.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              onChanged: (value) => _question = value,
              decoration: InputDecoration(
                labelText: 'Question',
                hintText: 'Enter your question here',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              maxLines: 3,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ..._answers.asMap().entries.map((entry) {
              int index = entry.key;
              return ListTile(
                title: TextFormField(
                  onChanged: (value) => _answers[index] = value,
                  decoration: InputDecoration(
                    labelText: 'Answer ${index + 1}',
                  ),
                ),
                leading: Checkbox(
                  value: _isAnswerSelected[index],
                  onChanged: (value) {
                    setState(() {
                      for (int i = 0; i < _isAnswerSelected.length; i++) {
                        _isAnswerSelected[i] = false;
                      }
                      _isAnswerSelected[index] = value!;
                      _correctAnswerIndex = value ? index : null;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 60.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment(0, 0.5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20.0),
                    primary: Colors.green,
                  ),
                  child: Text('Save'),
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _correctAnswerIndex != null) {
                      final newQuestion = Question(
                        question: _question,
                        answers: _answers,
                        correctAnswerIndex: _correctAnswerIndex!,
                      );

                      // Save question to in-memory storage
                      QuestionStorage.addQuestion(newQuestion);

                      // Clear the form
                      _question = '';
                      _answers = ['', '', '', ''];
                      _isAnswerSelected = [false, false, false, false];
                      _correctAnswerIndex = null;
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





