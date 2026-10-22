import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder used by every loading state in ERPeace.
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Shimmer.fromColors(
      baseColor:
          baseColor ??
          (isLight ? const Color(0xFFE7EDED) : const Color(0xFF1D2729)),
      highlightColor:
          highlightColor ??
          (isLight ? const Color(0xFFF3F7F7) : const Color(0xFF283336)),
      child: child,
    );
  }
}

/// A single shimmering rounded rectangle.
class AppShimmerBox extends StatelessWidget {
  const AppShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Shimmer skeleton shaped like a list card.
class AppShimmerList extends StatelessWidget {
  const AppShimmerList({super.key, this.itemCount = 6, this.itemHeight = 92});

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => AppShimmer(
        child: Container(
          height: itemHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
