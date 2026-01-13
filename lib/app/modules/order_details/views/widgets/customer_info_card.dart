import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/order_details/views/widgets/details_box.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomerInfoCard extends StatelessWidget {
  final OrderDetailsController controller;

  const CustomerInfoCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customer = controller.getDetailsData?.customer;
    if (customer == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.business,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                AppText(
                  "Customer Information",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (customer.companyName != null)
              DetailsBox(
                title: "Company Name",
                value: customer.companyName,
              ),
            if (customer.contactName != null)
              DetailsBox(
                title: "Contact Person",
                value: customer.contactName,
              ),
            DetailsBox(
              title: "Customer Name",
              value: customer.name,
            ),
            if (controller.loginData?.roles?[0].title == "Delivery Agent" &&
                customer.address != null)
              DetailsBox(
                title: "Address",
                value: customer.address,
              ),
            if (controller.loginData?.roles?[0].title == "Delivery Agent" &&
                customer.phoneNumber != null)
              DetailsBox(
                title: "Phone Number",
                value: customer.phoneNumber,
              ),
          ],
        ),
      ),
    );
  }
}
