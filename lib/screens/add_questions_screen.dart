import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../widgets/reuseable_widgets.dart';

class AddQuestionScreen extends StatefulWidget {
  final Quiz quiz;
  const AddQuestionScreen({super.key, required this.quiz});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  int? _correctAnswerIndex;
  List<bool> _isAnswerSelected = [false, false, false, false];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  // have to manually dispose of the controller when widget is disposed.
  @override
  void dispose() {
    _questionController.dispose();
    for (TextEditingController controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const QuizmeAppBar(title: "Add Question"),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            loadQuestionFormField(),
            const SizedBox(height: 20.0),
            loadAnswerFormFields(),
            const SizedBox(height: 20.0),
            saveButton(context),
          ],
        ),
      ),
    );
  }

  Wrap loadQuestionFormField() {
    return Wrap(
      children: [
        // Description
        const Text(
          'Enter your question and provide four possible answers. Mark the correct answer.',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20.0),
        // Question form field
        TextFormField(
          controller: _questionController,
          decoration: const InputDecoration(
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
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  Wrap loadAnswerFormFields() {
    return Wrap(
      children: [
        ..._answerControllers.asMap().entries.map((entry) {
          int index = entry.key;
          return ListTile(
            title: TextFormField(
              controller: _answerControllers[index],
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
      ],
    );
  }

  Container saveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: const Alignment(0, 0.5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20.0),
          ),
          child: const Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _correctAnswerIndex != null) {
              final newQuestion = Question(_questionController.text);

              for (int i = 0; i < _answerControllers.length; i++) {
                TextEditingController controller = _answerControllers[i];
                if (controller.text.isEmpty) {
                  continue;
                }
                newQuestion.addAnswer(
                    _answerControllers[i].text, _isAnswerSelected[i]);
              }

              widget.quiz.questions.add(newQuestion);

              // Clear the form
              for (TextEditingController controller in _answerControllers) {
                controller.clear();
              }
              _questionController.clear();
              _isAnswerSelected = [false, false, false, false];
              _correctAnswerIndex = null;
              if (context.mounted) Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}
