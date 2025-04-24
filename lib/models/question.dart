import 'package:hive/hive.dart';

part 'question.g.dart';

@HiveType(typeId: 1)
class Question extends HiveObject {
  @HiveField(0)
  String question;

  @HiveField(1)
  String correctAnswer;

  @HiveField(2)
  List<String> choices;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.choices,
  });
}
