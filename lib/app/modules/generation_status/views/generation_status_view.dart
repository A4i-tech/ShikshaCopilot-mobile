import 'package:sikshana/app/modules/generation_status/views/widgets/filter_section.dart';
import 'package:sikshana/app/modules/generation_status/views/widgets/generation_status.dart';
import 'package:sikshana/app/modules/generation_status/views/widgets/status_list_widget.dart';
import 'package:sikshana/app/utils/exports.dart';

class GenerationStatusView extends GetView<GenerationStatusController> {
  const GenerationStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Scaffold(
              key: scaffoldKey,
              appBar: CommonAppBar(
                scaffoldKey: scaffoldKey,
                leading: Leading.drawer,
              ),
              drawer: const AppDrawer(currentRoute: Routes.GENERATION_STATUS),
              body: RefreshIndicator(
                onRefresh: () async {
                  controller.fetchGenerationStatus();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        36.verticalSpace,
                        Text(
                          LocaleKeys.generationStatus.tr,
                          style: AppTextStyle.lato(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.k141522,
                          ),
                        ),
                        30.verticalSpace,
                        const GenerateStatusCard(),
                        16.verticalSpace,
                        FilterSection(),
                        16.verticalSpace,
                        StatusList(),
                        16.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
