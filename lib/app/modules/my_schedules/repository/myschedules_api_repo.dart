import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/my_schedules/models/chapter_filter_model.dart';
import 'package:sikshana/app/modules/my_schedules/models/create_schedule_model.dart';
import 'package:sikshana/app/modules/my_schedules/models/lesson_plan_model.dart';
import 'package:sikshana/app/modules/my_schedules/models/myschedules_model.dart';
import 'package:sikshana/app/modules/my_schedules/models/schedule_by_id_model.dart';

/// Repository class for handling schedule-related API operations.
///
/// Provides methods to fetch, create, update, and delete schedules,
/// as well as retrieve related data such as chapters and lesson plans.
class MySchedulesApiRepo {
  /// Fetches a list of schedules within a specified date range.
  ///
  /// Parameters:
  /// - [fromDate]: Start date for filtering schedules (ISO format string).
  /// - [toDate]: End date for filtering schedules (ISO format string).
  /// - [teacherSchedule]: Whether to fetch teacher schedules (default: true).
  ///
  /// Returns a [MySchedules] object containing the schedule data,
  /// or null if the request fails or returns no data.
  ///
  /// Example:
  /// ```dart
  /// final schedules = await repo.getSchedules(
  ///   fromDate: '2024-01-01',
  ///   toDate: '2024-01-31',
  ///   teacherSchedule: true,
  /// );
  /// ```
  Future<MySchedules?> getSchedules({
    required String fromDate,
    required String toDate,
    bool teacherSchedule = true,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.getScheduleBySchool,
        params: <String, dynamic>{
          'fromDate': fromDate,
          'toDate': toDate,
          'teacherSchedule': teacherSchedule,
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return MySchedules.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error fetching schedules: $e');
    }
    return null;
  }

  /// Creates a new schedule.
  ///
  /// Parameters:
  /// - [body]: Map containing schedule details (teacher ID, subject, class, dates, etc.).
  ///
  /// Returns a [CreateSchedule] object with the created schedule details,
  /// or null if the creation fails.
  ///
  /// Example:
  /// ```dart
  /// final result = await repo.createSchedule({
  ///   'teacherId': '123',
  ///   'subject': 'Mathematics',
  ///   'class': 10,
  ///   'scheduleDateTime': [...],
  /// });
  /// ```
  Future<CreateSchedule?> createSchedule(Map<String, dynamic> body) async {
    try {
      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.createSchedule,
        data: body,
      );

      if (response?.statusCode == 201 || response?.statusCode == 200) {
        return CreateSchedule.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error creating schedule: $e');
    }
    return null;
  }

  /// Updates an existing schedule.
  ///
  /// Parameters:
  /// - [body]: Map containing updated schedule details including schedule ID.
  ///
  /// Returns a [CreateSchedule] object with the updated schedule details,
  /// or null if the update fails.
  ///
  /// Example:
  /// ```dart
  /// final result = await repo.updateSchedule({
  ///   'scheduleId': '123',
  ///   'subject': 'Physics',
  ///   'topic': 'Newton\'s Laws',
  /// });
  /// ```
  Future<CreateSchedule?> updateSchedule(Map<String, dynamic> body) async {
    try {
      final Response<dynamic>? response = await APIService.put(
        path: ApiConstants.updateSchedule,
        data: body,
      );

      if (response?.statusCode == 200) {
        return CreateSchedule.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error updating schedule: $e');
    }
    return null;
  }

  /// Deletes a specific schedule or schedule date/time entry.
  ///
  /// Parameters:
  /// - [scheduleId]: Unique identifier of the schedule.
  /// - [scheduleDateTimeId]: Unique identifier of the specific date/time slot.
  ///
  /// Returns a [CreateSchedule] object confirming deletion,
  /// or null if the deletion fails.
  ///
  /// Example:
  /// ```dart
  /// final result = await repo.deleteSchedule(
  ///   scheduleId: 'schedule123',
  ///   scheduleDateTimeId: 'datetime456',
  /// );
  /// ```
  Future<CreateSchedule?> deleteSchedule({
    required String scheduleId,
    required String scheduleDateTimeId,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.delete(
        path: '${ApiConstants.getScheduleById}/$scheduleId/$scheduleDateTimeId',
      );

      if (response?.statusCode == 200) {
        return CreateSchedule.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error deleting schedule: $e');
    }
    return null;
  }

  /// Fetches detailed information for a specific schedule by ID.
  ///
  /// Parameters:
  /// - [scheduleId]: Unique identifier of the schedule to retrieve.
  ///
  /// Returns a [ScheduleById] object containing complete schedule details,
  /// or null if the schedule is not found or the request fails.
  ///
  /// Example:
  /// ```dart
  /// final schedule = await repo.getScheduleById(
  ///   scheduleId: 'schedule123',
  /// );
  /// ```
  Future<ScheduleById?> getScheduleById({required String scheduleId}) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.getScheduleById}/$scheduleId',
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return ScheduleById.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error fetching schedule by ID: $e');
    }
    return null;
  }

  /// Fetches a list of chapters based on curriculum filters.
  ///
  /// Parameters:
  /// - [board]: Educational board (e.g., 'CBSE', 'ICSE').
  /// - [medium]: Medium of instruction (e.g., 'English', 'Hindi').
  /// - [standard]: Class/grade standard (e.g., '10', '12').
  /// - [subject]: Subject name (e.g., 'Mathematics', 'Science').
  ///
  /// Returns a [ChapterFilterModel] containing filtered chapter list,
  /// or null if no chapters are found or the request fails.
  ///
  /// The results are automatically sorted by order number in ascending order
  /// with a limit of 999 chapters.
  ///
  /// Example:
  /// ```dart
  /// final chapters = await repo.getChapters(
  ///   board: 'CBSE',
  ///   medium: 'English',
  ///   standard: '10',
  ///   subject: 'Mathematics',
  /// );
  /// ```
  Future<ChapterFilterModel?> getChapters({
    required String board,
    required String medium,
    required String standard,
    required String subject,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.chapterList,
        params: <String, dynamic>{
          'filter[board]': board,
          'filter[medium]': medium,
          'filter[standard]': standard,
          'filter[subject]': subject,
          'limit': 999,
          'sortBy': 'orderNumber',
          'sortOrder': 'asc',
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return ChapterFilterModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error fetching chapters: $e');
    }
    return null;
  }

  /// Fetches lesson plans based on curriculum and filter criteria.
  ///
  /// Parameters:
  /// - [board]: Educational board (e.g., 'CBSE', 'ICSE') - required.
  /// - [medium]: Medium of instruction (e.g., 'English', 'Hindi') - required.
  /// - [className]: Class/grade name (optional, defaults to empty string).
  /// - [subject]: Subject name (optional, defaults to empty string).
  /// - [topics]: Specific topics to filter by (optional, defaults to empty string).
  /// - [filterType]: Type of content to filter (default: 'lesson').
  /// - [isCompleted]: Whether to fetch only completed plans (default: true).
  /// - [isGroupedSubTopics]: Whether to group by subtopics (default: true).
  /// - [limit]: Maximum number of results to return (default: 999).
  /// - [page]: Page number for pagination (default: 1).
  ///
  /// Returns a [LessonPlanModel] containing the filtered lesson plans,
  /// or null if no lesson plans are found or the request fails.
  ///
  /// Example:
  /// ```dart
  /// final lessonPlans = await repo.getLessonPlans(
  ///   board: 'CBSE',
  ///   medium: 'English',
  ///   className: '10',
  ///   subject: 'Mathematics',
  ///   topics: 'Algebra',
  ///   limit: 50,
  ///   page: 1,
  /// );
  /// ```
  Future<LessonPlanModel?> getLessonPlans({
    required String board,
    required String medium,
    String className = '',
    String subject = '',
    String topics = '',
    String filterType = 'lesson',
    bool isCompleted = true,
    bool isGroupedSubTopics = true,
    int limit = 999,
    int page = 1,
  }) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.teacherLessonPlanList,
        params: <String, dynamic>{
          'limit': limit,
          'page': page,
          'filter[type]': filterType,
          'filter[isCompleted]': isCompleted,
          'filter[isGroupedSubTopics]': isGroupedSubTopics,
          'filter[board]': board,
          'filter[medium]': medium,
          if (className.isNotEmpty) 'filter[class]': className,
          if (subject.isNotEmpty) 'filter[subject]': subject,
          if (topics.isNotEmpty) 'filter[topics]': topics,
        },
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return LessonPlanModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error fetching lesson plans: $e');
    }
    return null;
  }
}
