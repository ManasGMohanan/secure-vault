import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:secure_vault/features/vault/data/vault_repository.dart';
import 'package:secure_vault/features/vault/domain/entities/vault_entry.dart';

void main() {
  late Directory tempDir;
  late VaultRepository repository;
  final derivedKey = Uint8List.fromList(List.filled(32, 7)); // Dummy 256-bit key

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    repository = VaultRepository();
  });

  tearDown(() async {
    await repository.closeBox();
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('VaultRepository Tests', () {
    test('box open and close states', () async {
      expect(repository.isOpen, isFalse);
      
      await repository.openBox(derivedKey);
      expect(repository.isOpen, isTrue);
      
      await repository.closeBox();
      expect(repository.isOpen, isFalse);
    });

    test('save and retrieve entries', () async {
      await repository.openBox(derivedKey);
      
      final entry = VaultEntry(
        id: 'test-id-123',
        title: 'Google Account',
        username: 'user@gmail.com',
        password: 'SuperSecretPassword',
        url: 'https://google.com',
        category: 'Work',
        notes: 'Personal account',
        isFavorite: true,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 2),
        passwordHistory: [],
        customFields: [],
      );

      // Save
      await repository.saveEntry(entry);

      // Get
      final List<VaultEntry> entries = await repository.getEntries();
      
      expect(entries.length, 1);
      final retrieved = entries.first;
      expect(retrieved.id, 'test-id-123');
      expect(retrieved.title, 'Google Account');
      expect(retrieved.username, 'user@gmail.com');
      expect(retrieved.password, 'SuperSecretPassword');
      expect(retrieved.url, 'https://google.com');
      expect(retrieved.category, 'Work');
      expect(retrieved.notes, 'Personal account');
      expect(retrieved.isFavorite, isTrue);
    });

    test('delete entry works', () async {
      await repository.openBox(derivedKey);
      
      final entry = VaultEntry(
        id: 'test-id-999',
        title: 'Delete Me',
        username: 'delete@me.com',
        password: 'pwd',
        url: '',
        category: 'Social',
        notes: '',
        isFavorite: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        passwordHistory: [],
        customFields: [],
      );

      await repository.saveEntry(entry);
      
      var entries = await repository.getEntries();
      expect(entries.length, 1);

      await repository.deleteEntry(entry.id);
      
      entries = await repository.getEntries();
      expect(entries.isEmpty, isTrue);
    });
  });
}
