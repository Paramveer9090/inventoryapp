import '../../../widgets/all_import.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  final String? id;
  final String? categoryName;
  final String? subCategoryName;

  const ProductDetailsView({
    Key? key, 
    this.id, 
    this.categoryName, 
    this.subCategoryName
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
                // Header with Back Button
                Container(
                  padding: EdgeInsets.all(1.5.h),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Go back to products list
                          Get.find<ProductsController>().productDetails.value = false;
                          Get.find<HomeController>().update();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.primaryColor,
                        ),
                        tooltip: 'Back to Products',
                      ),
                      SizedBox(width: 1.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Details',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                            if (controller.getDetailsData?.name != null)
                              Text(
                                controller.getDetailsData!.name!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.greyColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
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
        // Product Image Card
        if (controller.getDetailsData?.imageUrl != null)
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 25.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.greyLightColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '${Constants.imageBaseUrl}${controller.getDetailsData!.imageUrl}',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 25.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                            color: AppColors.greyColor,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Image not available',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

        SizedBox(height: 2.h),

        // Product Information Cards
        _buildInfoCard('Basic Information', [
          _buildInfoRow('ID', id ?? 'N/A'),
          _buildInfoRow('Name', controller.getDetailsData?.name ?? 'N/A'),
          if (categoryName != null && categoryName!.isNotEmpty)
            _buildInfoRow('Category', categoryName!),
          if (subCategoryName != null && subCategoryName!.isNotEmpty)
            _buildInfoRow('Sub Category', subCategoryName!),
        ]),

        SizedBox(height: 1.h),

        _buildInfoCard('Pricing & Stock', [
          _buildInfoRow(
            'Selling Price', 
            '\$${controller.getDetailsData?.sellingPrice?.toString() ?? 'N/A'}',
            valueColor: AppColors.primaryColor,
            isPrice: true,
          ),
          _buildInfoRow(
            'Maximum Price', 
            '\$${controller.getDetailsData?.maximumSellingPrice?.toString() ?? 'N/A'}',
          ),
          _buildInfoRow(
            'Stock', 
            controller.getDetailsData?.stock?.toString() ?? 'N/A',
            valueColor: (controller.getDetailsData?.stock ?? 0) > 0 
                ? Colors.green 
                : Colors.red,
          ),
          _buildInfoRow(
            'Box Size', 
            controller.getDetailsData?.boxSize?.toString() ?? 'N/A',
          ),
        ]),

        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 1.h),
            Divider(color: AppColors.greyLightColor),
            SizedBox(height: 1.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label, 
    String value, {
    Color? valueColor,
    bool isPrice = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Text(
              value,
              style: TextStyle(
                fontSize: isPrice ? 14.sp : 13.sp,
                fontWeight: isPrice ? FontWeight.w600 : FontWeight.normal,
                color: valueColor ?? AppColors.greyColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
