import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'question_detail.dart';
import '../models/question.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({super.key});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  final Box<Question> questionBox = Hive.box<Question>('questions');

  void _deleteQuestion(int index) {
    questionBox.deleteAt(index);
    setState(() {});
  }

  void _navigateToAddEdit([Question? question, int? index]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionDetailPage(question: question, index: index),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Questions")),
      body: ValueListenableBuilder(
        valueListenable: questionBox.listenable(),
        builder: (context, Box<Question> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No questions added."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final q = box.getAt(index)!;
              return ListTile(
                title: Text(q.question),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _navigateToAddEdit(q, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteQuestion(index),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEdit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
