import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/lives_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../controllers/game_controller.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocusNode = FocusNode();

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocusNode.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    final controller = ref.read(gameControllerProvider.notifier);
    final gameState = ref.read(gameControllerProvider);

    if (gameState.lives <= 0) {
      return;
    }

    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Digite uma tentativa antes de verificar.'),
          ),
        );
      return;
    }

    final isCorrect = controller.checkAnswer();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (isCorrect) {
      _answerController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF2DD4BF)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Resposta correta! Prepare-se para o proximo desafio.',
                ),
              ),
            ],
          ),
        ),
      );
      _answerFocusNode.requestFocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Color(0xFFF87171)),
              SizedBox(width: 10),
              Expanded(
                child: Text('Resposta incorreta. Tente novamente.'),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showHint() {
    final controller = ref.read(gameControllerProvider.notifier);
    final hint = controller.getHint();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: Color(0xFFFBBF24),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('Dica: $hint')),
            ],
          ),
        ),
      );
  }

  void _rewardLife() {
    final controller = ref.read(gameControllerProvider.notifier);
    controller.rewardLife();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.favorite_rounded, color: Color(0xFFF43F5E)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Voce ganhou mais uma vida. Continue o desafio!',
                ),
              ),
            ],
          ),
        ),
      );
  }

  String _buildAnswerFormatHint(String answer) {
    final trimmed = answer.trim();
    final words = trimmed.split(RegExp(r'\s+'));
    final lettersCount = trimmed.replaceAll(' ', '').length;
    if (words.length == 1) {
      return '1 palavra • $lettersCount ${lettersCount == 1 ? "letra" : "letras"}';
    }
    return '${words.length} palavras • $lettersCount letras';
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final currentLevel = controller.currentLevel;
    final totalLevels = controller.totalLevels;
    final currentPhase = gameState.currentLevelIndex + 1;
    final progress = currentPhase / totalLevels;
    final hasLives = gameState.lives > 0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      title: 'Fase $currentPhase',
      subtitle: 'Desafio $currentPhase de $totalLevels',
      showBackButton: true,
      actions: [
        if (gameState.streak > 1)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: colorScheme.secondary.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 16,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${gameState.streak}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: LivesWidget(lives: gameState.lives),
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PROGRESSO DA JORNADA',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: colorScheme.onSurface.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            const SizedBox(height: 20),

            // Animated Riddle Card
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.03, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Card(
                key: ValueKey(currentLevel.id),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.14,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.psychology_alt_rounded,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Enigma atual',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.06,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _buildAnswerFormatHint(currentLevel.answer),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.65,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        currentLevel.question,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Animated Inline Hint Card (when unlocked)
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: gameState.isHintVisible
                  ? Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(
                            alpha: isDark ? 0.12 : 0.1,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: colorScheme.secondary.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_rounded,
                              color: colorScheme.secondary,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Dica: ${currentLevel.hint}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            // Answer Input
            TextField(
              controller: _answerController,
              focusNode: _answerFocusNode,
              enabled: hasLives,
              textInputAction: TextInputAction.done,
              onChanged: controller.updateAnswer,
              onSubmitted: (_) => _submitAnswer(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                labelText: 'Sua resposta',
                hintText: hasLives
                    ? 'Digite sua tentativa'
                    : 'Assista a um video para ganhar mais uma vida',
                prefixIcon: Icon(
                  Icons.key_rounded,
                  color: hasLives
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.35),
                ),
                suffixIcon: gameState.userAnswer.isNotEmpty && hasLives
                    ? IconButton(
                        tooltip: 'Limpar',
                        onPressed: () {
                          _answerController.clear();
                          controller.updateAnswer('');
                        },
                        icon: const Icon(Icons.close_rounded, size: 19),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            PrimaryButton(
              label: 'Verificar',
              icon: Icons.lock_open_rounded,
              onPressed: hasLives ? _submitAnswer : null,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _showHint,
              icon: Icon(
                gameState.isHintVisible
                    ? Icons.lightbulb_rounded
                    : Icons.lightbulb_outline_rounded,
                color: colorScheme.secondary,
              ),
              label: Text(
                gameState.isHintVisible ? 'Ver Dica Novamente' : 'Video + Dica',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                side: BorderSide(
                  color: colorScheme.secondary.withValues(alpha: 0.45),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            // Out-of-lives recovery card
            if (!hasLives) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(
                    alpha: isDark ? 0.14 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.heart_broken_rounded,
                            color: colorScheme.error,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Suas vidas acabaram',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Para continuar jogando, assista a um video e recupere 1 vida.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.85,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: 'Video para ganhar 1 vida',
                      icon: Icons.ondemand_video_outlined,
                      onPressed: _rewardLife,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
