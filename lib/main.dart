import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/security/web_storage_helper.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'features/settings/data/settings_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Core
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive CE NoSQL storage
  await Hive.initFlutter();

  if (kIsWeb) {
    await initializeWebSessionWipe('secure_vault_entries_box');
  }

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Provide the pre-initialized shared preferences instance
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SecureVaultApp(),
    ),
  );
}
