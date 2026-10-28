import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/modern_stats_card.dart';
import '../widgets/recent_orders_card.dart';
import '../widgets/quick_action_card.dart';
// order_card is used by RecentOrdersCard; imported there

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      assignId: true,
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.getOrderAPI(isLoading: false);
              },
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(2.h),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DashboardHeader(controller: controller),
                          SizedBox(height: 3.h),
                          _buildStatsSection(controller),
                          SizedBox(height: 3.h),
                          _buildRecentOrdersSection(controller),
                          SizedBox(height: 2.h),
                          _buildQuickActionSection(),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(DashboardController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          ModernStatsCard(
            title: "Accepted Orders",
            count: controller.isAccepted.value,
            icon: Icons.check_circle_outline,
            color: const Color(0xff2E7D32),
            backgroundColor: const Color(0xffE8F5E8),
          ),
          ModernStatsCard(
            title: "Under Review",
            count: controller.isReview.value,
            icon: Icons.schedule_outlined,
            color: const Color(0xffB45309),
            backgroundColor: const Color(0xffFFF3E0),
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.h),
              child: AppText(
                'Order Summary',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 1.5.h),
            if (constraints.maxWidth < 320)
              Column(
                children: [
                  cards[0],
                  SizedBox(height: 1.h),
                  cards[1],
                ],
              )
            else
              Row(
                children: [
                  Expanded(child: cards[0]),
                  SizedBox(width: 2.h),
                  Expanded(child: cards[1]),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildRecentOrdersSection(DashboardController controller) {
    return RecentOrdersCard(controller: controller);
  }

  Widget _buildQuickActionSection() {
    return QuickActionCard();
  }
}
