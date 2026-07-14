import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_vault/core/widgets/main_layout_screen.dart';

import '../../features/auth/domain/entities/auth_state.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/unlock_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/password_generator/presentation/screens/password_generator_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/vault/presentation/screens/add_edit_entry_screen.dart';
import '../../features/vault/presentation/screens/vault_entry_detail_screen.dart';
import '../../features/vault/presentation/screens/vault_screen.dart';
import 'router_transition.dart';

part 'app_router.g.dart';

bool _hasCompletedInitialLoad = false;
DateTime? _splashStartTime;

@riverpod
Future<void> splashDelay(SplashDelayRef ref) async {
  _splashStartTime = DateTime.now();
  debugPrint('[SPLASH] Start time: $_splashStartTime');
  await Future.delayed(const Duration(milliseconds: 700));
  debugPrint(
    '[SPLASH] Delay elapsed at: ${DateTime.now()}, duration: ${DateTime.now().difference(_splashStartTime!)}',
  );
}

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.hasValue && _splashStartTime != null) {
        debugPrint(
          '[SPLASH] Auth resolution time: ${DateTime.now()}, duration since splash start: ${DateTime.now().difference(_splashStartTime!)}',
        );
      }
      notifyListeners();
    });
    ref.listen(splashDelayProvider, (_, __) {
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
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authStateAsync = ref.read(authNotifierProvider);
      final authState = authStateAsync.valueOrNull;

      final splashDelayAsync = ref.read(splashDelayProvider);
      final isSplashDelayLoading = splashDelayAsync.isLoading;

      // 1. Initial startup phase loader check
      if (!_hasCompletedInitialLoad) {
        if (authStateAsync.isLoading || isSplashDelayLoading) {
          if (state.matchedLocation != '/splash') return '/splash';
          return null; // Stay on /splash
        }
        // Both initial checks resolved, mark initial load as complete
        _hasCompletedInitialLoad = true;
      }

      // 2. Subsequent load check (e.g. login/register submit events)
      // Stay on the current screen and display the screen's local loading spinner.
      if (authStateAsync.isLoading) {
        return null;
      }

      if (authState == null) return null;

      final isGoingToOnboarding = state.matchedLocation == '/onboarding';
      final isGoingToUnlock = state.matchedLocation == '/unlock';
      final isGoingToSplash = state.matchedLocation == '/splash';

      String? result;
      if (authState is AuthUninitialized) {
        if (!isGoingToOnboarding) result = '/onboarding';
      } else if (authState is AuthLocked) {
        if (!isGoingToUnlock) result = '/unlock';
      } else if (authState is AuthUnlocked) {
        if (isGoingToOnboarding || isGoingToUnlock || isGoingToSplash) {
          result = '/';
        }
      }

      return result;
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => RouterTransition.fade(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
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
          child: VaultEntryDetailScreen(id: state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/entry/:id/edit',
        pageBuilder: (context, state) => RouterTransition.slideUp(
          context: context,
          state: state,
          child: AddEditEntryScreen(id: state.pathParameters['id']),
        ),
      ),

      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => RouterTransition.slideUp(
          context: context,
          state: state,
          child: const SettingsScreen(),
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
        ],
      ),
    ],
  );
}
