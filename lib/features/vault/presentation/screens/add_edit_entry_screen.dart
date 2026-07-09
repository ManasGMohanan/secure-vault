import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_vault/core/routing/gorouter_extension.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/vault_entry.dart';
import '../../presentation/providers/vault_notifier.dart';
import '../../../password_generator/domain/password_generator.dart';

class AddEditEntryScreen extends ConsumerStatefulWidget {
  final String? id;
  const AddEditEntryScreen({super.key, this.id});

  @override
  ConsumerState<AddEditEntryScreen> createState() => _AddEditEntryScreenState();
}

class _AddEditEntryScreenState extends ConsumerState<AddEditEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();

  String _category = 'Social';
  bool _obscurePassword = true;
  PasswordStrength _strength = PasswordStrength.weak;

  // Custom fields tracking
  final List<Map<String, dynamic>> _customFields = [];

  // Keep track of the original entry if editing
  VaultEntry? _originalEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.id != null) {
        _loadEntryData();
      }
    });
  }

  void _loadEntryData() {
    final entries = ref.read(vaultNotifierProvider).valueOrNull ?? [];
    final entry = entries.firstWhere((e) => e.id == widget.id);

    setState(() {
      _originalEntry = entry;
      _titleController.text = entry.title;
      _usernameController.text = entry.username;
      _passwordController.text = entry.password;
      _urlController.text = entry.url;
      _notesController.text = entry.notes;
      _category = entry.category;
      _strength = PasswordGenerator.estimateStrength(entry.password);

      // Load custom fields
      for (final field in entry.customFields) {
        _customFields.add({
          'nameController': TextEditingController(text: field.name),
          'valueController': TextEditingController(text: field.value),
          'isSecret': field.isSecret,
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    for (final field in _customFields) {
      field['nameController'].dispose();
      field['valueController'].dispose();
    }
    super.dispose();
  }

  void _onPasswordChanged(String val) {
    setState(() {
      _strength = PasswordGenerator.estimateStrength(val);
    });
  }

  void _addCustomField() {
    setState(() {
      _customFields.add({
        'nameController': TextEditingController(),
        'valueController': TextEditingController(),
        'isSecret': false,
      });
    });
  }

  void _removeCustomField(int index) {
    setState(() {
      _customFields[index]['nameController'].dispose();
      _customFields[index]['valueController'].dispose();
      _customFields.removeAt(index);
    });
  }

  void _showPasswordGeneratorSheet() {
    int length = 16;
    bool includeUpper = true;
    bool includeLower = true;
    bool includeNumbers = true;
    bool includeSymbols = true;
    bool excludeAmbiguous = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Generate Password',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Slider for Length
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Length: $length',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Slider(
                    value: length.toDouble(),
                    min: 8,
                    max: 64,
                    divisions: 56,
                    label: length.toString(),
                    onChanged: (val) =>
                        setSheetState(() => length = val.round()),
                  ),

                  // Options Checkboxes
                  CheckboxListTile(
                    title: const Text('Uppercase Letters (A-Z)'),
                    value: includeUpper,
                    onChanged: (val) =>
                        setSheetState(() => includeUpper = val ?? true),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Lowercase Letters (a-z)'),
                    value: includeLower,
                    onChanged: (val) =>
                        setSheetState(() => includeLower = val ?? true),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Numbers (0-9)'),
                    value: includeNumbers,
                    onChanged: (val) =>
                        setSheetState(() => includeNumbers = val ?? true),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Symbols (!@#...)'),
                    value: includeSymbols,
                    onChanged: (val) =>
                        setSheetState(() => includeSymbols = val ?? true),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'Exclude Ambiguous Characters (e.g. l, 1, o, 0)',
                    ),
                    value: excludeAmbiguous,
                    onChanged: (val) =>
                        setSheetState(() => excludeAmbiguous = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {
                      final generated = PasswordGenerator.generate(
                        length: length,
                        includeUppercase: includeUpper,
                        includeLowercase: includeLower,
                        includeNumbers: includeNumbers,
                        includeSymbols: includeSymbols,
                        excludeAmbiguous: excludeAmbiguous,
                      );
                      setState(() {
                        _passwordController.text = generated;
                        _strength = PasswordGenerator.estimateStrength(
                          generated,
                        );
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Insert Generated Password'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final String title = _titleController.text.trim();
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    final String url = _urlController.text.trim();
    final String notes = _notesController.text.trim();

    // Map custom fields
    final List<CustomField> customFieldsList = [];
    for (final field in _customFields) {
      final name = field['nameController'].text.trim();
      final val = field['valueController'].text.trim();
      if (name.isNotEmpty && val.isNotEmpty) {
        customFieldsList.add(
          CustomField(
            name: name,
            value: val,
            isSecret: field['isSecret'] as bool,
          ),
        );
      }
    }

    final now = DateTime.now();

    if (_originalEntry == null) {
      // Create new
      final newEntry = VaultEntry(
        id: const Uuid().v4(),
        title: title,
        username: username,
        password: password,
        url: url,
        category: _category,
        notes: notes,
        isFavorite: false,
        createdAt: now,
        updatedAt: now,
        passwordHistory: [],
        customFields: customFieldsList,
      );
      await ref.read(vaultNotifierProvider.notifier).addEntry(newEntry);
    } else {
      // Edit: build password history if password changed
      final List<PasswordHistoryEntry> history = List.from(
        _originalEntry!.passwordHistory,
      );
      if (_originalEntry!.password != password) {
        history.insert(
          0,
          PasswordHistoryEntry(
            password: _originalEntry!.password,
            timestamp: _originalEntry!.updatedAt,
          ),
        );
      }

      final updatedEntry = _originalEntry!.copyWith(
        title: title,
        username: username,
        password: password,
        url: url,
        category: _category,
        notes: notes,
        updatedAt: now,
        passwordHistory: history,
        customFields: customFieldsList,
      );
      await ref.read(vaultNotifierProvider.notifier).updateEntry(updatedEntry);
    }

    if (mounted) {
      context.goToHome();
    }
  }

  Color _getStrengthColor() {
    switch (_strength) {
      case PasswordStrength.weak:
        return Colors.redAccent;
      case PasswordStrength.medium:
        return Colors.orangeAccent;
      case PasswordStrength.strong:
        return Colors.tealAccent.shade400;
      case PasswordStrength.veryStrong:
        return Colors.teal.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = ['Social', 'Banking', 'Work', 'Email', 'Other'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _originalEntry == null ? 'Add Credential' : 'Edit Credential',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save',
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title / Account Name',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category field
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _category = val);
                }
              },
            ),
            const SizedBox(height: 16),

            // Username field
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Username / Email',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Password field (with generator and strength meter)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: _onPasswordChanged,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.autorenew),
                  tooltip: 'Generate Password',
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    minimumSize: const Size(54, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _showPasswordGeneratorSheet,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Strength indicator
            if (_passwordController.text.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Text(
                      'Strength: ${_strength.label}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getStrengthColor(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _strength == PasswordStrength.weak
                              ? 0.25
                              : _strength == PasswordStrength.medium
                              ? 0.5
                              : _strength == PasswordStrength.strong
                              ? 0.75
                              : 1.0,
                          color: _getStrengthColor(),
                          backgroundColor: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          minHeight: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              const SizedBox(height: 8),
            ],

            // Website URL
            TextFormField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Website URL',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 24),

            // Custom Fields Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Custom Fields',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addCustomField,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Field'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Custom fields list
            ..._customFields.asMap().entries.map((item) {
              final idx = item.key;
              final field = item.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller:
                            field['nameController'] as TextEditingController,
                        decoration: const InputDecoration(
                          hintText: 'Field Name',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller:
                            field['valueController'] as TextEditingController,
                        obscureText: field['isSecret'] as bool,
                        decoration: InputDecoration(
                          hintText: 'Value',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              field['isSecret'] as bool
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                _customFields[idx]['isSecret'] =
                                    !(field['isSecret'] as bool);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _removeCustomField(idx),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),

            // Notes
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _save,
              child: Text(
                _originalEntry == null ? 'Create Credential' : 'Save Changes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
