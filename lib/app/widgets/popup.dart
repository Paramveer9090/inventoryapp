import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class DeletePopup extends StatelessWidget {
  final type;
  final isDelete;
  final isConfirmation;
  final confirmationText;
  final void Function()? onTap;

  DeletePopup({super.key, this.type, this.onTap, this.isDelete = false, this.isConfirmation = false, this.confirmationText = ""});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10),
              AppText(
                'Are you sure?',
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
              SizedBox(height: 5),
              Center(
                child: AppText(
                  isConfirmation
                      ? confirmationText
                      : isDelete
                          ? 'You want to Logout!'
                          : 'You want to delete the ${type}!',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  2,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: index == 0
                          ? () {
                              Get.back();
                            }
                          : onTap,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        height: 42,
                        decoration: BoxDecoration(
                          color: index == 0 ? AppColors.secondPrimaryColor : AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AppText(
                          index == 0 ? 'NO' : "YES",
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
