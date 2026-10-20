import '../../../widgets/all_import.dart';
import '../widgets/product_details_header.dart';
import '../widgets/product_image_card.dart';
import '../widgets/info_card.dart';
import '../widgets/info_row.dart';
import '../widgets/category_section.dart';
import '../../inventory/widgets/adjust_stock_sheet.dart';
import '../../inventory/widgets/restock_sheet.dart';
import '../../inventory/repositories/stock_movement_store.dart';
import '../../inventory/models/stock_movement.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  final String? id;
  final String? categoryName;
  final String? subCategoryName;
  final String?
      description; // optional routed description (e.g., description_invoice)

  const ProductDetailsView({
    Key? key,
    this.id,
    this.categoryName,
    this.subCategoryName,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
      init: ProductDetailsController(id: id),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: SafeArea(
            child: Column(
              children: [
                ProductDetailsHeader(controller: controller),

                // Content Area
                Expanded(
                  child: controller.getDetailsData == null
                      ? _buildLoadingState()
                      : _buildProductDetails(controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading product details...',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(ProductDetailsController controller) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
      children: [
        ProductImageCard(controller: controller),

        SizedBox(height: 2.h),

        // Product Information Cards
        InfoCard(
          title: 'Basic Information',
          children: [
            InfoRow('Name', controller.getDetailsData?.name ?? 'N/A'),
            CategorySection(
                controller: controller,
                categoryName: categoryName,
                routedDescription: description),
          ],
        ),

        SizedBox(height: 1.h),

        InfoCard(
          title: 'Pricing & Stock',
          children: [
            Obx(
              () => controller.isEditMode.value
                  ? _buildEditableFieldRow(
                      label: 'Price',
                      textController: controller.sellingPriceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      prefixText: '\$ ',
                    )
                  : InfoRow(
                      'Price',
                      '\$${controller.getDetailsData?.sellingPrice?.toString() ?? 'N/A'}',
                      isPrice: true,
                    ),
            ),
            InfoRow(
                'Stock', controller.getDetailsData?.stock?.toString() ?? 'N/A',
                valueColor: (controller.getDetailsData?.stock ?? 0) > 0
                    ? Colors.green
                    : Colors.red),
            Obx(
              () => controller.isEditMode.value
                  ? _buildEditableFieldRow(
                      label: 'Box Size',
                      textController: controller.boxSizeController,
                      keyboardType: TextInputType.number,
                    )
                  : InfoRow(
                      'Box Size',
                      controller.getDetailsData?.boxSize?.toString() ?? 'N/A',
                    ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 1.h,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.add_box_outlined),
                  label: const Text('Restock'),
                  onPressed: () async {
                    final data = controller.getDetailsData;
                    final productId = data?.id;
                    if (productId == null) return;
                    final changed = await showRestockSheet(
                      productId: productId,
                      productName: data?.name ?? '',
                      currentStock: data?.stock ?? 0,
                    );
                    if (changed == true) controller.productDetails();
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: const Text('Adjust Stock'),
                  onPressed: () async {
                    final data = controller.getDetailsData;
                    final productId = data?.id;
                    if (productId == null) return;
                    final changed = await showAdjustStockSheet(
                      productId: productId,
                      productName: data?.name ?? '',
                      currentStock: data?.stock ?? 0,
                    );
                    if (changed == true) controller.productDetails();
                  },
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 1.h),
        _buildStockHistory(controller),

        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildEditableFieldRow({
    required String label,
    required TextEditingController textController,
    required TextInputType keyboardType,
    String? prefixText,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: textController,
                    keyboardType: keyboardType,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      prefixText: prefixText,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockHistory(ProductDetailsController controller) {
    final productId = controller.getDetailsData?.id;
    final List<StockMovement> movements = productId == null
        ? <StockMovement>[]
        : StockMovementStore().readForProduct(productId).take(5).toList();

    return InfoCard(
      title: 'Stock History',
      children: [
        if (movements.isEmpty)
          const Text('No stock changes recorded yet')
        else
          for (final m in movements)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${m.reason.label} - ${m.createdAt.toLocal().toString().substring(0, 16)}',
                    ),
                  ),
                  Text(
                    '${m.delta > 0 ? '+' : ''}${m.delta}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: m.delta > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
