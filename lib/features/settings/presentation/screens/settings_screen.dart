import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_controller.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../game/presentation/controllers/game_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final gameState = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      title: 'Configuracoes',
      subtitle: 'Preferências e progresso',
      showBackButton: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'APARENCIA',
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 1.1,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                secondary: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: colorScheme.primary,
                  ),
                ),
                value: isDarkMode,
                onChanged: (_) {
                  ref.read(themeModeProvider.notifier).toggle();
                },
                title: const Text(
                  'Modo escuro',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Alternancia inicial de tema.'),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'PROGRESSO DO JOGO',
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 1.1,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withValues(
                              alpha: 0.14,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.emoji_events_rounded,
                            color: colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fase atual: ${gameState.currentLevelIndex + 1} de ${controller.totalLevels}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Vidas restantes: ${gameState.lives}/3 • Sequência: ${gameState.streak}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.65,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          controller.resetProgress();
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Progresso reiniciado para a Fase 1.',
                                ),
                              ),
                            );
                        },
                        icon: const Icon(Icons.restart_alt_rounded, size: 19),
                        label: const Text('Reiniciar jornada (Fase 1)'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
