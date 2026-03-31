import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a grid pattern as a background.
///
/// This widget uses a [CustomPaint] with a [GridPainter] to draw a grid
/// over a specified background color. The grid lines' color, spacing,
/// and stroke width are customizable.
class GridBackground extends StatelessWidget {
  /// Creates a [GridBackground] widget.
  ///
  /// Parameters:
  /// - `key`: An optional key for this widget.
  /// - `backgroundColor`: The background color of the container.
  ///   Defaults to [AppColors.k46A0F1].
  /// - `gridColor`: The color of the grid lines.
  ///   Defaults to [AppColors.kFFFFFF].
  /// - `gridSpacing`: The spacing between grid lines in logical pixels.
  ///   Defaults to 60.0.
  /// - `strokeWidth`: The width of the grid lines.
  ///   Defaults to 1.0.
  const GridBackground({
    super.key,
    this.backgroundColor = AppColors.k46A0F1,
    this.gridColor = AppColors.kFFFFFF,
    this.gridSpacing = 60.0,
    this.strokeWidth = 1.0,
  });

  /// The background color of the container.
  final Color backgroundColor;

  /// The color of the grid lines.
  final Color gridColor;

  /// The spacing between grid lines.
  final double gridSpacing;

  /// The width of the grid lines.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => Container(
    color: backgroundColor,
    child: CustomPaint(
      painter: GridPainter(
        gridColor: gridColor,
        gridSpacing: gridSpacing,
        strokeWidth: strokeWidth,
      ),
      child: const SizedBox.expand(),
    ),
  );
}

/// A custom painter responsible for drawing grid lines on a canvas.
///
/// This painter draws horizontal and vertical lines based on the provided
/// grid color, spacing, and stroke width.
class GridPainter extends CustomPainter {
  /// Creates a [GridPainter] instance.
  ///
  /// Parameters:
  /// - `gridColor`: The color to use for the grid lines.
  /// - `gridSpacing`: The distance between each grid line.
  /// - `strokeWidth`: The thickness of the grid lines.
  GridPainter({
    required this.gridColor,
    required this.gridSpacing,
    required this.strokeWidth,
  });

  /// The color of the grid lines.
  final Color gridColor;

  /// The spacing between grid lines.
  final double gridSpacing;

  /// The width of the grid lines.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = gridColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
      oldDelegate.gridColor != gridColor ||
      oldDelegate.gridSpacing != gridSpacing ||
      oldDelegate.strokeWidth != strokeWidth;
}
