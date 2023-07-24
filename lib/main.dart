import 'package:flutter/material.dart';
import 'package:quizapp/data/questions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/model/questionmodel.dart';

void main() {
  runApp(Quiz());
}

// STARTING SCREEN DESIGN //
class StartScreen extends StatelessWidget {
  const StartScreen(this.currentScreen, {super.key});
  final void Function() currentScreen;
  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'asset/images/quiz-logo.png',
            width: 275,
            color: const Color.fromARGB(149, 245, 244, 244),
          ),
          const SizedBox(height: 50),
          const Text(
            'Learn Flutter the fun way',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(18)),
              onPressed: currentScreen,
              icon: const Icon(Icons.arrow_forward_ios_sharp),
              label: const Text(
                'Start Quiz',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
        ],
      ),
    );
  }
}

// Sart screen widget to change from start screen to quiz screen //

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  Widget? screen;
  List<String> answerlist = [];
  @override
  void initState() {
    super.initState();
    screen = StartScreen(currentScreen);
  }

  void ans(String selectedans) {
    answerlist.add(selectedans);

    if (answerlist.length == questions.length) {
      setState(() {
        final ans = List.of(answerlist);
        answerlist.clear();
        screen = ResultScreen(currentScreen, ans);
      });
    }
  }

  void currentScreen() {
    setState(() {
      screen = QuestionScreen(ans);
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: screen,
        ),
      ),
    );
  }
}

// QUESTION SCREEN WIDGET //

class QuestionScreen extends StatefulWidget {
  const QuestionScreen(this.ansselected, {super.key});
  final void Function(String answ) ansselected;
  @override
  State<QuestionScreen> createState() {
    return _QuestionScreenState();
  }
}

class _QuestionScreenState extends State<QuestionScreen> {
  int count = 0;
  void currentcount(String answer) {
    widget.ansselected(answer);
    setState(() {
      count++;
    });
  }

  @override
  Widget build(context) {
    final currentquestion = questions[count];

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentquestion.question,
              style: GoogleFonts.robotoMono(
                color: Colors.amber,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...currentquestion.shufflelist().map((ans) {
              return StyledButton(ans, () {
                currentcount(ans);
              });
            }),
          ],
        ),
      ),
    );
  }
}

// Button Styling //

class StyledButton extends StatelessWidget {
  const StyledButton(this.anstext, this.ontap, {super.key});

  final String anstext;
  final void Function() ontap;

  @override
  Widget build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: ontap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            backgroundColor: Colors.amber,
            textStyle: GoogleFonts.robotoMono(fontSize: 20),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          ),
          child: Text(anstext, textAlign: TextAlign.center),
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}

// RESULT SCREEN //
class ResultScreen extends StatelessWidget {
  const ResultScreen(this.restartscreen, this.chosenAnswer, {super.key});

  final List<String> chosenAnswer;
  final void Function() restartscreen;

  List<Map<String, Object>> getSummaryData() {
    List<Map<String, Object>> summary = [];
    for (var i = 0; i < chosenAnswer.length; i++) {
      summary.add({
        'question-number': i,
        'question': questions[i].question,
        'correct-answer': questions[i].answer[0],
        'answer-choosed': chosenAnswer[i]
      });
    }
    return summary;
  }

  @override
  Widget build(context) {
    final summarydata = getSummaryData();
    final totalNumberQuestion = questions.length;
    final correctlyAnswered = summarydata.where((data) {
      return data['answer-choosed'] == data['correct-answer'];
    }).length;

    return Center(
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'You have answer $correctlyAnswered question out of $totalNumberQuestion correctly',
                style: GoogleFonts.robotoCondensed(
                    color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 30,
            ),
            QuestionSummary(summarydata),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15)),
                onPressed: restartscreen,
                icon: const Icon(Icons.restart_alt),
                label: const Text("Restart Quiz"))
          ],
        ),
      ),
    );
  }
}

// DATA FOR RESULT SCREEN //

class QuestionSummary extends StatelessWidget {
  const QuestionSummary(this.summarydata, {super.key});
  final List<Map<String, Object>> summarydata;

  @override
  Widget build(context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: summarydata.map((data) {
            return Row(
              children: [
                // Text(((data['question-number'] as int) + 1).toString(),
                //     style: const TextStyle(color: Colors.white)),
                StylingText(data['question-number'] as int,
                    data['answer-choosed'] == data['correct-answer']),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['question'] as String,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(data['answer-choosed'] as String,
                            style: const TextStyle(
                                color: Color.fromARGB(195, 194, 194, 194)),
                            textAlign: TextAlign.start),
                        const SizedBox(height: 10),
                        Text(data['correct-answer'] as String,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 162, 113, 169))),
                        const SizedBox(height: 25)
                      ],
                    ),
                  ),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class StylingText extends StatelessWidget {
  const StylingText(this.indexing, this.ans, {super.key});
  final int indexing;
  final bool ans;

  Widget build(context) {
    final int indexnumber = indexing + 1;
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          color: ans ? Colors.blue : Colors.pink, shape: BoxShape.circle),
      child: Center(
        child: Text(
          indexnumber.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
