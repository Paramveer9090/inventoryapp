import 'package:true_leaf_inventory_app/app/modules/customer_details/controllers/customer_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomerInfoTile extends StatelessWidget {
  final CustomerDetailsController controller;

  const CustomerInfoTile({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final details = controller.customerDetails;
    if (details == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          maintainState: true,
          expandedAlignment: Alignment.centerLeft,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          title: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.business,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      details.name.toString(),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    AppText(
                      details.companyName.toString(),
                      fontSize: 12.sp,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (details.contactName != null && details.contactName!.isNotEmpty)
                    _InfoRow(
                      label: "Contact Person",
                      value: details.contactName!,
                      icon: Icons.person_outline,
                    ),
                  _InfoRow(
                    label: "Address",
                    value: details.address.toString(),
                    icon: Icons.location_on_outlined,
                  ),
                  _InfoRow(
                    label: "Postal Code",
                    value: details.pincode.toString(),
                    icon: Icons.markunread_mailbox_outlined,
                  ),
                  if (details.phoneNumber != null && details.phoneNumber!.isNotEmpty)
                    _InfoRow(
                      label: "Phone Number",
                      value: details.phoneNumber!,
                      icon: Icons.phone_outlined,
                    ),
                  if (details.email != null && details.email!.isNotEmpty)
                    _InfoRow(
                      label: "Email",
                      value: details.email!,
                      icon: Icons.email_outlined,
                    ),
                  _InfoRow(
                    label: "Payment Terms",
                    value: details.paymentTerms == "0"
                        ? "15 Days"
                        : details.paymentTerms == "1"
                            ? "30 Days"
                            : details.paymentTerms == "2"
                                ? "45 Days"
                                : "60 Days",
                    icon: Icons.payment_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({Key? key, required this.label, required this.value, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  fontSize: 11.sp,
                  color: AppColors.arrowColor,
                ),
                const SizedBox(height: 2),
                AppText(
                  value,
                  fontSize: 13.sp,
                  color: AppColors.blackColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
