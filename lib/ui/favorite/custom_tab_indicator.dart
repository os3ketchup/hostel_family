import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';

class CustomTabIndicator extends Decoration {
  const CustomTabIndicator({required this.mThem});

  final ThemeData mThem;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return CustomPainter(this,mThem);
  }
}

class CustomPainter extends BoxPainter {
  CustomPainter(this.decoration, this.mThem);

  final CustomTabIndicator decoration;
  final ThemeData mThem;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint()
      ..color = mThem.colorScheme.primary // Customize color if needed
      ..style = PaintingStyle.fill;

    // Calculate indicator width to cover half of the screen
    final indicatorWidth = 300.w;

    // Paint the indicator
    // Calculate indicator height
    const indicatorHeight = 3;
    // Calculate indicator border radius
    const indicatorBorderRadius = Radius.circular(indicatorHeight / 2);

    // Paint the indicator with rounded corners
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          offset.dx + (rect.width - indicatorWidth) / 2,
          offset.dy + rect.height - indicatorHeight,
          // Adjust the height of the indicator
          indicatorWidth,
          indicatorHeight.toDouble(),
        ),
        topLeft: indicatorBorderRadius,
        topRight: indicatorBorderRadius,
        bottomLeft: indicatorBorderRadius,
        bottomRight: indicatorBorderRadius,
      ),
      paint,
    );
  }
}
