import '../controllers/dashboard_controller.dart';

import '../../..//widgets/all_import.dart';

class DashboardHeader extends StatelessWidget {
  final DashboardController controller;

  const DashboardHeader({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = controller.loginData?.name ?? 'User';
    final userRole = controller.loginData?.roles?.isNotEmpty == true
        ? controller.loginData!.roles!.first.title
        : 'User';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withValues(alpha: 0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.dashboard, color: Colors.white, size: 24),
            ),
            SizedBox(width: 2.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Welcome back,',
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  AppText(
                    userName,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  AppText(
                    userRole ?? 'User',
                    fontSize: 11.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
            Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
