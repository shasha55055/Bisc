class Question {
  final String text;
  final List<Answer> answers;

  const Question({ required this.text, required this.answers });
}

class Answer {
  final String text;
  bool isCorrect;

  Answer({ required this.text, required this.isCorrect });
}