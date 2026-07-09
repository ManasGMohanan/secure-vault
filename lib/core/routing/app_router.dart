import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/entities/auth_state.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/unlock_screen.dart';
import '../../features/password_generator/presentation/screens/password_generator_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/vault/presentation/screens/add_edit_entry_screen.dart';
import '../../features/vault/presentation/screens/vault_entry_detail_screen.dart';
import '../../features/vault/presentation/screens/vault_screen.dart';
import 'gorouter_extension.dart';
import 'router_transition.dart';

part 'app_router.g.dart';

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    ref.listen(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  // Define navigators
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  final refreshListenable = RouterRefreshListenable(ref);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/unlock',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authStateAsync = ref.read(authNotifierProvider);
      final authState = authStateAsync.valueOrNull;
      
      // 1. Check if auth notifier is still loading initial state
      if (authStateAsync.isLoading) {
        return null; // Stay on current/splash until loaded
      }

      if (authState == null) return null;

      final isGoingToOnboarding = state.matchedLocation == '/onboarding';
      final isGoingToUnlock = state.matchedLocation == '/unlock';

      String? result;
      if (authState is AuthUninitialized) {
        if (!isGoingToOnboarding) result = '/onboarding';
      } else if (authState is AuthLocked) {
        if (!isGoingToUnlock) result = '/unlock';
      } else if (authState is AuthUnlocked) {
        if (isGoingToOnboarding || isGoingToUnlock) result = '/';
      }

      return result;
    },
    routes: [
      // Top level auth routes with fade transitions
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => RouterTransition.fade(
          context: context,
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/unlock',
        pageBuilder: (context, state) => RouterTransition.fade(
          context: context,
          state: state,
          child: const UnlockScreen(),
        ),
      ),

      // Top level vault routes with slide-up transitions
      GoRoute(
        path: '/entry/new',
        pageBuilder: (context, state) => RouterTransition.slideUp(
          context: context,
          state: state,
          child: const AddEditEntryScreen(),
        ),
      ),
      GoRoute(
        path: '/entry/:id',
        pageBuilder: (context, state) => RouterTransition.slideUp(
          context: context,
          state: state,
          child: VaultEntryDetailScreen(
            id: state.pathParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '/entry/:id/edit',
        pageBuilder: (context, state) => RouterTransition.slideUp(
          context: context,
          state: state,
          child: AddEditEntryScreen(
            id: state.pathParameters['id'],
          ),
        ),
      ),

      // Shell Route for bottom navigation
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayoutScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => RouterTransition.fade(
              context: context,
              state: state,
              child: const VaultScreen(),
            ),
          ),
          GoRoute(
            path: '/generator',
            pageBuilder: (context, state) => RouterTransition.fade(
              context: context,
              state: state,
              child: const PasswordGeneratorScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => RouterTransition.fade(
              context: context,
              state: state,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}

/// The base main layout containing the premium bottom navigation bar.
class MainLayoutScreen extends StatelessWidget {
  final Widget child;
  const MainLayoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int currentIndex = 0;
    if (location.startsWith('/generator')) {
      currentIndex = 1;
    } else if (location.startsWith('/settings')) {
      currentIndex = 2;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          onTap: (index) {
            if (index == 0) {
              context.goToHome();
            } else if (index == 1) {
              context.goToGenerator();
            } else if (index == 2) {
              context.goToSettings();
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.vpn_key_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.vpn_key),
              ),
              label: 'Vault',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.tune_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.tune),
              ),
              label: 'Generator',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.settings_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.settings),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
