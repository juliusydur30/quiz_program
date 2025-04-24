import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import './models/user.dart';
import './models/question.dart';
import './pages/login.dart';
import 'pages/question_list.dart';
import 'pages/quiz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');
  await Hive.openBox('quiz_scores');
  Hive.registerAdapter(QuestionAdapter());
  await Hive.openBox<Question>('questions');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/question-list': (context) => const QuestionListPage(),
        '/quiz': (context) => const QuizPage(),
        // MainPage is navigated with arguments, so it's not in the route table
      },
    );
  }
}
