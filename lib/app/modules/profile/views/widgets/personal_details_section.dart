import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays the personal details section of the user's profile.
class PersonalDetailsSection extends GetView<ProfileController> {
  ///Creates new [PersonalDetailsSection]
  const PersonalDetailsSection({super.key});

  @override
  /// Builds the UI for the personal details section.
  ///
  /// This method uses [ProfileTextField] widgets to display user information
  /// such as name, phone, school, state, zone, district, and taluk.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying the personal details form fields.
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // Name and Phone
      Row(
        children: <Widget>[
          Expanded(
            child: ProfileTextField(
              label: LocaleKeys.name.tr,
              name: 'name',
              enabled: false,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: ProfileTextField(
              label: LocaleKeys.phone.tr,
              name: 'phone',
              keyboardType: TextInputType.phone,
              enabled: false,
            ),
          ),
        ],
      ),
      16.verticalSpace,
      // School/Organization
      ProfileTextField(
        label: LocaleKeys.schoolOrganization.tr,
        name: 'school',
        enabled: false,
      ),
      16.verticalSpace,
      // State and Zone
      Row(
        children: <Widget>[
          Expanded(
            child: ProfileTextField(
              label: LocaleKeys.state.tr,
              name: 'state',
              enabled: false,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: ProfileTextField(
              label: LocaleKeys.zone.tr,
              name: 'zone',
              enabled: false,
            ),
          ),
        ],
      ),
      16.verticalSpace,
      // District and Taluk
      Row(
        children: <Widget>[
          Expanded(
            child: ProfileTextField(
              label: LocaleKeys.district.tr,
              name: 'district',
              enabled: false,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: ProfileTextField(
              label: LocaleKeys.taluk.tr,
              name: 'taluk',
              enabled: false,
            ),
          ),
        ],
      ),
    ],
  );
}
