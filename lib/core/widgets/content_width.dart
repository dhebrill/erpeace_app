import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_spacing.dart';

/// Wraps page content so it stays readable on wide screens.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? AppConstants.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}

/// Page body with consistent horizontal padding.
class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      0,
      AppSpacing.lg,
      AppSpacing.xxxl,
    ),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: padding,
        child: ContentWidth(child: child),
      ),
    );
  }
}
