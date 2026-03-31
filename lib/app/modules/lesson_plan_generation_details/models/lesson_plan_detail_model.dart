import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A model class that represents the details of a lesson plan.
class LessonPlanDetailModel {

  /// Creates a [LessonPlanDetailModel] object.
  LessonPlanDetailModel({
    String? board,
    String? medium,
    String? className,
    String? subject,
    String? boysStrength,
    String? girlsStrength,
  }) : board = (board ?? '').obs,
       medium = (medium ?? '').obs,
       className = (className ?? '').obs,
       subject = (subject ?? '').obs,
       boysStrengthController = TextEditingController(text: boysStrength ?? ''),
       girlsStrengthController = TextEditingController(
         text: girlsStrength ?? '',
       );
  /// The board for which the lesson plan is intended.
  final RxString board;
  /// The medium of instruction for the lesson plan.
  final RxString medium;
  /// The class for which the lesson plan is intended.
  final RxString className;
  /// The subject for which the lesson plan is intended.
  final RxString subject;
  /// The controller for the boys' strength text field.
  final TextEditingController boysStrengthController;
  /// The controller for the girls' strength text field.
  final TextEditingController girlsStrengthController;
}
