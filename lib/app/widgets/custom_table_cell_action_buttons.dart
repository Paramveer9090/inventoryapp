import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomTableCellActionButtons extends StatelessWidget {
  final Function()? onView;
  final Function()? onEdit;
  final Function()? onDelete;
  final Function()? onViewDetails;
  final Function()? onDownload;
  final String detailsBtnText;
  final bool viewButton;
  final bool showEditButton;
  final bool showDeleteButton;
  final bool showViewDetailsButton;
  final bool downloadPDF;
  final bool isWhite;

  const CustomTableCellActionButtons({
    super.key,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    this.onViewDetails,
    this.onDownload,
    this.detailsBtnText = 'Details',
    this.showEditButton = true,
    this.showDeleteButton = true,
    this.showViewDetailsButton = false,
    this.downloadPDF = false,
    this.viewButton = true,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (viewButton)
          GestureDetector(
            onTap: onView,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                AppImages.ic_view,
                height: 2.5.h,
                width: 2.5.h,
                color: isWhite ? AppColors.whiteColor : null,
              ),
            ),
          ),
        SizedBox(width: 2.5.w),
        if (showEditButton)
          GestureDetector(
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.mode_edit_outline,
                color: isWhite ? AppColors.whiteColor : Color(0Xff021a32),
              ),
            ),
          ),
        SizedBox(width: 2.5.w),
        if (showDeleteButton)
          GestureDetector(
            onTap: onDelete,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.delete_rounded,
                  color: Color(0xffdc3545),
                )),
          ),
        if (showViewDetailsButton)
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: onViewDetails,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AppText(
                  detailsBtnText,
                  color: AppColors.whiteColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        if (downloadPDF)
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: onDownload,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.elevatedButtonColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: AppText(
                  "Download PDF",
                  color: AppColors.whiteColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
