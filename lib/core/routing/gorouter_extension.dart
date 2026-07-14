import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// A custom extension for BuildContext to handle clean type-safe navigation.
extension NavigationExtension on BuildContext {
  void goToHome() => go('/');
  void goToOnboarding() => go('/onboarding');
  void goToUnlock() => go('/unlock');
  void goToEntryDetail(String id) => push('/entry/$id');
  void goToEditEntry(String id) => push('/entry/$id/edit');
  void goToNewEntry() => push('/entry/new');
  void goToSettings() => push('/settings');
  void goToGenerator() => go('/generator');
}
