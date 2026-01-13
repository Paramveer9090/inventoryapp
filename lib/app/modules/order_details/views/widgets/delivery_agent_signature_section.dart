import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class DeliveryAgentSignatureSection extends StatelessWidget {
  final OrderDetailsController controller;

  const DeliveryAgentSignatureSection({Key? key, required this.controller}) : super(key: key);

  bool get _shouldShowSection {
    return (controller.loginData?.id == controller.getDetailsData?.deliveryAgentId) &&
        (controller.getDetailsData?.status != "1") &&
        controller.orderItem.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowSection) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          "Customer Signature",
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
        SizedBox(height: 2.h),
        controller.bytesImage == null
            ? Column(
                children: [
                  Container(
                    height: 25.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffb0b0b3),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SfSignaturePad(
                      key: controller.signatureGlobalKey,
                      minimumStrokeWidth: 1,
                      maximumStrokeWidth: 3,
                      strokeColor: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          title: "Clear",
                          onTap: () async {
                            controller.signatureGlobalKey.currentState!.clear();
                            controller.update();
                          },
                        ),
                      ),
                      SizedBox(width: 2.h),
                      Expanded(
                        child: AppButton(
                          title: "Save",
                          onTap: () async {
                            controller.handleSaveButtonPressed();
                            controller.update();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : SizedBox(
                height: 25.h,
                child: Image.memory(
                  controller.bytesImage!,
                ),
              ),
        SizedBox(height: 2.h),
        CustomTextFormField(
          readOnly: true,
          label: controller.imageFile.value == "" ? 'PO File' : controller.imageFile.value.split("/").last,
          hintText: controller.imageFile.value == "" ? 'Choose File' : controller.imageFile.value.split("/").last,
          onTap: () async {
            controller.getFile();
          },
        ),
        SizedBox(height: 2.h),
        CustomTextFormField(
          hintText: "Enter your comment",
          label: "Comment",
          controller: controller.comments,
          readOnly: controller.loginData?.id == controller.getDetailsData!.deliveryAgentId ? false : true,
          validator: (value) => Validators.requiredEmail(value),
        ),
        if (controller.getDetailsData?.comments != null &&
            controller.getDetailsData!.comments.toString().isNotEmpty &&
            controller.getDetailsData!.comments.toString() != 'null')
          ...[
            SizedBox(height: 2.h),
            CustomTextFormField(
              hintText: "No order notes",
              label: "Order Notes",
              initialValue: controller.getDetailsData!.comments.toString(),
              readOnly: true,
              maxLines: 3,
            ),
          ],
        SizedBox(height: 5.h),
        Row(
          children: [
            Expanded(
              child: AppButton(
                color: AppColors.secondButtonColor,
                title: 'Cancel',
                onTap: () {
                  Get.find<HomeController>().isSelected.value = 1;
                  Get.find<HomeController>().update();
                },
              ),
            ),
            SizedBox(width: 4.h),
            Expanded(
              child: AppButton(
                onTap: () async {
                  if (controller.imageEncoded.value.isNotEmpty) {
                    controller.editOrderAPI();
                  } else {
                    await controller.uploadFileAPI();
                    await controller.handleSaveButtonPressed();
                    controller.editOrderAPI();
                  }
                },
                title: 'Update',
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
