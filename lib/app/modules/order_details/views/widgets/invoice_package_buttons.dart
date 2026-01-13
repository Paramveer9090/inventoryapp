import 'package:printing/printing.dart';
import 'package:true_leaf_inventory_app/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

class InvoicePackageButtons extends StatelessWidget {
  final OrderDetailsController controller;

  const InvoicePackageButtons({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Flexible(
            child: AppButton(
              title: "Invoice",
              isIcon: true,
              icon: Icons.picture_as_pdf,
              onTap: () async {
                if (controller.getDetailsData == null || controller.orderItem.isEmpty) {
                  await controller.orderDetails();
                  await Future.delayed(const Duration(milliseconds: 500));
                }
                final pdfData = await controller.generateInvoicePdf();
                await Printing.sharePdf(bytes: pdfData, filename: 'invoice.pdf');
              },
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: AppButton(
              title: "Package",
              isIcon: true,
              icon: Icons.local_shipping,
              onTap: () async {
                if (controller.getDetailsData == null || controller.orderItem.isEmpty) {
                  await controller.orderDetails();
                  await Future.delayed(const Duration(milliseconds: 500));
                }
                final pdfData = await controller.generatePackagingSlipPdf();
                await Printing.sharePdf(bytes: pdfData, filename: 'packaging_slip.pdf');
              },
            ),
          ),
        ],
      ),
    );
  }
}
