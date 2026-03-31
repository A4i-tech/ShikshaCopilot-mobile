import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/ui/widgets/custom_radio_group.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A view for configuring the details of a question paper.
class ConfigurationView extends StatefulWidget {
  /// Constructs a [ConfigurationView].
  const ConfigurationView({super.key});

  @override
  State<ConfigurationView> createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView>
    with AutomaticKeepAliveClientMixin<ConfigurationView> {
  @override
  bool get wantKeepAlive => true;

  QuestionPaperController get controller => Get.find<QuestionPaperController>();

  @override
  /// Builds the UI for the configuration view.
  ///
  /// This method uses a [FormBuilder] to create a form for collecting
  /// details such as board, medium, class, subject, examination name,
  /// total marks, and question paper scope.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the configuration form.
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: FormBuilder(
        key: controller.configurationFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10).r,
                  side: BorderSide(color: AppColors.k000000.withOpacity(0.1)),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Step 1/3: ${LocaleKeys.questionPaperKey.tr} ${LocaleKeys.configuration.tr}',
                    style: AppTextStyle.lato(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    LocaleKeys.configurethequestionpapertypehere.tr,
                    style: AppTextStyle.lato(
                      fontSize: 12.sp,
                      color: AppColors.k141522.withOpacity(0.45),
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Obx(
                          () => AppDropdown(
                            validator: (String? value) {
                              if (value?.isEmpty ?? true) {
                                return LocaleKeys.boardIsRequired.tr;
                              }
                              return null;
                            },
                            label: LocaleKeys.board.tr,
                            name: 'board',
                            hintText: LocaleKeys.selectBoard.tr,
                            items: controller.boards
                                .map(
                                  (String e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e, style: AppTextStyle.lato()),
                                  ),
                                )
                                .toList(),
                            onChanged: controller.onBoardChanged,
                            value: controller.selectedBoard.value,
                          ),
                        ),
                      ),
                      6.horizontalSpace,
                      Expanded(
                        child: Obx(
                          () => AppDropdown(
                            validator: (String? value) {
                              if (value?.isEmpty ?? true) {
                                return LocaleKeys.mediumIsRequired.tr;
                              }
                              return null;
                            },
                            label: LocaleKeys.medium.tr,
                            name: 'medium',
                            hintText: LocaleKeys.selectMedium.tr,
                            items: controller.mediums
                                .map(
                                  (String e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e, style: AppTextStyle.lato()),
                                  ),
                                )
                                .toList(),
                            onChanged: controller.onMediumChanged,
                            value: controller.selectedMedium.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Obx(
                          () => AppDropdown(
                            validator: (String? value) {
                              if (value?.isEmpty ?? true) {
                                return LocaleKeys.classIsRequired.tr;
                              }
                              return null;
                            },
                            label: LocaleKeys.classKey.tr,
                            name: 'class',
                            hintText: LocaleKeys.selectClass.tr,
                            items: controller.classes
                                .map(
                                  (String e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e, style: AppTextStyle.lato()),
                                  ),
                                )
                                .toList(),
                            onChanged: controller.onClassChanged,
                            onClear: controller.selectedClass() == null
                                ? null
                                : () {
                                    controller.configurationFormKey.currentState
                                        ?.patchValue(<String, dynamic>{
                                          'class': null,
                                        });
                                    controller.onClassChanged(null);
                                  },
                            value: controller.selectedClass.value,
                          ),
                        ),
                      ),
                      6.horizontalSpace,
                      Expanded(
                        child: Obx(
                          () => AppDropdown(
                            validator: (String? value) {
                              if (value?.isEmpty ?? true) {
                                return LocaleKeys.subjectIsRequired.tr;
                              }
                              return null;
                            },
                            label: LocaleKeys.subject.tr,
                            name: 'subject',
                            hintText: LocaleKeys.selectSubject.tr,
                            items: controller.subjects
                                .map(
                                  (String e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e, style: AppTextStyle.lato()),
                                  ),
                                )
                                .toList(),
                            onChanged: controller.onSubjectChanged,
                            onClear: controller.selectedSubject() == null
                                ? null
                                : () {
                                    controller.configurationFormKey.currentState
                                        ?.patchValue(<String, dynamic>{
                                          'subject': null,
                                        });
                                    controller.onSubjectChanged(null);
                                  },
                            value: controller.selectedSubject.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  ProfileTextField(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return LocaleKeys.examinationNameIsRequired.tr;
                      }
                      return null;
                    },
                    label: LocaleKeys.examinationName.tr,
                    name: 'examination_name',
                    onChanged: (String? v) {
                      controller.onExaminationNameChanged(v ?? '');
                    },
                  ),
                  12.verticalSpace,
                  ProfileTextField(
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return LocaleKeys.marksIsRequired.tr;
                      }
                      if ((int.tryParse(value!) ?? 0) > 100) {
                        return LocaleKeys.totalMarksCannotExceed100.tr;
                      }
                      return null;
                    },
                    label: LocaleKeys.totalMarks.tr,
                    name: 'total_marks',
                    onChanged: (String? v) {
                      controller.onTotalMarksChanged(v ?? '');
                    },
                  ),
                  20.verticalSpace,
                  Text(
                    LocaleKeys.questionPaperScope.tr,
                    style: AppTextStyle.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  14.verticalSpace,
                  Obx(
                    () => AnimatedSize(
                      duration: const Duration(milliseconds: 150),
                      alignment: Alignment.topCenter,
                      curve: Curves.easeIn,
                      reverseDuration: const Duration(milliseconds: 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomRadioGroup(
                            options: const <String>[
                              'Multiple Chapters',
                              'Single Chapter',
                            ],
                            selectedValue: controller.questionPaperScope.value,
                            onChanged: controller.onQuestionPaperScopeChanged,
                          ),
                          16.verticalSpace,
                          ProfileMultiSelectDropdown(
                            validator: (List<String>? values) {
                              if (values?.isEmpty ?? true) {
                                return LocaleKeys.chapterIsRequired.tr;
                              }
                              return null;
                            },
                            label: LocaleKeys.chapter.tr,
                            name: 'chapter',
                            items: controller.chapterList.keys.toList(),
                            hintText: LocaleKeys.selectChapter.tr,
                            onChanged: controller.onChapterChanged,
                            isMultiSelection:
                                controller.questionPaperScope.value ==
                                'Multiple Chapters',
                          ),
                          if (controller.questionPaperScope.value ==
                              'Single Chapter')
                            12.verticalSpace,
                          if (controller.questionPaperScope.value ==
                              'Single Chapter')
                            ProfileMultiSelectDropdown(
                              validator: (List<String>? values) {
                                if (values?.isEmpty ?? true) {
                                  return LocaleKeys.subtopicIsRequired.tr;
                                }
                                return null;
                              },
                              label: LocaleKeys.subTopic.tr,
                              name: 'subtopic',
                              items: controller.subTopicList,
                              hintText: LocaleKeys.selectSubtopic.tr,
                              isMultiSelection: true,
                              onChanged: controller.onSubTopicChanged,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            Obx(
              () =>
                  (controller.selectedSubject.isEmpty ?? true) &&
                      !controller.showObjectivesOnReady.value
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10).r,
                              side: BorderSide(
                                color: controller.totalObjectives
                                    ? AppColors.k000000.withOpacity(0.1)
                                    : AppColors.kFFC11E,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 30.h,
                            horizontal: 20.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                LocaleKeys.objectives.tr,
                                style: AppTextStyle.lato(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              12.verticalSpace,
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ProfileTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) {
                                        if (value?.isEmpty ?? true) {
                                          return LocaleKeys.required.tr;
                                        }
                                        return null;
                                      },
                                      label: LocaleKeys.knowledge.tr,
                                      name: 'knowledge',
                                      suffixIcon: Icon(
                                        Icons.percent_rounded,
                                        color: AppColors.k565E6C,
                                        size: 14.h,
                                      ),
                                      onChanged: (String? v) {
                                        if (v?.trim().isNotEmpty ?? false) {
                                          controller.knowledge.value = v!;
                                        }
                                      },
                                    ),
                                  ),
                                  6.horizontalSpace,
                                  Expanded(
                                    child: ProfileTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) {
                                        if (value?.isEmpty ?? true) {
                                          return LocaleKeys.required.tr;
                                        }
                                        return null;
                                      },
                                      label: LocaleKeys.understanding.tr,
                                      name: 'understanding',
                                      suffixIcon: Icon(
                                        Icons.percent_rounded,
                                        color: AppColors.k565E6C,
                                        size: 14.h,
                                      ),
                                      onChanged: (String? v) {
                                        if (v?.trim().isNotEmpty ?? false) {
                                          controller.understanding.value = v!;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              12.verticalSpace,
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ProfileTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) {
                                        if (value?.isEmpty ?? true) {
                                          return LocaleKeys.required.tr;
                                        }
                                        return null;
                                      },
                                      label: LocaleKeys.application.tr,
                                      name: 'application',
                                      suffixIcon: Icon(
                                        Icons.percent_rounded,
                                        color: AppColors.k565E6C,
                                        size: 14.h,
                                      ),
                                      onChanged: (String? v) {
                                        if (v?.trim().isNotEmpty ?? false) {
                                          controller.application.value = v!;
                                        }
                                      },
                                    ),
                                  ),
                                  6.horizontalSpace,
                                  Expanded(
                                    child: ProfileTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) {
                                        if (value?.isEmpty ?? true) {
                                          return LocaleKeys.required.tr;
                                        }
                                        return null;
                                      },
                                      label: LocaleKeys.skill.tr,
                                      name: 'skill',
                                      suffixIcon: Icon(
                                        Icons.percent_rounded,
                                        color: AppColors.k565E6C,
                                        size: 14.h,
                                      ),
                                      onChanged: (String? v) {
                                        if (v?.trim().isNotEmpty ?? false) {
                                          controller.skill.value = v!;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!controller.totalObjectives) ...<Widget>[
                          6.verticalSpace,
                          Text(
                            LocaleKeys.pleaseEnsureTheSumOfAllObjectives.tr,
                            style: AppTextStyle.lato(color: AppColors.kFFC11E),
                          ),
                        ],
                      ],
                    ),
            ),
            24.verticalSpace,
            Obx(() {
              if (controller.marksDistribution.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocaleKeys.marksDistribution.tr,
                    style: AppTextStyle.lato(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  20.verticalSpace,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10).r,
                    child: Obx(
                      () => Table(
                        border:
                            controller.distributedMarks.value !=
                                (int.tryParse(controller.totalMarks.value) ?? 0)
                            ? TableBorder.all(
                                color: AppColors.kFFC11E,
                                width: 1.5,
                              )
                            : TableBorder.all(
                                color: AppColors.k000000.withOpacity(0.05),
                              ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(4.5),
                          2: FlexColumnWidth(2),
                        },
                        children: <TableRow>[
                          TableRow(
                            decoration: const BoxDecoration(
                              color: AppColors.kEDF6FE,
                            ),
                            children: <Widget>[
                              _buildHeaderCell(LocaleKeys.topics.tr),
                              _buildHeaderCell(LocaleKeys.marks.tr),
                              _buildHeaderCell(LocaleKeys.percentage.tr),
                            ],
                          ),
                          ...List<
                            TableRow
                          >.generate(controller.marksDistribution.length, (
                            int index,
                          ) {
                            final Map<String, String> item =
                                controller.marksDistribution[index];
                            final String topic = item['topic']!;
                            final String marks = item['marks']!;
                            return TableRow(
                              children: <Widget>[
                                _buildCell(
                                  Text(
                                    topic,
                                    style: AppTextStyle.lato(),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _buildCell(
                                  SizedBox(
                                    height: 40,
                                    child: FormBuilderTextField(
                                      validator: (String? value) {
                                        if (value?.isEmpty ?? true) {
                                          return LocaleKeys.marksIsRequired.tr;
                                        }
                                        return null;
                                      },
                                      name: 'marks_$index',
                                      initialValue: marks,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ).r,
                                          borderSide: const BorderSide(
                                            color: AppColors.k9095A0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ).r,
                                          borderSide: const BorderSide(
                                            color: AppColors.k9095A0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ).r,
                                          borderSide: const BorderSide(
                                            color: AppColors.k9095A0,
                                          ),
                                        ),
                                      ),
                                      onTapOutside: (PointerDownEvent event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      onChanged: (String? value) {
                                        controller.onMarksChanged(
                                          index,
                                          value ?? '0',
                                        );
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                _buildCell(
                                  Obx(() {
                                    final String currentMarks = controller
                                        .marksDistribution[index]['marks']!;
                                    final int totalMarks =
                                        int.tryParse(
                                          controller.totalMarks.value,
                                        ) ??
                                        1;
                                    final String percentage = totalMarks == 0
                                        ? '0'
                                        : (int.parse(currentMarks) /
                                                  totalMarks *
                                                  100)
                                              .toStringAsFixed(0);
                                    return Text(
                                      '$percentage%',
                                      style: AppTextStyle.lato(),
                                    );
                                  }),
                                ),
                              ],
                            );
                          }),
                          TableRow(
                            decoration: BoxDecoration(
                              color: AppColors.kEDF6FE.withOpacity(0.4),
                            ),
                            children: <Widget>[
                              _buildCell(const SizedBox.shrink()),
                              _buildCell(
                                Obx(
                                  () => Text(
                                    '[ ${LocaleKeys.totalMarksDistributed.tr}/${LocaleKeys.totalMarks.tr} ] : [ ${controller.distributedMarks.value}/${controller.totalMarks.value} ]',
                                    style: AppTextStyle.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              _buildCell(
                                Obx(() {
                                  final int totalMarks =
                                      int.tryParse(
                                        controller.totalMarks.value,
                                      ) ??
                                      1;
                                  final String percentage = totalMarks == 0
                                      ? '0'
                                      : (controller.distributedMarks.value /
                                                totalMarks *
                                                100)
                                            .toStringAsFixed(0);
                                  return Text(
                                    '$percentage%',
                                    style: AppTextStyle.lato(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.distributedMarks.value !=
                      (int.tryParse(controller.totalMarks.value) ??
                          0)) ...<Widget>[
                    6.verticalSpace,
                    Text(
                      LocaleKeys.theTotalDistributionOfMarksMustEqual.tr,
                      style: AppTextStyle.lato(color: AppColors.kFFC11E),
                    ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Builds a header cell for the table.
  ///
  /// Parameters:
  /// - `text`: The text to display in the header cell.
  ///
  /// Returns:
  /// A `Widget` representing a header cell.
  Widget _buildHeaderCell(String text) => Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
    child: Text(text, style: AppTextStyle.lato(fontWeight: FontWeight.bold)),
  );

  /// Builds a cell for the table.
  ///
  /// Parameters:
  /// - `child`: The widget to display in the cell.
  ///
  /// Returns:
  /// A `Widget` representing a table cell.
  Widget _buildCell(Widget child) => Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
    child: Center(child: child),
  );
}
