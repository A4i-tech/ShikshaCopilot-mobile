import 'package:sikshana/app/modules/profile/models/resource_ui_model.dart';
import 'package:sikshana/app/modules/profile/views/widgets/chip_input_text_field.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the resources section of the user's profile.
class ResourcesSection extends GetView<ProfileController> {
  /// Constructs a [ResourcesSection].
  const ResourcesSection({super.key});

  @override
  /// Builds the UI for the resources section.
  ///
  /// This method uses a [ListView.separated] to display a list of resource items.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying the list of resources.
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Obx(
        () => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.resources.length,
          itemBuilder: (BuildContext context, int index) => _buildResourceItem(
            controller.resources[index],
            index,
            key: ObjectKey(controller.resources[index]),
            isLast: controller.resources.length == index + 1,
          ),
          separatorBuilder: (BuildContext context, int index) =>
              16.verticalSpace,
        ),
      ),
    ],
  );

  /// Builds a single resource item card.
  ///
  /// Parameters:
  /// - `resource`: The resource UI model.
  /// - `index`: The index of the resource item.
  /// - `key`: The key for the widget.
  /// - `isLast`: Whether this is the last item in the list.
  ///
  /// Returns:
  /// A `Widget` representing a single resource item.
  Widget _buildResourceItem(
    ResourceUIModel resource,
    int index, {
    Key? key,
    bool isLast = false,
  }) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.kEBEBEB),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Column(
      key: key,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Obx(
                () => Column(
                  children: <Widget>[
                    AppDropdown(
                      label: LocaleKeys.resourceType.tr,
                      name: 'resourceType_$index',
                      value: resource.type.value,
                      items: controller.resourceTypeOptions.toList(),
                      hintText: LocaleKeys.resourceTypeRequired.tr,
                      onChanged: (String? val) {
                        if (val != null) {
                          resource.type.value = val;
                          resource.detail.clear();
                          // Also update the form state to clear details
                          controller.formKey.currentState
                              ?.patchValue(<String, dynamic>{
                                'resourceDetails_$index': <String>[],
                                'resourceOtherType_$index': null,
                              });
                        }
                      },
                    ),
                    16.verticalSpace,
                    if (resource.type.value == 'Others')
                      Column(
                        children: <Widget>[
                          ProfileTextField(
                            label: LocaleKeys.resourceType.tr,
                            name: 'resourceOtherType_$index',
                            validator: (String? val) =>
                                (val?.trim().isEmpty ?? true)
                                ? 'Required'
                                : null,
                          ),
                          16.verticalSpace,
                          ChipInputTextField(
                            label: LocaleKeys.resourceDetails.tr,
                            name: 'resourceDetails_$index',
                            hintText: 'Enter resource details',
                            initialValue: resource.detail.toList(),
                            onChanged: (List<String> val) {
                              resource.detail.assignAll(val);
                            },
                          ),
                        ],
                      )
                    else
                      ProfileMultiSelectDropdown(
                        label: LocaleKeys.resourceDetails.tr,
                        name: 'resourceDetails_$index',
                        items: resource.type.value != null
                            ? controller.resourceDetailsOptions[resource
                                      .type
                                      .value] ??
                                  <String>[]
                            : <String>[],
                        hintText: LocaleKeys.selectDetails.tr,
                        isMultiSelection: true,
                        onChanged: (List<String>? val) {
                          if (val != null) {
                            resource.detail.assignAll(val);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            10.horizontalSpace,
            // Show delete only if more than 1 resource exists
            if (controller.resources.length > 1)
              SizedBox(
                height: 45.h,
                child: IconButton(
                  onPressed: () => controller.removeResource(index),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.kDE1A1A,
                  ),
                ),
              ),
          ],
        ),

        if (isLast) ...<Widget>[
          16.verticalSpace,
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 95.w,
              child: AppButton(
                buttonText: LocaleKeys.add.tr,
                iconSpacing: 2,
                style: AppTextStyle.lato(
                  fontSize: 14.sp,
                  color: AppColors.kFFFFFF,
                ),
                onPressed: controller.addResource,
                buttonColor: AppColors.k46A0F1,
                icon: Icon(Icons.add, color: AppColors.kFFFFFF, size: 16.dg),
                borderRadius: BorderRadius.circular(4.r),
                height: 40.h,
              ),
            ),
          ),
        ],
      ],
    ).paddingSymmetric(vertical: 24.h, horizontal: 16.w),
  );
}
