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
                  // Header
                  DashboardHeader(controller: controller),
                  SizedBox(height: 3.h),

                  // Stats Cards
                  _buildStatsSection(controller),
                  SizedBox(height: 3.h),

                  // Recent Orders Section
                  _buildRecentOrdersSection(controller),
                  SizedBox(height: 2.h),

                  // Quick Action
                  _buildQuickActionSection(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(DashboardController controller) {
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
        Row(
          children: [
            Expanded(
              child: ModernStatsCard(
                title: "Accepted Orders",
                count: controller.isAccepted.value,
                icon: Icons.check_circle_outline,
                color: const Color(0xff4CAF50),
                backgroundColor: const Color(0xffE8F5E8),
              ),
            ),
            SizedBox(width: 2.h),
            Expanded(
              child: ModernStatsCard(
                title: "Under Review",
                count: controller.isReview.value,
                icon: Icons.schedule_outlined,
                color: const Color(0xffFF9800),
                backgroundColor: const Color(0xffFFF3E0),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildRecentOrdersSection(DashboardController controller) {
    return RecentOrdersCard(controller: controller);
  }

  Widget _buildQuickActionSection() {
    return QuickActionCard();
  }
}

