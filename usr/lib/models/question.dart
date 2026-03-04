class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation = '',
  });
}

final List<Question> sampleQuestions = [
  const Question(
    text: "What is the capital of the Netherlands?",
    options: ["Berlin", "Amsterdam", "Brussels", "Paris"],
    correctAnswerIndex: 1,
    explanation: "Amsterdam is the capital city of the Netherlands.",
  ),
  const Question(
    text: "Which programming language is Flutter built with?",
    options: ["Java", "Swift", "Dart", "Python"],
    correctAnswerIndex: 2,
    explanation: "Flutter uses the Dart programming language.",
  ),
  const Question(
    text: "What widget is used for scrolling lists in Flutter?",
    options: ["Column", "ListView", "Stack", "Container"],
    correctAnswerIndex: 1,
    explanation: "ListView is the standard widget for scrolling lists.",
  ),
];
