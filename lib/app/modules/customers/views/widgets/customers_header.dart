import 'package:true_leaf_inventory_app/app/utils/responsive_helper.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomersHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final int totalCount;
  final int filteredCount;

  const CustomersHeader({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
    required this.totalCount,
    required this.filteredCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(1.5.h),
          bottomRight: Radius.circular(1.5.h),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 0.2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomSearchBar(
            controller: searchController,
            hint: 'Search customers...',
            onChanged: onSearchChanged,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(
                Icons.people_outline,
                size: 1.6.h,
                color: Colors.grey[600],
              ),
              SizedBox(width: 0.5.h),
              Text(
                _buildCountLabel(context),
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 9.sp, 12.sp),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildCountLabel(BuildContext context) {
    if (totalCount != filteredCount) {
      return '$totalCount customers (filtered from $filteredCount)';
    }
    return '$totalCount customers';
  }
}
