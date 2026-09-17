class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({required this.text, required this.options, required this.correctIndex});

  factory Question.fromMap(Map<String, dynamic> m) => Question(
        text: m['text'] as String,
        options: List<String>.from(m['options'] as List<dynamic>),
        correctIndex: m['correctIndex'] as int,
      );
}