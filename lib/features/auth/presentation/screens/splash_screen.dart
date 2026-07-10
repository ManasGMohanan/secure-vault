import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:secure_vault/core/theme/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/svg/securevault_logo.svg',
              height: 120,
            ),
            const SizedBox(height: 24),
            Text(
              'SecureVault',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
