import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isEnabled ? 1.0 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    colorScheme.primary,
                    Color.lerp(
                      colorScheme.primary,
                      colorScheme.secondary,
                      0.22,
                    )!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled
              ? null
              : colorScheme.onSurface.withValues(alpha: 0.12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: isEnabled
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: isEnabled
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface.withValues(alpha: 0.45),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isEnabled
                                  ? colorScheme.onPrimary.withValues(alpha: 0.8)
                                  : colorScheme.onSurface.withValues(alpha: 0.35),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
