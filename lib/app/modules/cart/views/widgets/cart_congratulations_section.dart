import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class CartCongratulationsSection extends StatelessWidget {
  const CartCongratulationsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.h),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Image.asset(
            AppImages.ic_congratulations,
            height: 15.h,
            width: 15.h,
          ),
          SizedBox(height: 5.h),
          AppText(
            "Invoice sent",
            fontSize: 23.sp,
            color: const Color(0xff38A171),
          ),
          SizedBox(height: 5.h),
          AppText(
            "Your invoice was created and sent successfully.",
            fontSize: 15.sp,
            textAlign: TextAlign.center,
            color: const Color(0XFF44474d),
          ),
          SizedBox(height: 2.h),
          AppButton(
            title: "Back to dashboard",
            isIcon: true,
            icon: Icons.arrow_back_ios_new,
            onTap: () {
              Get.find<HomeController>().isCart.value = false;
              Get.find<HomeController>().isSelected.value = 0;
              Get.find<HomeController>().update();
            },
          ),
        ],
      ),
    );
  }
}
