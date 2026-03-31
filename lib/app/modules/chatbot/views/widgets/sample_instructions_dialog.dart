import 'package:sikshana/app/utils/exports.dart';

/// A dialog that displays sample instructions for chatbot interaction.
///
/// This dialog presents a categorized list of sample prompts that users
/// can use to interact with the chatbot, helping them understand its capabilities.
class SampleInstructionsDialog extends StatelessWidget {
  /// Creates a new [SampleInstructionsDialog].
  const SampleInstructionsDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    child: SizedBox(
      height: Get.height * 0.80,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () => Get.back(),
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                5.horizontalSpace,
                Text(
                  'Sample Instructions',
                  style: AppTextStyle.lato(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            15.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildSection('Science', <String>[
                      'Incorporate a real-world scenario involving the use of reflective surfaces in everyday life, such as car mirrors or solar panels.',
                      'Add an experiment involving the use of mirrors to study the reflection of light, including practical applications of redirecting light using mirrors.',
                      'Include questions about the different types of asexual reproduction in plants, such as budding and fragmentation.',
                      'Suggest an activity where students compare the motion of different objects, such as a rolling ball and a sliding book, and analyze the factors affecting their speeds.',
                      'Introduce an experiment demonstrating the reaction of metals with acids, highlighting the production of hydrogen gas.',
                    ]),
                    20.verticalSpace,
                    _buildSection('Social Science', <String>[
                      'Add a discussion on the role of media in elections and how it influences public opinion.',
                      'Examine the principles of administration, foreign policy, and financial management in the Arthashastra and their application in the Mauryan and Kushan empires, including the roles of spies, the military system, and tax collection.',
                      'Discuss the historical transition from monarchies to democracies and its impact on decision-making in societies, using examples from the chapter.',
                      'Suggest students create a project on the role of government policies in shaping land use and agricultural development in India.',
                      'Compare the social structures and economic activities of urban, rural, and tribal communities, highlighting the impact of industrialization and urbanization.',
                    ]),
                    20.verticalSpace,
                    _buildSection('Mathematics', <String>[
                      'Suggest hands-on activities using materials like cardboard, string, or sticks to explore the properties of isosceles and equilateral triangles.',
                      'Add an experiment where students create and test the stability of different triangular structures using materials like straws or sticks.\n\nDesign interactive activities for both small and large groups that involve solving percentage problems through collaborative and competitive tasks.',
                      'Propose a real-world application where students calculate the area of an irregularly shaped plot of land using Heron\'s Formula, emphasizing the importance of accurate measurements.',
                      'Include MCQs that test understanding of the derivation of Heron\'s formula.',
                      'Include an explanation of the Pythagorean Theorem and its application in right triangles.',
                    ]),
                    20.verticalSpace,
                    _buildSection('English', <String>[
                      'Analyze the character traits of a merciful person based on the poem. How do these traits compare to those of a just person?',
                      'Write a paragraph about your favorite hobby using at least five adjectives. Highlight the adjectives.',
                      'Create ten sentences using different tenses (past, present, and future).',
                      'Write a four-line poem about your best friend.',
                      'Write a poem about your favorite season. Use vivid imagery to describe the sights, sounds, and feelings it evokes.',
                      'Suggest an activity to discuss personal experiences with insects that connect with the poem "The Fly."',
                    ]),
                  ],
                ),
              ),
            ),
            15.verticalSpace,
            Align(
              alignment: Alignment.bottomRight,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 10.h,
                  ),
                  side: BorderSide(color: AppColors.k46A0F1.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Back',
                  style: AppTextStyle.lato(
                    color: AppColors.k46A0F1,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  /// Builds a section within the dialog with a given [title] and list of [instructions].
  ///
  /// Each instruction is displayed as a numbered list item.
  ///
  /// Parameters:
  /// - [title]: The title of the section (e.g., 'Science', 'Mathematics').
  /// - [instructions]: A list of strings, where each string is an instruction.
  ///
  /// Returns a [Widget] representing the section.
  Widget _buildSection(String title, List<String> instructions) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: AppTextStyle.lato(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
      10.verticalSpace,
      Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: instructions.length,
          separatorBuilder: (BuildContext context, int index) =>
              15.verticalSpace,
          itemBuilder: (BuildContext context, int index) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${index + 1}. ',
                style: AppTextStyle.lato(
                  fontSize: 14.sp,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Expanded(
                child: Text(
                  instructions[index],
                  style: AppTextStyle.lato(
                    fontSize: 14.sp,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
