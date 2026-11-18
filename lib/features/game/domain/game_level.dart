class GameLevel {
  const GameLevel({
    required this.id,
    required this.question,
    required this.answer,
    required this.hint,
  });

  final String id;
  final String question;
  final String answer;
  final String hint;

  String get prompt => question;
  String get riddle => question;
  String get enigma => question;
}
