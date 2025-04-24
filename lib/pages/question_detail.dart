import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/question.dart';

class QuestionDetailPage extends StatefulWidget {
  final Question? question;
  final int? index;

  const QuestionDetailPage({super.key, this.question, this.index});

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _correctAnswerController = TextEditingController();
  final _choiceControllers = List.generate(3, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _questionController.text = widget.question!.question;
      _correctAnswerController.text = widget.question!.correctAnswer;
      for (int i = 0; i < 3; i++) {
        _choiceControllers[i].text = widget.question!.choices[i + 1];
      }
    }
  }

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      final questionText = _questionController.text;
      final correctAnswer = _correctAnswerController.text;
      final rawChoices = [
        correctAnswer,
        ..._choiceControllers.map((c) => c.text),
      ];

      final allChoices = rawChoices.toSet().toList(); // Removes duplicates

      if (allChoices.length < 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All choices must be unique!')),
        );
        return;
      }

      allChoices.shuffle(); // Optional: randomize display order

      final newQuestion = Question(
        question: questionText,
        correctAnswer: correctAnswer,
        choices: allChoices,
      );

      final box = Hive.box<Question>('questions');
      if (widget.index == null) {
        box.add(newQuestion);
      } else {
        box.putAt(widget.index!, newQuestion);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _correctAnswerController,
                decoration: const InputDecoration(labelText: 'Correct Answer'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              for (int i = 0; i < 3; i++)
                TextFormField(
                  controller: _choiceControllers[i],
                  decoration: InputDecoration(labelText: 'Choice ${i + 1}'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveQuestion,
                child: const Text('Save Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
