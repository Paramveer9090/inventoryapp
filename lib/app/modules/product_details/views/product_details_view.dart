import '../../../widgets/all_import.dart';
import '../widgets/product_details_header.dart';
import '../widgets/product_image_card.dart';
import '../widgets/info_card.dart';
import '../widgets/info_row.dart';
import '../widgets/category_section.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  final String? id;
  final String? categoryName;
  final String? subCategoryName;
  final String? description; // optional routed description (e.g., description_invoice)

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
            CategorySection(controller: controller, categoryName: categoryName, routedDescription: description),
          ],
        ),

        SizedBox(height: 1.h),

        InfoCard(
          title: 'Pricing & Stock',
          children: [
            InfoRow('Price', '\$${controller.getDetailsData?.sellingPrice?.toString() ?? 'N/A'}', isPrice: true),
            InfoRow('Stock', controller.getDetailsData?.stock?.toString() ?? 'N/A', valueColor: (controller.getDetailsData?.stock ?? 0) > 0 ? Colors.green : Colors.red),
            InfoRow('Box Size', controller.getDetailsData?.boxSize?.toString() ?? 'N/A'),
          ],
        ),

        SizedBox(height: 3.h),
      ],
    );
  }

}
