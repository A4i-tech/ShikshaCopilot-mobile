import 'package:flutter/material.dart';

/// A model class representing an item in the lesson plan and resource list.
///
/// This model holds the data for a single card in the UI, which can be either a
/// lesson plan or a lesson resource.
class LessonPlanResourceListModel {
  /// Creates a new instance of [LessonPlanResourceListModel].
  ///
  /// The [subject], [className], [lessonType], [chapter], [subTopic], [date],
  /// [buttonText], [cardColor], and [buttonColor] parameters are required.
  /// The [showChatbot] parameter defaults to `false`.
  LessonPlanResourceListModel({
    required this.subject,
    required this.className,
    required this.lessonType,
    required this.chapter,
    required this.subTopic,
    required this.date,
    required this.buttonText,
    required this.cardColor,
    required this.buttonColor,
    this.showChatbot = false,
  });

  /// The subject of the lesson plan or resource.
  final String subject;

  /// The class for which the lesson plan or resource is intended.
  final String className;

  /// The type of the item, e.g., "Lesson Plan".
  final String lessonType;

  /// The chapter to which the lesson plan or resource belongs.
  final String chapter;

  /// The sub-topic covered by the lesson plan or resource.
  final String subTopic;

  /// The date the lesson plan or resource was created.
  final String date;

  /// The text to be displayed on the button at the bottom of the card.
  final String buttonText;

  /// The color of the card.
  final Color cardColor;

  /// The color of the button.
  final Color buttonColor;

  /// A boolean indicating whether to show the chatbot button.
  ///
  /// This is used to conditionally display a chatbot button on the card.
  final bool showChatbot;
}
