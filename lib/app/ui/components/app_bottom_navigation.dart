import 'package:sikshana/app/utils/exports.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({
    required this.currentRoute,
    required this.onItemSelected,
    required this.homeKey,
    required this.contentKey,
    required this.chatbotKey,
    required this.profileKey,
    super.key,
  });

  final String currentRoute;
  final ValueChanged<int> onItemSelected;
  final GlobalKey homeKey;
  final GlobalKey contentKey;
  final GlobalKey chatbotKey;
  final GlobalKey profileKey;

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  late final List<_NavItem> _items;
  late final double _averageScaleFactor;

  @override
  void initState() {
    super.initState();
    _items = <_NavItem>[
      _NavItem(
        icon: AppImages.homeIcon,
        label: LocaleKeys.home.tr,
        route: Routes.DASHBOARD,
      ),
      _NavItem(
        icon: AppImages.contentGenerationIcon,
        label: LocaleKeys.contentGeneration.tr,
        route: Routes.CONTENT_GENERATION,
      ),
      _NavItem(
        icon: AppImages.chatbotIcon,
        label: LocaleKeys.chatbot.tr,
        route: Routes.CHATBOT,
      ),
      _NavItem(
        icon: AppImages.profileIcon,
        label: LocaleKeys.profile.tr,
        route: Routes.PROFILE,
      ),
    ];
    _averageScaleFactor = _computeAverageScaleFactor();
  }

  double _computeAverageScaleFactor() {
    final double availableWidth = (Get.width / _items.length) - 16.w;
    final double baseFontSize = 12.sp;
    final TextStyle baseStyle = AppTextStyle.lato(fontSize: baseFontSize);

    final List<double> scaleFactors = <double>[];
    for (final _NavItem item in _items) {
      final TextPainter painter = TextPainter(
        text: TextSpan(text: item.label, style: baseStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      final double textWidth = painter.size.width;
      final double scale = textWidth > availableWidth
          ? availableWidth / textWidth
          : 1.0;

      scaleFactors.add(scale);
    }

    return scaleFactors.reduce((double a, double b) => a + b) /
        scaleFactors.length;
  }

  @override
  Widget build(BuildContext context) => Container(
    height: 65.h,
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: AppColors.k000000.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _items.asMap().entries.map((MapEntry<int, _NavItem> entry) {
        final int index = entry.key;
        final _NavItem item = entry.value;
        final bool isSelected = widget.currentRoute == item.route;

        final Key? itemKey = switch (index) {
          0 => widget.homeKey,
          1 => widget.contentKey,
          2 => widget.chatbotKey,
          3 => widget.profileKey,
          _ => null,
        };

        return _AnimatedNavItem(
          key: itemKey,
          item: item,
          isSelected: isSelected,
          scaleFactor: _averageScaleFactor,
          onTap: () => widget.onItemSelected(index),
        );
      }).toList(),
    ),
  );
}

class _AnimatedNavItem extends StatelessWidget {
  const _AnimatedNavItem({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.scaleFactor,
    required this.onTap,
  }) : super(key: key);

  final _NavItem item;
  final bool isSelected;
  final double scaleFactor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(milliseconds: 250);
    const Color selectedColor = AppColors.k46A0F1;
    const Color unselectedColor = AppColors.k84828A;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: duration,
              curve: Curves.easeOut,
              child: AnimatedSwitcher(
                duration: duration,
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        FadeTransition(opacity: animation, child: child),
                child: SvgPicture.asset(
                  item.icon,
                  key: ValueKey<bool>(isSelected),
                  height: 24.h,
                  width: 24.w,
                  colorFilter: ColorFilter.mode(
                    isSelected ? selectedColor : unselectedColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            4.verticalSpace,
            AnimatedDefaultTextStyle(
              duration: duration,
              curve: Curves.easeOut,
              style: AppTextStyle.lato(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.fade,
                textScaler: TextScaler.linear(scaleFactor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  _NavItem({required this.icon, required this.label, required this.route});
  final String icon;
  final String label;
  final String route;
}
