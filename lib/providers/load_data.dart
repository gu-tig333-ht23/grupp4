import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizme/models/quiz_model.dart';

class FirebaseProvider {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> editQuizInFireSTore(Quiz quiz) async {
    try {
      // Convert the quiz object to a map
      Map<String, dynamic> quizData = {
        'title': quiz.title,
        'description': quiz.quizDescription,
        'questions': quiz.questions.map((question) {
          return {
            'title': question.title,
            'answers': question.answers.map((answer) {
              return {
                'text': answer.text,
                'isCorrect': answer.isCorrect,
              };
            }).toList(),
          };
        }).toList(),
      };
      print("Här är quizdata from edit:");
      print(quizData);
      // Add the quiz data to Firestore
      await _firestore.collection('quizzes').doc(quiz.title).set(quizData);
    } catch (error) {
      print('Error saving quiz to Firestore: $error');
    }
  }

  static Future<void> saveQuizToFirestore(Quiz quiz) async {
    try {
      // Convert the quiz object to a map
      Map<String, dynamic> quizData = {
        'title': quiz.title,
        'description': quiz.quizDescription,
        'questions': quiz.questions.map((question) {
          return {
            'title': question.title,
            'answers': question.answers.map((answer) {
              return {
                'text': answer.text,
                'isCorrect': answer.isCorrect,
              };
            }).toList(),
          };
        }).toList(),
      };
      print("Här är quizdata:");
      print(quizData);
      // Add the quiz data to Firestore
      await _firestore.collection('quizzes').add(quizData);
    } catch (error) {
      print('Error saving quiz to Firestore: $error');
    }
  }

  static Future<List<Quiz>> getQuizzesFromFirestore() async {
    List<Quiz> quizzes = [];

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('quizzes').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        // Convert data from Firestore back to Quiz object
        String title = data['title'] ?? '';
        String description = data['description'] ?? '';
        List<Question> questions = [];

        if (data['questions'] != null) {
          print("ADDING QUESTION");
          for (var questionData in data['questions']) {
            String questionTitle = questionData['title'] ?? '';
            //List<Answer> answers = [];
            Question question = Question(questionTitle);
            if (questionData['answers'] != null) {
              for (var answerData in questionData['answers']) {
                String answerText = answerData['text'] ?? '';
                bool isCorrect = answerData['isCorrect'] ?? false;
                question.addAnswer(answerText, isCorrect);
              }
            }

            questions.add(question);
          }
        }

        Quiz quiz = Quiz(title);
        quiz.questions = questions;
        print("Amount of questions: ${quiz.questions}");
        quizzes.add(quiz);
      }
    } catch (error) {
      print('Error getting quizzes from Firestore: $error');
    }

    return quizzes;
  }
}
