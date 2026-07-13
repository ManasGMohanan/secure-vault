import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:secure_vault/core/routing/gorouter_extension.dart';
import 'package:secure_vault/core/theme/theme.dart';
import 'floating_notched_painter.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget child;
  const MainLayoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int currentIndex = 0;
    if (location.startsWith('/generator')) {
      currentIndex = 1;
    }

    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240, // Scaled down overall width
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), // Scaled down padding
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(double.infinity, 52), // Scaled down height (52px)
                      painter: FloatingNotchedPainter(
                        color: colors.surfacePrimary,
                        borderColor: colors.borderDefault,
                      ),
                    ),
                    SizedBox(
                      height: 52, // Match painter height
                      child: Row(
                        children: [
                          // Vault tab
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => context.goToHome(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.key,
                                    color: currentIndex == 0
                                        ? colors.textPrimary
                                        : colors.textDisabled,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Vault',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: currentIndex == 0 ? FontWeight.w600 : FontWeight.w500,
                                      color: currentIndex == 0
                                          ? colors.textPrimary
                                          : colors.textDisabled,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Centered Spacer for the FAB cutout
                          const SizedBox(width: 64), // Balanced width for spacer
                          // Generator tab
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => context.goToGenerator(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.sparkles,
                                    color: currentIndex == 1
                                        ? colors.textPrimary
                                        : colors.textDisabled,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Generator',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: currentIndex == 1 ? FontWeight.w600 : FontWeight.w500,
                                      color: currentIndex == 1
                                          ? colors.textPrimary
                                          : colors.textDisabled,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Floating Action Button (+) centered and elevated in the notch
                    Positioned(
                      top: -14, // Proportional FAB shift
                      child: GestureDetector(
                        onTap: () => context.goToNewEntry(),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colors.surfaceElevated, // charcoal #3B3B3E
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.borderDefault, // subtle #4A4A4A ring
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: colors.textPrimary,
                            size: 24,
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
