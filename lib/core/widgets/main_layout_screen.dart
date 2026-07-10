import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:secure_vault/core/routing/gorouter_extension.dart';
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240, // Scaled down overall width
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  0,
                  12,
                  12,
                ), // Scaled down padding
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(
                        double.infinity,
                        52,
                      ), // Scaled down height (52px)
                      painter: FloatingNotchedPainter(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
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
                                        ? theme.colorScheme.primary
                                        : (isDark
                                              ? Colors.grey.shade500
                                              : Colors.grey.shade400),
                                    size: 20, // Scaled down icon size
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Vault',
                                    style: TextStyle(
                                      fontSize: 11, // Scaled down font size
                                      fontWeight: currentIndex == 0
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: currentIndex == 0
                                          ? theme.colorScheme.primary
                                          : (isDark
                                                ? Colors.grey.shade500
                                                : Colors.grey.shade400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Centered Spacer for the FAB cutout
                          const SizedBox(
                            width: 64,
                          ), // Balanced width for spacer
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
                                        ? theme.colorScheme.primary
                                        : (isDark
                                              ? Colors.grey.shade500
                                              : Colors.grey.shade400),
                                    size: 20, // Scaled down icon size
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Generator',
                                    style: TextStyle(
                                      fontSize: 11, // Scaled down font size
                                      fontWeight: currentIndex == 1
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: currentIndex == 1
                                          ? theme.colorScheme.primary
                                          : (isDark
                                                ? Colors.grey.shade500
                                                : Colors.grey.shade400),
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
                          width: 48, // Scaled down FAB size (48px)
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24, // Scaled down icon inside FAB
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
