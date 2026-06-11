import '../../../widgets/all_import.dart';
import '../controllers/add_customer_controller.dart';
import 'widgets/add_customer_header.dart';
import 'widgets/customer_form_section.dart';
import 'widgets/save_customer_button.dart';

class AddCustomerView extends GetView<AddCustomerController> {
  const AddCustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddCustomerController>(
      init: AddCustomerController(),
      builder: (controller) {
        return GestureDetector(
          onTap: () => utils.hideKeyboard(context),
          child: Scaffold(
            backgroundColor: AppColors.greyLightColor,
            body: SafeArea(
              child: Column(
                children: [
                  const AddCustomerHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(2.h),
                      child: Form(
                        key: controller.formKey,
                        child: CustomerFormSection(controller: controller),
                      ),
                    ),
                  ),
                  SaveCustomerButton(controller: controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}