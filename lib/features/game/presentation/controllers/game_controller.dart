import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local_levels.dart';
import '../../domain/game_level.dart';

class GameState {
  const GameState({
    this.currentLevelIndex = 0,
    this.lives = 3,
    this.userAnswer = '',
    this.isHintVisible = false,
    this.streak = 0,
  });

  final int currentLevelIndex;
  final int lives;
  final String userAnswer;
  final bool isHintVisible;
  final int streak;

  GameState copyWith({
    int? currentLevelIndex,
    int? lives,
    String? userAnswer,
    bool? isHintVisible,
    int? streak,
  }) {
    return GameState(
      currentLevelIndex: currentLevelIndex ?? this.currentLevelIndex,
      lives: lives ?? this.lives,
      userAnswer: userAnswer ?? this.userAnswer,
      isHintVisible: isHintVisible ?? this.isHintVisible,
      streak: streak ?? this.streak,
    );
  }
}

class GameController extends StateNotifier<GameState> {
  GameController(this._levels) : super(const GameState());

  final List<GameLevel> _levels;

  int get totalLevels => _levels.length;

  GameLevel get currentLevel => _levels[state.currentLevelIndex];

  void updateAnswer(String value) {
    state = state.copyWith(userAnswer: value);
  }

  static String _normalize(String input) {
    var s = input.trim().toLowerCase();
    const diacritics = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      '-': ' ',
    };
    diacritics.forEach((k, v) {
      s = s.replaceAll(k, v);
    });
    s = s.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(RegExp(r'\s+'), ' ').trim();
    for (final prefix in ['um ', 'uma ', 'uns ', 'umas ', 'o ', 'a ', 'os ', 'as ']) {
      if (s.startsWith(prefix) && s.length > prefix.length) {
        s = s.substring(prefix.length).trim();
        break;
      }
    }
    return s;
  }

  bool checkAnswer() {
    if (state.lives <= 0) {
      return false;
    }

    final normalizedInput = _normalize(state.userAnswer);
    if (normalizedInput.isEmpty) {
      return false;
    }
    final normalizedExpected = _normalize(currentLevel.answer);

    final isMatch = normalizedInput == normalizedExpected ||
        (normalizedExpected == 'd' && normalizedInput == 'dezembro');

    if (isMatch) {
      final nextIndex = (state.currentLevelIndex + 1) % _levels.length;
      state = state.copyWith(
        currentLevelIndex: nextIndex,
        userAnswer: '',
        isHintVisible: false,
        streak: state.streak + 1,
      );
      return true;
    }

    final remainingLives = (state.lives - 1).clamp(0, 3);
    state = state.copyWith(
      lives: remainingLives,
      streak: 0,
    );
    return false;
  }

  String getHint() {
    state = state.copyWith(isHintVisible: true);
    return currentLevel.hint;
  }

  void rewardLife() {
    final updatedLives = (state.lives + 1).clamp(0, 3);
    state = state.copyWith(lives: updatedLives);
  }

  void resetProgress() {
    state = const GameState();
  }
}

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  return GameController(localLevels);
});
