import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme.dart';
import 'features/settings/presentation/providers/settings_notifier.dart';
import 'features/auth/presentation/providers/auth_notifier.dart';

class SecureVaultApp extends ConsumerWidget {
  const SecureVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsNotifierProvider);

    // Map themeMode string to ThemeMode enum
    ThemeMode themeMode;
    switch (settings.themeMode) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return Listener(
      onPointerDown: (_) {
        // Record global interaction to reset the idle auto-lock timer
        ref.read(authNotifierProvider.notifier).recordActivity();
      },
      child: MaterialApp.router(
        title: 'SecureVault',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
