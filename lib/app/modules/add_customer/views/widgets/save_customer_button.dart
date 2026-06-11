import '../../../../widgets/all_import.dart';
import '../../controllers/add_customer_controller.dart';

class SaveCustomerButton extends StatelessWidget {
  final AddCustomerController controller;

  const SaveCustomerButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.h, 0, 2.h, 2.h),
      child: Obx(
        () => SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.saveCustomer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoading.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.whiteColor,
                    ),
                  )
                : Text(
                    AppStrings.addCustomer,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}