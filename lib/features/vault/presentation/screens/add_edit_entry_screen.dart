import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_vault/core/routing/gorouter_extension.dart';
import 'package:secure_vault/core/theme/theme.dart';
import 'package:uuid/uuid.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
  PasswordCriteriaResult _criteria = const PasswordCriteriaResult(
    hasMinLength: false,
    hasMediumLength: false,
    hasGreatLength: false,
    hasUppercase: false,
    hasLowercase: false,
    hasNumber: false,
    hasSymbol: false,
    overallStrength: PasswordStrength.weak,
  );

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
      _criteria = PasswordGenerator.evaluateCriteria(entry.password);

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
      _criteria = PasswordGenerator.evaluateCriteria(val);
      _strength = _criteria.overallStrength;
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
                        _criteria = PasswordGenerator.evaluateCriteria(
                          generated,
                        );
                        _strength = _criteria.overallStrength;
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
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    switch (_strength) {
      case PasswordStrength.weak:
        return colors.error;
      case PasswordStrength.medium:
        return colors
            .brandAccent; // Uses brandAccent to avoid inventing non-palette warning colors
      case PasswordStrength.strong:
        return colors.successForeground;
      case PasswordStrength.veryStrong:
        return colors.success;
    }
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: colors.textMuted,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildGroupedCard({required List<Widget> children}) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  List<Widget> _buildCardFields(List<Widget> fields) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final List<Widget> items = [];
    for (int i = 0; i < fields.length; i++) {
      items.add(fields[i]);
      if (i < fields.length - 1) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Divider(
              height: 1,
              thickness: 1,
              color: colors.borderDefault,
            ),
          ),
        );
      }
    }
    return items;
  }

  Widget _buildPasswordStrengthIndicator() {
    if (_passwordController.text.isEmpty) {
      return const SizedBox(height: 16);
    }

    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final strengthColor = _getStrengthColor();

    int filledSegments = 0;
    String label = '';
    switch (_strength) {
      case PasswordStrength.weak:
        filledSegments = 1;
        label = 'Weak';
        break;
      case PasswordStrength.medium:
        filledSegments = 2;
        label = 'Fair';
        break;
      case PasswordStrength.strong:
        filledSegments = 3;
        label = 'Strong';
        break;
      case PasswordStrength.veryStrong:
        filledSegments = 4;
        label = 'Very Strong';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 8.0,
        left: 4.0,
        right: 4.0,
      ),
      child: Row(
        children: [
          ...List.generate(4, (index) {
            final isFilled = index < filledSegments;
            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
                decoration: BoxDecoration(
                  color: isFilled ? strengthColor : colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            );
          }),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: strengthColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCriteriaChecklist() {
    if (_passwordController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    final criteriaList = [
      {'label': 'At least 8 characters', 'isMet': _criteria.hasMinLength},
      {
        'label': 'Upper & lowercase letters',
        'isMet': _criteria.hasUppercase && _criteria.hasLowercase,
      },
      {'label': 'At least one number', 'isMet': _criteria.hasNumber},
      {'label': 'At least one symbol', 'isMet': _criteria.hasSymbol},
      {
        'label': 'At least 12 characters (threshold for a Strong password)',
        'isMet': _criteria.hasMediumLength,
      },
      {
        'label':
            'At least 16 characters (threshold for a Very Strong password)',
        'isMet': _criteria.hasGreatLength,
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4.0, right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: criteriaList.map((item) {
          final isMet = item['isMet'] as bool;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Icon(
                  isMet ? LucideIcons.checkCircle2 : LucideIcons.circle,
                  color: isMet ? colors.success : colors.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: isMet ? colors.textMuted : colors.textPrimary,
                    decoration: isMet
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    final categories = ['Social', 'Banking', 'Work', 'Email', 'Other'];

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          _originalEntry == null ? 'Add Credential' : 'Edit Credential',
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.check),
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
            // BASIC INFO Section
            _buildSectionHeader('Basic Info'),
            _buildGroupedCard(
              children: _buildCardFields([
                // Title field
                Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(
                      LucideIcons.type,
                      color: colors.textSecondary.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Title / Account name',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
                // Category field
                Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(
                      LucideIcons.layoutGrid,
                      color: colors.textSecondary.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _category,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                        dropdownColor: colors.surfacePrimary,
                        decoration: InputDecoration(
                          hintText: 'Category',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        items: categories
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  cat,
                                  style: TextStyle(color: colors.textPrimary),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _category = val);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
              ]),
            ),

            // LOGIN DETAILS Section
            _buildSectionHeader('Login Details'),
            _buildGroupedCard(
              children: _buildCardFields([
                // Username field
                Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(
                      LucideIcons.user,
                      color: colors.textSecondary.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Username / Email',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
                // Password field
                Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(
                      LucideIcons.lock,
                      color: colors.textSecondary.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onChanged: _onPasswordChanged,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
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
                    IconButton(
                      icon: Icon(
                        _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                        color: colors.textSecondary.withValues(alpha: 0.7),
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    Container(
                      height: 20,
                      width: 1,
                      color: colors.borderDefault,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    IconButton(
                      icon: Icon(
                        LucideIcons.refreshCw,
                        color: colors.brandPrimary,
                        size: 20,
                      ),
                      tooltip: 'Generate Password',
                      onPressed: _showPasswordGeneratorSheet,
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
                // Website URL field
                Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(
                      LucideIcons.link,
                      color: colors.textSecondary.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _urlController,
                        keyboardType: TextInputType.url,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Website URL',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
              ]),
            ),

            // Password Strength Indicator
            _buildPasswordStrengthIndicator(),

            // Password Criteria Checklist
            _buildPasswordCriteriaChecklist(),

            // CUSTOM FIELDS Section
            _buildSectionHeader(
              'Custom Fields',
              trailing: GestureDetector(
                onTap: _addCustomField,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.plus,
                      color: colors.brandPrimary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Add field',
                      style: TextStyle(
                        color: colors.brandPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_customFields.isNotEmpty) ...[
              _buildGroupedCard(
                children: _buildCardFields(
                  _customFields.asMap().entries.map((item) {
                    final idx = item.key;
                    final field = item.value;
                    return Row(
                      children: [
                        const SizedBox(width: 14),
                        // Field name
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller:
                                field['nameController']
                                    as TextEditingController,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Field name',
                              hintStyle: TextStyle(color: colors.textMuted),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        // Divider
                        Container(
                          height: 24,
                          width: 1,
                          color: colors.borderDefault,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        // Value
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller:
                                field['valueController']
                                    as TextEditingController,
                            obscureText: field['isSecret'] as bool,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Value',
                              hintStyle: TextStyle(color: colors.textMuted),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  field['isSecret'] as bool
                                      ? LucideIcons.eyeOff
                                      : LucideIcons.eye,
                                  color: colors.textSecondary.withValues(
                                    alpha: 0.7,
                                  ),
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
                          icon: Icon(
                            LucideIcons.trash2,
                            color: colors.error.withValues(alpha: 0.8),
                            size: 20,
                          ),
                          onPressed: () => _removeCustomField(idx),
                        ),
                        const SizedBox(width: 8),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
            ],

            // NOTES Section
            _buildSectionHeader('Notes'),
            _buildGroupedCard(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _notesController,
                        maxLines: 4,
                        minLines: 2,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add any additional notes...',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _save,
              child: Text(
                _originalEntry == null ? 'Create Credential' : 'Save Changes',
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
