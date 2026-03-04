import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _showAnswer = false;
  int _score = 0;

  void _answerQuestion(int index) {
    if (_selectedAnswerIndex != null) return; // Prevent re-answering

    setState(() {
      _selectedAnswerIndex = index;
      if (index == sampleQuestions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
      _showAnswer = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < sampleQuestions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _showAnswer = false;
      } else {
        // Quiz Finished
        _showResultDialog();
      }
    });
  }

  void _autoFindAnswer() {
    // Simulates the "Auto Answer" feature requested, but within this app
    if (_selectedAnswerIndex != null) return;
    
    setState(() {
      _selectedAnswerIndex = sampleQuestions[_currentQuestionIndex].correctAnswerIndex;
      _score++; // Grant points for auto-answer? Maybe not, but for demo purposes.
      _showAnswer = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Auto-answered correctly!")),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Completed"),
        content: Text("You scored $_score out of ${sampleQuestions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to home
            },
            child: const Text("Finish"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _selectedAnswerIndex = null;
                _showAnswer = false;
                _score = 0;
              });
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = sampleQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Master"),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            tooltip: "Auto Answer",
            onPressed: _autoFindAnswer,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / sampleQuestions.length,
            ),
            const SizedBox(height: 20),
            Text(
              "Question ${_currentQuestionIndex + 1}/${sampleQuestions.length}",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            Text(
              question.text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 30),
            ...List.generate(question.options.length, (index) {
              final isSelected = _selectedAnswerIndex == index;
              final isCorrect = index == question.correctAnswerIndex;
              
              Color? buttonColor;
              if (_showAnswer) {
                if (isCorrect) {
                  buttonColor = Colors.green.shade100;
                } else if (isSelected) {
                  buttonColor = Colors.red.shade100;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.all(16),
                    side: BorderSide(
                      color: _showAnswer && isCorrect ? Colors.green : Colors.grey,
                      width: _showAnswer && isCorrect ? 2 : 1,
                    ),
                  ),
                  onPressed: () => _answerQuestion(index),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question.options[index],
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      if (_showAnswer && isCorrect)
                        const Icon(Icons.check_circle, color: Colors.green),
                      if (_showAnswer && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: Colors.red),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_showAnswer)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  question.explanation,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _showAnswer ? _nextQuestion : null,
                child: Text(
                  _currentQuestionIndex < sampleQuestions.length - 1
                      ? "Next Question"
                      : "See Results",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
