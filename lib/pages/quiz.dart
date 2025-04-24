import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _nameController = TextEditingController();
  List<Question> questions = [];
  int currentQuestion = 0;
  int correctAnswers = 0;
  bool started = false;

  void _startQuiz() {
    final box = Hive.box<Question>('questions');
    setState(() {
      started = true;
      questions = box.values.toList()..shuffle();
    });
  }

  void _submitAnswer(String choice) {
    if (choice == questions[currentQuestion].correctAnswer) {
      correctAnswers++;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      final score = ((correctAnswers / questions.length) * 100).round();
      Hive.box(
        'quiz_scores',
      ).add({'name': _nameController.text, 'score': score});
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Quiz Completed!'),
              content: Text('Your Score: $score%'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!started) {
      return Scaffold(
        appBar: AppBar(title: const Text('Start Quiz')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Enter your name'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startQuiz,
                child: const Text('Start Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(title: Text('Question ${currentQuestion + 1}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.question, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            for (var choice in question.choices)
              ElevatedButton(
                onPressed: () => _submitAnswer(choice),
                child: Text(choice),
              ),
          ],
        ),
      ),
    );
  }
}
