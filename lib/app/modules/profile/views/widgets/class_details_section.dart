import 'package:sikshana/app/utils/exports.dart';
import 'package:sikshana/app/modules/profile/views/widgets/class_detail_card.dart';

/// A widget that displays the class details section of the user's profile.
class ClassDetailsSection extends GetView<ProfileController> {
  ///Creates new [ClassDetailsSection]
  const ClassDetailsSection({super.key});

  @override
  /// Builds the UI for the class details section.
  ///
  /// This method uses a [ListView.builder] to display a list of [ClassDetailCard]
  /// widgets, each representing a class detail entry.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying the list of class details.
  Widget build(BuildContext context) => Obx(
    () => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.classDetails.length,
      itemBuilder: (BuildContext context, int index) => ClassDetailCard(
        classDetail: controller.classDetails[index],
        index: index,
      ),
    ),
  );
}
