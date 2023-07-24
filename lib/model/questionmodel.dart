class QuizQuestion {
  const QuizQuestion(this.question, this.answer);

  final String question;
  final List<String> answer;

  List<String> shufflelist() {
    final newlist = List.of(answer);
    newlist.shuffle();
    return newlist;
  }
}
