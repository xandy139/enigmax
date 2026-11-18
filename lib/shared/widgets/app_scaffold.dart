import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.actions,
    this.showBackButton = false,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final canPop = GoRouter.of(context).canPop();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        leadingWidth: 64,
        leading: (showBackButton || canPop)
            ? Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Center(
                  child: Material(
                    color: colorScheme.surface.withValues(
                      alpha: isDark ? 0.75 : 0.9,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      },
                      child: const SizedBox(
                        width: 42,
                        height: 42,
                        child: Tooltip(
                          message: 'Voltar',
                          child: Icon(Icons.arrow_back_rounded, size: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
        actions: actions,
      ),
      body: Stack(
        children: [
          // Atmospheric background gradient & ambient glowing orbs
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [
                          Color(0xFF020617),
                          Color(0xFF091326),
                          Color(0xFF020617),
                        ]
                      : const [
                          Color(0xFFF8FAFC),
                          Color(0xFFEFF6FF),
                          Color(0xFFF1F5F9),
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -80,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(
                        alpha: isDark ? 0.16 : 0.12,
                      ),
                      colorScheme.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -90,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.secondary.withValues(
                        alpha: isDark ? 0.10 : 0.08,
                      ),
                      colorScheme.secondary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: body,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
