import 'package:flutter/material.dart';

/// A local data model representing a single schedule event in the calendar UI.
///
/// This class consolidates information from the API response into a format
/// that is easy to use for rendering event items in the schedule view.
class Event {
  /// Creates an [Event] instance.
  const Event({
    required this.teacher,
    required this.className,
    required this.topic,
    required this.startTime,
    required this.endTime,
    required this.scheduleId,
    required this.scheduleDateTimeId,
    required this.color,
    required this.lessonId,
  });
  /// The name of the teacher conducting the class.
  final String teacher;
  /// Formatted string representing the class, subject, and semester.
  final String className;
  /// The topic of the lesson.
  final String topic;
  /// The start time of the event.
  final TimeOfDay startTime;
  /// The end time of the event.
  final TimeOfDay endTime;
  /// The unique identifier for the parent schedule entry.
  final String scheduleId;
  /// The unique identifier for the specific date-time instance of the schedule.
  final String scheduleDateTimeId;
  /// The color used to display the event in the UI.
  final Color color;
  /// The unique identifier for the associated lesson plan.
  final String lessonId;
}
