import 'package:flutter/material.dart';

/// Circular avatar that shows the initials of a person's name.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.radius = 22,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String name;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? scheme.primaryContainer,
      child: Text(
        _initials,
        style:
            (radius >= 28
                    ? theme.textTheme.headlineSmall
                    : theme.textTheme.titleSmall)
                ?.copyWith(
                  color: foregroundColor ?? scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
      ),
    );
  }
}
