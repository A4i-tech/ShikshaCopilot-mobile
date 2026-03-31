import 'package:sikshana/app/utils/exports.dart';

/// An animated three-dot loading indicator.
///
/// This widget displays three pulsating dots to indicate a loading state.
class ThreeDotsLoader extends StatefulWidget {
  /// Creates a new [ThreeDotsLoader].
  ///
  /// The [size] parameter determines the overall size of the loader.
  const ThreeDotsLoader({super.key, this.size = 25});

  /// The size of the loader.
  ///
  /// This value is used to determine the size of each individual dot.
  final double size;

  @override
  State<ThreeDotsLoader> createState() => _ThreeDotsLoaderState();
}

class _ThreeDotsLoaderState extends State<ThreeDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation1 = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.5), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _animation2 = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.5), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: 25),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _animation3 = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.5), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1), weight: 25),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ScaleTransition(scale: _animation1, child: _buildDot()),
      const SizedBox(width: 5),
      ScaleTransition(scale: _animation2, child: _buildDot()),
      const SizedBox(width: 5),
      ScaleTransition(scale: _animation3, child: _buildDot()),
    ],
  );

  /// Builds a single circular dot for the loader.
  ///
  /// The size and color of the dot are determined by the parent widget's properties.
  ///
  /// Returns a [Widget] representing a single dot.
  Widget _buildDot() => Container(
    width: widget.size / 3,
    height: widget.size / 3,
    decoration: const BoxDecoration(
      color: AppColors.k46A0F1,
      shape: BoxShape.circle,
    ),
  );
}
