import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/chatbot/bindings/chatbot_binding.dart';
import '../modules/chatbot/views/chatbot_view.dart';
import '../modules/content_generation/bindings/content_generation_binding.dart';
import '../modules/content_generation/views/content_generation_view.dart';
import '../modules/faq/bindings/faq_binding.dart';
import '../modules/faq/views/faq_view.dart';
import '../modules/generation_status/bindings/generation_status_binding.dart';
import '../modules/generation_status/views/generation_status_view.dart';
import '../modules/help/bindings/help_binding.dart';
import '../modules/help/views/help_view.dart';
import '../modules/video_player/views/video_player_view.dart';
import '../modules/lesson_chatbot/bindings/lesson_chatbot_binding.dart';
import '../modules/lesson_chatbot/views/lesson_chatbot_view.dart';
import '../modules/lesson_plan_generated_view/bindings/lesson_plan_generated_view_binding.dart';
import '../modules/lesson_plan_generated_view/views/lesson_plan_generated_view_view.dart';
import '../modules/lesson_plan_generation_details/bindings/lesson_plan_generation_details_binding.dart';
import '../modules/lesson_plan_generation_details/views/lesson_plan_generation_details_view.dart';
import '../modules/lesson_resource_generated_view/bindings/lesson_resource_generated_view_binding.dart';
import '../modules/lesson_resource_generated_view/views/lesson_resource_generated_view_view.dart';
import '../modules/lesson_resource_generation_details/bindings/lesson_resource_generation_details_binding.dart';
import '../modules/lesson_resource_generation_details/views/lesson_resource_generation_details_view.dart';
import '../modules/my_schedules/bindings/my_schedules_binding.dart';
import '../modules/my_schedules/views/my_schedules_view.dart';
import '../modules/navigation_screen/bindings/navigation_screen_binding.dart';
import '../modules/navigation_screen/views/navigation_screen_view.dart';
import '../modules/no_internet_screen/bindings/no_internet_screen_binding.dart';
import '../modules/no_internet_screen/views/no_internet_screen_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/question_paper/bindings/question_paper_binding.dart';
import '../modules/question_paper/views/question_paper_view.dart';
import '../modules/question_paper_generation/bindings/question_paper_generation_binding.dart';
import '../modules/question_paper_generation/views/question_paper_generation_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/view_question_paper/bindings/view_question_paper_binding.dart';
import '../modules/view_question_paper/views/view_question_paper_view.dart';
import '../utils/exports.dart';
import '../modules/video_player/bindings/video_player_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final List<GetPage> routes = [
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NO_INTERNET_SCREEN,
      page: () => const NoInternetScreenView(),
      binding: NoInternetScreenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CONTENT_GENERATION,
      page: () => const ContentGenerationView(),
      binding: ContentGenerationBinding(),
    ),
    GetPage(
      name: _Paths.LESSON_PLAN_GENERATION_DETAILS,
      page: () => const LessonPlanGenerationDetailsView(),
      binding: LessonPlanGenerationDetailsBinding(),
    ),
    GetPage(
      name: _Paths.LESSON_PLAN_GENERATED_VIEW,
      page: () => const LessonPlanGeneratedViewView(),
      binding: LessonPlanGeneratedViewBinding(),
    ),
    GetPage(
      name: _Paths.CHATBOT,
      page: () => const ChatbotView(),
      binding: ChatbotBinding(),
    ),
    GetPage(
      name: _Paths.GENERATION_STATUS,
      page: () => const GenerationStatusView(),
      binding: GenerationStatusBinding(),
    ),
    GetPage(
      name: _Paths.MY_SCHEDULES,
      page: () => const MySchedulesView(),
      binding: MySchedulesBinding(),
    ),
    GetPage(
      name: _Paths.HELP,
      page: () => const HelpView(),
      binding: HelpBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_PLAYER,
      page: () => const VideoPlayerView(),
      binding: VideoPlayerBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.LESSON_CHATBOT,
      page: () => const LessonChatbotView(),
      binding: LessonChatbotBinding(),
    ),
    GetPage(
      name: _Paths.QUESTION_PAPER_GENERATION,
      page: () => const QuestionPaperGenerationView(),
      binding: QuestionPaperGenerationBinding(),
    ),
    GetPage(
      name: _Paths.QUESTION_PAPER,
      page: () => const QuestionPaperView(),
      binding: QuestionPaperBinding(),
    ),
    GetPage(
      name: _Paths.LESSON_RESOURCE_GENERATION_DETAILS,
      page: () => const LessonResourceGenerationDetailsView(),
      binding: LessonResourceGenerationDetailsBinding(),
    ),
    GetPage(
      name: _Paths.LESSON_RESOURCE_GENERATED_VIEW,
      page: () => const LessonResourceGeneratedViewView(),
      binding: LessonResourceGeneratedViewBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_QUESTION_PAPER,
      page: () => const ViewQuestionPaperView(),
      binding: ViewQuestionPaperBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_SCREEN,
      page: () => const NavigationScreenView(),
      binding: NavigationScreenBinding(),
    ),
  ];
}
