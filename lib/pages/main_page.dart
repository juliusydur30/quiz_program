import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainPage extends StatelessWidget {
  final String currentUser;

  const MainPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final quizBox = Hive.box('quiz_scores');

    return Scaffold(
      appBar: AppBar(title: const Text("Main Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),

            // 👇 Wrap summary + list in a ValueListenableBuilder
            ValueListenableBuilder(
              valueListenable: quizBox.listenable(),
              builder: (context, Box box, _) {
                final entries = box.values.cast<Map>().toList();
                final totalQuizzes = entries.length;
                final averageScore =
                    entries.isNotEmpty
                        ? (entries
                                    .map((e) => e['score'] as num)
                                    .reduce((a, b) => a + b) /
                                totalQuizzes)
                            .toStringAsFixed(2)
                        : '0.00';

                return Expanded(
                  child: Column(
                    children: [
                      // Summary
                      Text(
                        'Summary: $totalQuizzes quiz${totalQuizzes == 1 ? '' : 'zes'} taken\nAverage Score: $averageScore%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Quiz History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // History List
                      Expanded(
                        child:
                            entries.isEmpty
                                ? const Center(
                                  child: Text("No quizzes taken yet."),
                                )
                                : ListView.builder(
                                  itemCount: entries.length,
                                  itemBuilder: (context, index) {
                                    final name = entries[index]['name'];
                                    final score = entries[index]['score'];
                                    return ListTile(
                                      leading: const Icon(Icons.person),
                                      title: Text(name),
                                      subtitle: Text("Score: $score%"),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/quiz');
              },
              child: const Text('Take Quiz'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/question-list');
              },
              child: const Text('Question List'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
