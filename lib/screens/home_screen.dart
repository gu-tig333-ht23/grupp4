import 'package:flutter/material.dart';
import 'package:quizme/screens/play_quiz_screen/play_quiz_screen.dart';
import 'package:quizme/widgets/reuseable_widgets.dart';
import 'make_quiz_screen.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_handler.dart';
import '../providers/play_quiz_provider.dart';
import '../models/quiz_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Home screen is a StatefulWidget that represents the main view of our application.
// It contains a list of quizzes created by the user.
class _HomeScreenState extends State<HomeScreen> {
  late List<Quiz> quizzes;
// inside the build method, it retrieves quizzes from
// a QuizHandler provider and uses it to display quizzes in the app.
  @override
  Widget build(BuildContext context) {
    context.watch<QuizHandler>().quizzes;
    final QuizHandler quizHandler = context.read<QuizHandler>();
    quizzes = quizHandler.quizzes;
    return Scaffold(
      appBar: const QuizmeAppBar(
        title: "Quizme",
      ),
      floatingActionButton: createQuizFloatingButton(context, quizHandler),
      body: loadScreenContents(),
    );
  }

// This method creates a FloatingActionButton that allows the user to create a new quiz.
  Tooltip createQuizFloatingButton(
      BuildContext context, QuizHandler quizHandler) {
    return Tooltip(
      message: 'Create new',
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // (MakeQuizScreen) opens where they can create their quiz.
              builder: (context) => MakeQuizScreen(
                  quiz: null,
                  callback: (Quiz quiz) {
                    context.read<QuizHandler>().addQuiz(
                          quiz,
                        );
                  }),
            ),
          );
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 8.0),
            Text('Create Quiz'),
          ],
        ),
      ),
    );
  }

// This method builds the layout for the home page.
// It contains a search field and a list of quizzes.
  Column loadScreenContents() {
    double roundedBorder = 16.0;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(roundedBorder),
          child: Material(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(roundedBorder),
            ),
            child: SizedBox(
              width: 500.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 50.0,
                ),
                child: TextField(
                  decoration: InputDecoration(
// The search field allows the user to search for specific quizzes,
// while the list of quizzes is generated by calling loadQuizTiles method.

                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search...',
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    //filled: true,
                    //fillColor: const Color.fromARGB(255, 224, 219, 219),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(roundedBorder),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        loadQuizTiles(),
      ],
    );
  }

// This method creates a list of quizzes, which is used inside a ListView.builder.
// It is an extended widget that holds the quiz list.
  Expanded loadQuizTiles() {
    return Expanded(
      child: ListView.builder(
          itemCount: quizzes.length + 1,
          itemBuilder: (context, index) {
// If there are quizzes to display,
// each quiz is rendered as a QuizTile widget.
            if (index < quizzes.length) {
              return QuizTile(quiz: quizzes[index % quizzes.length]);
            }

            return const SizedBox(height: 100);
          }),
    );
  }
}

// QuizTile is a StatelessWidget that represents each quiz item in the list.
// It displays information about a quiz,
// including the title, description, and number of questions.
class QuizTile extends StatelessWidget {
  const QuizTile({
    Key? key,
    required this.quiz,
  }) : super(key: key);

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    QuizHandler quizHandler = context.read<QuizHandler>();
    final PlayQuizProvider playQuizModel = context.read<PlayQuizProvider>();
    return GestureDetector(
      onTap: () {
        // TODO Popup to prompt to add question or a new screen saying quiz has no questions

// If the user clicks on a quiz that has no questions,
// nothing happens (if (quiz.questions.isEmpty) return;).

        if (quiz.questions.isEmpty) return;

        // Must set quiz before pushing to the PlayQuizScreen

        playQuizModel.setQuiz(quiz);
        Navigator.push(
          context,
// Otherwise, if the user clicks on a quiz,
// a new page (PlayQuizScreen) will open where the user can play the quiz.
          MaterialPageRoute(
            builder: (context) => const PlayQuizScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Material(
          color: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            tileColor: Theme.of(context).primaryColor,
            title: Text(
              quiz.title,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            subtitle: Text(
              quiz.quizDescription == null ? "" : quiz.quizDescription!,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
            trailing: Column(children: [
              Wrap(
                spacing: 5,
                children: [
                  editQuizButton(context, quizHandler),
                  const SizedBox(height: 5),
                  deleteQuizButton(quizHandler)
                ],
              ),
              Text('Questions: ${quiz.questions.length}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.normal)),
            ]),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }

// used to delete a quiz when the user presses the delete button
  InkWell deleteQuizButton(QuizHandler quizHandler) {
    return InkWell(
        onTap: () {
          quizHandler.removeQuiz(
            quiz,
          );
        },
        child: const Icon(Icons.delete, size: 30));
  }

//  used to edit a quiz when the user presses the edit button
  InkWell editQuizButton(BuildContext context, QuizHandler quizHandler) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MakeQuizScreen(
                  quiz: quiz,
                  callback: (Quiz quiz) {
                    quizHandler.editQuiz(quiz);
                  }),
            ),
          );
        },
        child: const Icon(Icons.edit, size: 30));
  }
}
