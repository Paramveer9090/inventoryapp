import '../../..//widgets/all_import.dart';

class ModernStatsCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const ModernStatsCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(Icons.trending_up, color: color.withValues(alpha: 0.7), size: 16),
              ],
            ),
            SizedBox(height: 1.5.h),
            AppText(
              count,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            SizedBox(height: 0.5.h),
            AppText(
              title,
              fontSize: 12.sp,
              color: color.withValues(alpha: 0.8),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
