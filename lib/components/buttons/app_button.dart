import 'dart:async';
import 'package:flutter/material.dart';

enum AppButtonVariant { filled, tonal, outlined, text }

enum AppButtonSize { sm, md, lg }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.md,
    this.fullWidth = false,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.onPressedAsync,
    this.loading,
    this.disabled = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.borderRadius,
    this.throttle = const Duration(milliseconds: 800),
    this.enableHaptics = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  final String label;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;
  final Widget? icon;
  final Widget? trailingIcon;
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync;
  final bool? loading;
  final bool disabled;
  final String? tooltip;
  final bool autofocus;
  final FocusNode? focusNode;
  final BorderRadius? borderRadius;
  final Duration throttle;
  final bool enableHaptics;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _internalLoading = false;
  DateTime _lastTap = DateTime.fromMicrosecondsSinceEpoch(0);

  bool get _isBusy => (widget.loading ?? _internalLoading);
  bool get _isDisabled =>
      widget.disabled ||
      _isBusy ||
      (widget.onPressed == null && widget.onPressedAsync == null);

  Future<void> _handlePress() async {
    if (_isDisabled) return;

    final now = DateTime.now();
    if (now.difference(_lastTap) < widget.throttle) return;
    _lastTap = now;

    if (widget.enableHaptics) {
      setState(() => _internalLoading = true);
      try {
        await widget.onPressedAsync!.call();
      } finally {
        if (mounted) setState(() => _internalLoading = false);
      }
    } else {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final (padV, padH, textStyle) = switch (widget.size) {
      AppButtonSize.sm => (10.0, 14.0, theme.textTheme.labelSmall),
      AppButtonSize.md => (14.0, 18.0, theme.textTheme.labelMedium),
      AppButtonSize.lg => (14.0, 18.0, theme.textTheme.labelLarge),
    };

    final radius = widget.borderRadius ?? BorderRadius.circular(12);

    final (
      ButtonStyleButton Function({
        Key? key,
        required VoidCallback? onPressed,
        required Widget child,
      })
      ctor,
      ButtonStyle baseStyle,
    ) = switch (widget.variant) {
      AppButtonVariant.filled => (
        ({key, onPressed, required child}) =>
            FilledButton(onPressed: onPressed, child: child),
        FilledButton.styleFrom(
          elevation: widget.elevation,
          backgroundColor: widget.backgroundColor ?? scheme.primary,
          foregroundColor: widget.foregroundColor ?? scheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: padV, horizontal: padH),
          textStyle: textStyle,
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),

      AppButtonVariant.tonal => (
        ({key, onPressed, required child}) =>
            FilledButton.tonal(key: key, onPressed: onPressed, child: child),
        FilledButton.styleFrom(
          elevation: widget.elevation ?? 0,
          backgroundColor: widget.backgroundColor ?? scheme.secondaryContainer,
          foregroundColor:
              widget.foregroundColor ?? scheme.onSecondaryContainer,
          padding: EdgeInsets.symmetric(vertical: padV, horizontal: padH),
          textStyle: textStyle,
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      AppButtonVariant.outlined => (
        ({key, onPressed, required child}) =>
            OutlinedButton(key: key, onPressed: onPressed, child: child),
        OutlinedButton.styleFrom(
          side: BorderSide(
            color: (widget.foregroundColor ?? scheme.primary).withOpacity(0.6),
          ),
          foregroundColor: widget.foregroundColor ?? scheme.primary,
          padding: EdgeInsets.symmetric(vertical: padV, horizontal: padH),
          textStyle: textStyle,
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      AppButtonVariant.text => (
        ({key, onPressed, required child}) =>
            TextButton(key: key, onPressed: onPressed, child: child),
        TextButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? scheme.primary,
          padding: EdgeInsets.symmetric(vertical: padV, horizontal: padH),
          textStyle: textStyle,
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
    };

    final child = _buildContent(context, textStyle);

    final button = Tooltip(
      message: widget.tooltip ?? widget.label,
      child: ctor(onPressed: _isDisabled ? null : _handlePress, child: child),
    );

    if (widget.fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildContent(BuildContext context, TextStyle? textStyle) {
    final spinner = SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );

    final labelText = Flexible(
      child: Text(widget.label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );

    final gap = const SizedBox(width: 8);

    if (_isBusy) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          spinner,
          gap,
          Opacity(opacity: 0.0, child: labelText),
        ],
      );
    }

    final children = <Widget>[
      if (widget.icon != null) widget.icon!,
      if (widget.icon != null) gap,
      labelText,
      if (widget.trailingIcon != null) gap,
      if (widget.trailingIcon != null) widget.trailingIcon!,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
