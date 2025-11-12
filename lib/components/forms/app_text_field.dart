import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './validators.dart';
import '../../core/utils/debouncer.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.asyncValidator,
    this.debounce = const Duration(milliseconds: 350),
    this.autofillHints,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final SyncValidator<String>? validator;
  final AsyncValidator<String>? asyncValidator;
  final Duration debounce;

  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  final _debouncer = Debouncer();
  String? _errorText;
  String? _asyncErrorText;
  bool _validating = false;
  int _validationEpoch = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runSyncValidation();
    });
    _controller.addListener(_handleChange);
  }

  void _handleChange() {
    final text = _controller.text;
    widget.onChanged?.call(text);
    if (widget.autovalidateMode != AutovalidateMode.disabled) {
      _runSyncValidation();
      _runAsyncValidation(debounced: true);
    }
  }

  void _runSyncValidation() {
    if (widget.validator == null) return;
    _errorText = widget.validator!.call(_controller.text);
    setState(() {});
  }

  void _runAsyncValidation({required bool debounced}) {
    if (widget.asyncValidator == null) return;

    Future<Null> work() async {
      final myEpoch = ++_validationEpoch;
      setState(() => _validating = true);
      try {
        final err = await widget.asyncValidator!.call(_controller.text);
        if (!mounted) return;

        if (myEpoch == _validationEpoch) {
          _asyncErrorText = err;
        }
      } finally {
        if (mounted && myEpoch == _validationEpoch) {
          setState(() => _validating = false);
        }
      }
    }

    if (debounced) {
      _debouncer.run(work);
    } else {
      work();
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  String? get _composedError => _errorText ?? _asyncErrorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canClear =
        widget.enabled && !widget.readOnly && _controller.text.isNotEmpty;

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      autovalidateMode: widget.autovalidateMode,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffix(theme, canClear),
        errorText: _composedError,
      ),
      validator: (_) => _composedError,
      onFieldSubmitted: (value) {
        widget.onSubmitted?.call(value);
        if (widget.textInputAction == TextInputAction.next) {
          _focusNode.nextFocus();
        } else if (widget.textInputAction == TextInputAction.done) {
          _focusNode.unfocus();
        }
      },
    );
  }

  Widget? _buildSuffix(ThemeData theme, bool canClear) {
    final suffixes = <Widget>[];

    if (_validating) {
      suffixes.add(
        const SizedBox(
          width: 20,
          height: 20,
          child: Padding(
            padding: EdgeInsets.all(2),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (widget.suffixIcon != null) {
      suffixes.add(widget.suffixIcon!);
    }

    if (canClear) {
      suffixes.add(
        IconButton(
          onPressed: () => _controller.clear(),
          icon: const Icon(Icons.close),
          tooltip: 'Clear',
        ),
      );
    }

    return suffixes.isEmpty
        ? null
        : Row(mainAxisSize: MainAxisSize.min, children: suffixes);
  }
}
