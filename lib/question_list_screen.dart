import 'package:flutter/material.dart';
import 'question_model.dart';

class QuestionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questions = QuestionStorage.getQuestions();

    return Scaffold(
      appBar: AppBar(
        title: Text('Questions List'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return ListTile(
            title: Text(question.question),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: question.answers.asMap().entries.map((entry) {
                int idx = entry.key;
                String answer = entry.value;
                return Row(
                  children: [
                    Expanded(child: Text(answer)),
                    if (question.correctAnswerIndex == idx)
                      Icon(Icons.check, color: Colors.green),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
