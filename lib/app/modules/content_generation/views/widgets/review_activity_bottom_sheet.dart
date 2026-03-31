import 'package:sikshana/app/ui/widgets/common_bottom_sheet.dart';
import 'package:sikshana/app/utils/exports.dart';
import 'package:get/get.dart';

/// A bottom sheet for reviewing and rating an activity.
///
/// This bottom sheet allows the user to provide feedback on an activity,
/// including whether it was performed, and to give it a rating.
class ReviewActivityBottomSheet extends StatefulWidget {
  /// The ID of the activity to be reviewed.
  final String activityId;

  /// Creates a new [ReviewActivityBottomSheet].
  const ReviewActivityBottomSheet({required this.activityId, super.key});

  @override
  State<ReviewActivityBottomSheet> createState() =>
      _ReviewActivityBottomSheetState();
}

class _ReviewActivityBottomSheetState extends State<ReviewActivityBottomSheet> {
  bool _activityPerformed = true;
  double _rating = 0;

  // Performed activity selections with default values
  String? _studentEngagement = 'Motivated';
  String? _learningOutcomeAlignment = 'Strong Alignment';
  String? _realWorldApplication = 'Relevant';

  // Not performed reason with default value
  String? _notPerformedReason = 'Time Constraints';

  @override
  Widget build(BuildContext context) => CommonBottomSheet(
    title: LocaleKeys.rateActivity.tr,
    subTitle: LocaleKeys.evaluateTheActivity.tr,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildActivityPerformedSection(),
              20.verticalSpace,
              if (_activityPerformed) _buildPerformedDetails(),
              if (!_activityPerformed) _buildNotPerformedDetails(),
            ],
          ),
        ),
        20.verticalSpace,
        _buildOverallRating(),
        20.verticalSpace,
        AppButton(
          buttonText: LocaleKeys.submitRating.tr,
          onPressed: _submitRating,
          buttonColor: AppColors.k46A0F1,
          borderRadius: BorderRadius.circular(4),
          height: 50.h,
        ),
      ],
    ),
  );

  /// Submits the rating for the activity.
  ///
  /// This method gets the [LessonResourceGeneratedViewController], prepares the
  /// rating data, and calls the `addRatingForActivity` method.
  void _submitRating() async {
    final lessonResourceController =
        Get.find<LessonResourceGeneratedViewController>();

    const String resourceId = 'activities'; // constant as per your payload

    final bool performed = _activityPerformed;
    final String? engagement = _studentEngagement;
    // Remove ' Alignment' suffix to match backend expected values
    final String? alignment = _learningOutcomeAlignment?.replaceAll(
      ' Alignment',
      '',
    );
    final String? application = _realWorldApplication;
    final int stars = _rating.toInt();
    final String? notPerformedReason = _notPerformedReason;

    await lessonResourceController.addRatingForActivity(
      resourceId: resourceId,
      activityId: widget.activityId,
      performed: performed,
      engagement: performed ? engagement : null,
      alignment: performed ? alignment : null,
      application: performed ? application : null,
      stars: performed ? stars : null,
      notPerformedReason: performed ? null : notPerformedReason,
    );
  }

  /// Builds the section for selecting whether the activity was performed.
  Widget _buildActivityPerformedSection() => _buildSection(
    title: 'Activity performed?',
    children: <Widget>[
      _buildToggleButton('Yes', _activityPerformed, () {
        setState(() {
          _activityPerformed = true;
          _notPerformedReason = 'Time Constraints';
          _studentEngagement ??= 'Motivated';
          _learningOutcomeAlignment ??= 'Strong Alignment';
          _realWorldApplication ??= 'Relevant';
        });
      }),
      10.horizontalSpace,
      _buildToggleButton('No', !_activityPerformed, () {
        setState(() {
          _activityPerformed = false;
        });
      }),
    ],
  );

  /// Builds the section for providing details when the activity was performed.
  Widget _buildPerformedDetails() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _buildSection(
        title: 'Student Engagement:',
        children: <Widget>[
          _buildChoiceChip(
            'Distracted',
            selected: _studentEngagement == 'Distracted',
            onTap: () => setState(() => _studentEngagement = 'Distracted'),
          ),
          _buildChoiceChip(
            'Motivated',
            selected: _studentEngagement == 'Motivated',
            onTap: () => setState(() => _studentEngagement = 'Motivated'),
          ),
          _buildChoiceChip(
            'Interactive',
            selected: _studentEngagement == 'Interactive',
            onTap: () => setState(() => _studentEngagement = 'Interactive'),
          ),
        ],
      ),
      20.verticalSpace,
      _buildSection(
        title: 'Alignment with Learning Outcome:',
        children: <Widget>[
          _buildChoiceChip(
            'Not Aligned',
            selected: _learningOutcomeAlignment == 'Not Aligned',
            onTap: () =>
                setState(() => _learningOutcomeAlignment = 'Not Aligned'),
          ),
          _buildChoiceChip(
            'Partial',
            selected: _learningOutcomeAlignment == 'Partial',
            onTap: () => setState(() => _learningOutcomeAlignment = 'Partial'),
          ),
          _buildChoiceChip(
            'Strong Alignment',
            selected: _learningOutcomeAlignment == 'Strong Alignment',
            onTap: () =>
                setState(() => _learningOutcomeAlignment = 'Strong Alignment'),
          ),
        ],
      ),
      20.verticalSpace,
      _buildSection(
        title: 'Real-world Application',
        children: <Widget>[
          _buildChoiceChip(
            'Not Relevant',
            selected: _realWorldApplication == 'Not Relevant',
            onTap: () => setState(() => _realWorldApplication = 'Not Relevant'),
          ),
          _buildChoiceChip(
            'Not Applicable',
            selected: _realWorldApplication == 'Not Applicable',
            onTap: () =>
                setState(() => _realWorldApplication = 'Not Applicable'),
          ),
          _buildChoiceChip(
            'Relevant',
            selected: _realWorldApplication == 'Relevant',
            onTap: () => setState(() => _realWorldApplication = 'Relevant'),
          ),
        ],
      ),
    ],
  );

  /// Builds the section for providing a reason when the activity was not performed.
  Widget _buildNotPerformedDetails() => _buildSection(
    title: 'Select Reason',
    children: <Widget>[
      _buildChoiceChip(
        'Not Suitable',
        selected: _notPerformedReason == 'Not Suitable',
        onTap: () => setState(() => _notPerformedReason = 'Not Suitable'),
      ),
      _buildChoiceChip(
        'Time Constraints',
        selected: _notPerformedReason == 'Time Constraints',
        onTap: () => setState(() => _notPerformedReason = 'Time Constraints'),
      ),
      _buildChoiceChip(
        'Resources Unavailable',
        selected: _notPerformedReason == 'Resources Unavailable',
        onTap: () =>
            setState(() => _notPerformedReason = 'Resources Unavailable'),
      ),
    ],
  );

  /// Builds the section for the overall rating.
  Widget _buildOverallRating() => _buildSection(
    borderRequired: true,
    title: 'Overall Rating',
    children: <Widget>[
      Row(
        children: List.generate(
          5,
          (int index) => IconButton(
            icon: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: index < _rating ? AppColors.kFFC700 : AppColors.kB0B0B0,
              size: 28.dg,
            ),
            onPressed: () {
              setState(() {
                _rating = index + 1.0;
              });
            },
          ),
        ),
      ),
    ],
    isRow: false,
  );

  /// Builds a section with a title and children.
  Widget _buildSection({
    required String title,
    required List<Widget> children,
    bool isRow = true,
    bool borderRequired = false,
  }) => Container(
    padding: !borderRequired ? null : const EdgeInsets.all(16),
    decoration: !borderRequired
        ? null
        : BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: AppTextStyle.lato(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        10.verticalSpace,
        if (isRow)
          Wrap(spacing: 10, runSpacing: 10, children: children)
        else
          ...children,
      ],
    ),
  );

  /// Builds a toggle button.
  Widget _buildToggleButton(
    String text,
    bool isSelected,
    VoidCallback onPressed,
  ) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      backgroundColor: isSelected ? AppColors.kEDF6FE : Colors.white,
      side: BorderSide(
        color: isSelected ? AppColors.k46A0F1 : AppColors.kEBEBEB,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8).r),
    ),
    child: Text(
      text,
      style: AppTextStyle.lato(
        fontSize: 12.sp,
        color: isSelected ? AppColors.k46A0F1 : AppColors.k171A1F,
      ),
    ),
  );

  /// Builds a choice chip.
  Widget _buildChoiceChip(
    String label, {
    required VoidCallback onTap,
    bool selected = false,
  }) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      backgroundColor: selected ? AppColors.kEDF6FE : Colors.white,
      side: BorderSide(color: selected ? AppColors.k46A0F1 : AppColors.kEBEBEB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8).r),
    ),
    child: Text(
      label,
      style: AppTextStyle.lato(
        color: selected ? AppColors.k46A0F1 : AppColors.k171A1F,
        fontSize: 12.sp,
      ),
    ),
  );
}
