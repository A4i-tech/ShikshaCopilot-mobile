import 'package:flutter/cupertino.dart';
import 'package:sikshana/app/modules/profile/views/widgets/language_dropdown.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the profile photo section, including the user's
/// profile image, name, and language selection.
class ProfilePhotoSection extends StatelessWidget {
  ///Creates new [ProfilePhotoSection]
  const ProfilePhotoSection({super.key});

  @override
  /// Builds the UI for the profile photo section.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying the profile photo, name, and language dropdown.
  Widget build(BuildContext context) => GetBuilder<ProfileController>(
    init: ProfileController(), // Initialize if not already registered
    builder: (ProfileController controller) => Column(
      children: <Widget>[
        const SizedBox(width: double.infinity),
        Obx(
          () => Hero(
            tag: 'profileImage',
            child: ProfileImageCircle(
              radius: 50.r,
              canEdit: true,
              onTapEdit: () => _showImageOptions(context, controller),
              userInitials: controller.extractInitials(
                controller.profile.value.data?.name ??
                    UserProvider.currentUser?.name ??
                    '',
              ),
              imagePath:
                  controller.profileImage.value?.path ??
                  controller.profile.value.data?.profileImage,
              icon: CupertinoIcons.person,
              backgroundColor: AppColors.kED7D2D,
            ),
          ),
        ),
        12.verticalSpace,
        Obx(
          () => Text(
            controller.profile.value.data?.name ??
                UserProvider.currentUser?.name ??
                '',
            style: AppTextStyle.lato(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        24.verticalSpace,
        // Language
        Obx(
          () => LanguageDropdown(
            name: 'language',
            items: controller.languages,
            hintText: LocaleKeys.selectPreferredLanguage.tr,
            onChanged: controller.isLoading()
                ? null
                : (String? value) {
                    if (value != null && value != Get.locale?.languageCode) {
                      Get.dialog(
                        AlertDialog(
                          title: Text(
                            LocaleKeys.confirm.tr,
                            style: AppTextStyle.lato(),
                          ),
                          content: Text(
                            '${LocaleKeys.areYouSureSwitchLanguage.tr}?',
                            style: AppTextStyle.lato(),
                          ),
                          actions: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                  child: AppButton(
                                    buttonText: LocaleKeys.cancel.tr,
                                    onPressed: () {
                                      controller.changeLanguage(
                                        newLocale: value,
                                        didChange: false,
                                      );
                                    },
                                    buttonColor: AppColors.kFFFFFF,
                                    buttonTextColor: AppColors.k46A0F1,
                                  ),
                                ),
                                20.horizontalSpace,
                                Flexible(
                                  child: AppButton(
                                    buttonText: LocaleKeys.ok.tr,
                                    onPressed: () {
                                      controller.changeLanguage(
                                        newLocale: value,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
          ),
        ),
      ],
    ),
  );

  void _showImageOptions(BuildContext context, controller) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: Text(LocaleKeys.chooseImage.tr),
                onTap: () {
                  Get.back();
                  controller.pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(LocaleKeys.remove.tr),
                onTap: () {
                  Get.back();
                  controller.removeProfilePicture();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
