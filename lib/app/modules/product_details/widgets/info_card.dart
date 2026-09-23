import '../../../widgets/all_import.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoCard({Key? key, required this.title, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 1.h),
            Divider(color: AppColors.greyLightColor),
            SizedBox(height: 1.h),
            ...children,
          ],
        ),
      ),
    );
  }
}
