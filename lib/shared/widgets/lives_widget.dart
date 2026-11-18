import 'package:flutter/material.dart';

class LivesWidget extends StatelessWidget {
  const LivesWidget({
    super.key,
    required this.lives,
    this.maxLives = 3,
  });

  final int lives;
  final int maxLives;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isDanger = lives <= 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDanger
            ? colorScheme.error.withValues(alpha: isDark ? 0.18 : 0.12)
            : colorScheme.surface.withValues(alpha: isDark ? 0.8 : 0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDanger
              ? colorScheme.error.withValues(alpha: 0.45)
              : colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(maxLives, (index) {
            final isFilled = index < lives;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isFilled
                      ? Icons.favorite_rounded
                      : Icons.heart_broken_outlined,
                  key: ValueKey('life-$index-$isFilled'),
                  color: isFilled
                      ? const Color(0xFFF43F5E)
                      : colorScheme.onSurface.withValues(alpha: 0.25),
                  size: 20,
                ),
              ),
            );
          }),
          const SizedBox(width: 6),
          Text(
            '$lives/$maxLives',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: isDanger
                  ? colorScheme.error
                  : colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
