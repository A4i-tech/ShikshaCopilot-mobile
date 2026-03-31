import 'package:shimmer/shimmer.dart';
import 'package:sikshana/app/modules/generation_status/models/generation_status_model.dart'
    as gsm;
import 'package:sikshana/app/modules/generation_status/views/widgets/status_list_item.dart';
import 'package:sikshana/app/modules/generation_status/views/widgets/no_items_found.dart';
import 'package:sikshana/app/utils/exports.dart';

class StatusList extends GetView<GenerationStatusController> {
  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isLoading.value) {
      return Shimmer.fromColors(
        baseColor: AppColors.kE0E0E0,
        highlightColor: AppColors.kF5F5F5,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.kFFFFFF,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      );
    } else if (controller.generationStatusList.isEmpty) {
      return const NoItemsFoundWidget();
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.generationStatusList.length,
        itemBuilder: (BuildContext context, int index) {
          final gsm.Datum item = controller.generationStatusList[index];
          return StatusListItem(item: item);
        },
      );
    }
  });
}
