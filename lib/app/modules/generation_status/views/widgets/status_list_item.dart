import 'package:intl/intl.dart';
import 'package:sikshana/app/modules/generation_status/models/generation_status_model.dart'
    as gsm;
import 'package:sikshana/app/utils/exports.dart';

class StatusListItem extends StatelessWidget {
  const StatusListItem({required this.item, super.key});

  final gsm.Datum item;

  @override
  Widget build(BuildContext context) {
    final bool isRunning =
        item.status?.toLowerCase().contains('running') ?? false;
    final bool isFailed = item.status?.toLowerCase().contains('failed') ?? true;
    final Color statusColor = isRunning
        ? AppColors.kFFC11E
        : isFailed
        ? AppColors.kDE3B40
        : AppColors.k3FBB53;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10).r,
        border: Border.all(color: AppColors.k000000.withOpacity(0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.kA062F7.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: AppColors.kA062F7,
                    size: 24.sp,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${isRunning
                          ? LocaleKeys.initiatedOn.tr
                          : isFailed
                          ? LocaleKeys.lastUpdatedOn.tr
                          : LocaleKeys.generatedOn.tr}: '
                      '${item.createdAt != null ? DateFormat.yMMMd().format(item.createdAt!) : 'N/A'}',
                      style: AppTextStyle.lato(
                        color: Colors.grey.shade600,
                        fontSize: 12.sp,
                      ),
                    ),
                    4.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: <Widget>[
                          if (isRunning)
                            SizedBox(
                              width: 12.w,
                              height: 12.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                value: 75,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFF7B500),
                                ),
                              ),
                            ),
                          if (isFailed)
                            Icon(
                              Icons.cancel_outlined,
                              color: AppColors.kFFFFFF,
                              size: 12.h,
                            ),
                          if (!isRunning && !isFailed)
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: AppColors.kFFFFFF,
                              size: 12.h,
                            ),
                          8.horizontalSpace,
                          Text(
                            isRunning
                                ? LocaleKeys.running.tr
                                : isFailed
                                ? LocaleKeys.failed.tr
                                : LocaleKeys.regenerated.tr,
                            style: AppTextStyle.lato(
                              color: AppColors.kFFFFFF,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            16.verticalSpace,
            Text(
              '${LocaleKeys.subject.tr}: ${item.lesson?.subjects?.name ?? 'N/A'}',
              style: AppTextStyle.lato(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            12.verticalSpace,
            Row(
              children: <Widget>[
                _buildChip(
                  '${LocaleKeys.classKey.tr} ${item.lesson?.lessonClass ?? 'N/A'}',
                  AppColors.kF1F4FD,
                  AppColors.k4069E5,
                ),
                8.horizontalSpace,
                _buildChip(
                  item.isLesson!
                      ? LocaleKeys.lessonPlan.tr
                      : LocaleKeys.lessonResourceKey.tr,
                  AppColors.kFDF2F2,
                  AppColors.kDE3B40,
                ),
              ],
            ),
            12.verticalSpace,
            Text(
              '${LocaleKeys.chapter.tr}: ${item.lesson?.chapter?.topics ?? 'N/A'}',
              style: AppTextStyle.lato(
                color: Colors.grey.shade700,
                fontSize: 12.sp,
              ),
            ),
            8.verticalSpace,
            Row(
              children: <Widget>[
                Text(
                  '${LocaleKeys.subTopic.tr} : ',
                  style: AppTextStyle.lato(
                    color: Colors.grey.shade700,
                    fontSize: 12.sp,
                  ),
                ),
                if (item.lesson?.subTopics?.isNotEmpty == true)
                  Flexible(
                    child: _buildChip(
                      item.lesson!.subTopics!.first,
                      AppColors.kF1FDF3,
                      AppColors.k3D8248,
                    ),
                  )
                else
                  Text(
                    'N/A',
                    style: AppTextStyle.lato(
                      color: Colors.grey.shade700,
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color backgroundColor, Color textColor) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: AppTextStyle.lato(color: textColor, fontSize: 12.sp),
        ),
      );
}
