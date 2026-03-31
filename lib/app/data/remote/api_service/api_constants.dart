import 'package:sikshana/app/data/config/flavors/flavor_service.dart';

/// API endpoint constants
class ApiConstants {
  /// Base URL for the API
  static String get baseUrl => FlavorService.config.apiHost;

  ///faq url
  static String get faqUrl => FlavorService.config.faqUrl;

  ///get otp
  static String get getOtp => '/auth/get-otp';

  ///validate otp
  static String get validateOtp => '/auth/validate-otp';

  ///get me
  static String get getMe => '/auth/me';

  ///get profile
  static String get getProfile => '/user/get-profile';

  ///set profile
  static String get setProfile => '/user/set-profile';

  ///remove profile image
  static String get removeProfileImage => '/user/remove-profile-image';

  ///upload profile image
  static String get uploadProfileImage => '/user/upload-profile-image';

  ///facility list
  static String get facilityList => '/facility/list';

  ///facility list
  static String get groupByBoard => '/class/group-by-board';

  ///update language
  static String get updateLanguage => '/user/update-language';

  ///teacher lesson plan list
  static String get teacherLessonPlanList => '/teacher-lesson-plan/list';

  ///my schedules
  static String get mySchedules => '/schedule/my-schedules';

  ///get schedule by school
  static String get getScheduleBySchool => '/schedule/get-by-school';

  ///get schedule by id
  static String get getScheduleById => '/schedule';

  ///create schedule
  static String get createSchedule => '/schedule/create';

  ///update schedule
  static String get updateSchedule => '/schedule/update';

  ///lesson resource analytics
  static String get lessonResourceAnalytics =>
      '/teacher-lesson-plan/monthly-count';

  ///chat messages
  static String get chatMessages => '/chat/messages';

  ///lesson chat messages
  static String get lessonchatMessages => '/lessonchat/messages';

  ///chat message
  static String get chatMessage => '/chat/message';

  // lesson plan templete list
  static String get lessonPlanTemplateList => '/lesson-plan-template/list';

  // chapter list
  static String get chapterList => '/chapter/list';

  // learningOutcomes
  static String get lessonPlanLearningOutcomes =>
      '/master-lesson/learning-outcomes';

  // learningOutcomes Resource
  static String get resourcePlanLearningOutcomes =>
      '/resource-plan/learning-outcomes';

  // generate lesson
  static String get generateLesson => '/master-lesson/';

  // generate lesson
  static String get generateResource => '/master-resource/';

  ///teacher lesson plan lesson
  static String get getTeacherLessonPlanByLessonId =>
      '/teacher-lesson-plan/lesson';

  ///teacher lesson plan lesson
  static String get getTeacherResourcePlanByResourceId =>
      '/teacher-lesson-plan/resource';

  static String addMediaUrl(String lessonId) =>
      '/teacher-lesson-plan/lesson/$lessonId/media';

  static String deleteMediaUrl(String lessonId) =>
      '/teacher-lesson-plan/lesson/$lessonId/media';

  static String addResourceActivityMediaUrl(String resourcePlanId) =>
      '/teacher-lesson-plan/resource/$resourcePlanId/media';

  static String deleteResourceActivityMediaUrl(String resourcePlanId) =>
      '/teacher-lesson-plan/resource/$resourcePlanId/media';

  static String addRatingForActivity(String resourcePlanId) =>
      '/teacher-lesson-plan/resource/$resourcePlanId/rating';

  ///lesson chat message
  static String get lessonchatMessage => '/lessonchat/message';

  // save teacher lesson plan
  static String get saveTeacherLessonPlan => '/lesson-plan/save-to-teacher';

  // create lesson feedback
  static String get createLessonFeedback => '/lesson-feedback/create';

  // create resource feedback
  static String get createResourceFeedback =>
      '/teacher-resource-feedback/create';

  // regenerate api
  static String get regenerate => '/teacher-lesson-plan/regenerate';

  // regeneration limit
  static String get regenerationLimit =>
      '/teacher-lesson-plan/regeneration-limit';

  ///question bank list
  static String get questionBankList => '/question-bank/list';

  ///get chapter by sem
  static String get getChapterBySem => '/chapter/get-by-sem';

  ///generate template
  static String get generateTemplate => '/question-bank/generate-template';

  ///generate template
  static String get generateBluePrint => '/question-bank/generate-blue-print';

  ///generate question bank
  static String get generateQuestionBank => '/question-bank/generate';

  ///get question bank
  static String get getQuestionBank => '/question-bank';

  ///help videos list
  static String get helpVideosList => '/help-videos/list';
}
