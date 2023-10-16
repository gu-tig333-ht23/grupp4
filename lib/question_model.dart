class Question {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

class QuestionStorage {
  static final List<Question> _questions = [];

  static void addQuestion(Question question) {
    _questions.add(question);
  }

  static List<Question> getQuestions() {
    return _questions;
  }
}

