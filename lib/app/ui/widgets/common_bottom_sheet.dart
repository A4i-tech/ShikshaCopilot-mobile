import 'package:sikshana/app/utils/exports.dart';

class CommonBottomSheet extends StatelessWidget {
  const CommonBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.subTitle,
    this.height,
  });

  final String title;
  final String? subTitle;
  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) => Container(
    height: height ?? Get.height * 0.75,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate(
            height: subTitle != null ? 100 : 80,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: _buildHeader(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: child,
          ),
        ),
      ],
    ),
  );

  Widget _buildHeader() => Column(
    children: <Widget>[
      Container(
        width: 100.w,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.kEBEBEB,
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
      10.verticalSpace,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyle.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.kEBEBEB),
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.all(6.dg),
              child: const Icon(Icons.close),
            ),
            onTap: () => Get.back(),
          ),
        ],
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          subTitle!,
          style: AppTextStyle.lato(
            fontSize: 14.sp,
            color: AppColors.k6C7278,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
