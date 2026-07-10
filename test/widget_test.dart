import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_vault/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:secure_vault/core/theme/theme.dart';

void main() {
  testWidgets('OnboardingScreen renders title and form fields', (WidgetTester tester) async {
    // Build OnboardingScreen in an environment with Riverpod and Material
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const OnboardingScreen(),
        ),
      ),
    );

    // Verify presence of title, logo icon, and password input fields
    expect(find.text('SecureVault'), findsOneWidget);
    expect(find.text('Master Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
