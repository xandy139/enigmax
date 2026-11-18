import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_controller.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/lives_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../game/presentation/controllers/game_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final gameState = ref.watch(gameControllerProvider);
    final totalLevels =
        ref.read(gameControllerProvider.notifier).totalLevels;
    final currentPhase = gameState.currentLevelIndex + 1;

    return AppScaffold(
      title: 'EnigmaX',
      subtitle: 'Código Oculto',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            tooltip: isDark ? 'Modo claro' : 'Modo escuro',
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggle();
            },
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
        ),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    // Glowing Mystery Emblem
                    Center(
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.26),
                              colorScheme.primary.withValues(alpha: 0.04),
                            ],
                          ),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 32,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.surface,
                              border: Border.all(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.lock_outline_rounded,
                              size: 36,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'EnigmaX',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Decifre enigmas, preserve suas vidas e avance por desafios cada vez mais misteriosos.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.75),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Live Progress Status Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.14,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '#$currentPhase',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Progresso Atual',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Fase $currentPhase de $totalLevels',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LivesWidget(lives: gameState.lives),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Immersion Tip Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(
                          alpha: isDark ? 0.08 : 0.07,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.secondary.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withValues(
                                alpha: 0.16,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: colorScheme.secondary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dica de Imersão',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Para uma experiencia mais imersiva, tente resolver cada enigma usando apenas as pistas do proprio app. Evitar dicas de fora deixa cada descoberta mais divertida e muito mais satisfatoria.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.85,
                                    ),
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: currentPhase > 1
                          ? 'Continuar (Fase $currentPhase)'
                          : 'Jogar',
                      icon: Icons.play_arrow_rounded,
                      onPressed: () => context.push('/game'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.push('/settings'),
                        icon: const Icon(Icons.tune_rounded, size: 19),
                        label: const Text(
                          'Configurações',
                          style: TextStyle(
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
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.16,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
