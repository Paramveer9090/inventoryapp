import '../../../widgets/all_import.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  final id;
  final categoryName;
  final subCategoryName;

  const ProductDetailsView({Key? key, this.id, this.categoryName, this.subCategoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
      init: ProductDetailsController(id: id),
      assignId: true,
      builder: (controller) {
        return controller.getDetailsData == null
            ? Container()
            : ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 3.h),
                children: [
                  DetailsBox(
                    title: "Id",
                    value: id,
                  ),
                  DetailsBox(
                    title: "Name",
                    value: controller.getDetailsData?.name,
                  ),
                  categoryName == null || categoryName == ""
                      ? Container()
                      : DetailsBox(
                          title: "Category",
                          value: categoryName,
                        ),
                  subCategoryName == null || subCategoryName == ""
                      ? Container()
                      : DetailsBox(
                          title: "Sub Category",
                          value: subCategoryName,
                        ),
                  DetailsBox(
                    title: "Maximum Selling Price",
                    value: controller.getDetailsData?.maximumSellingPrice.toString(),
                  ),
                  DetailsBox(
                    title: "Minimum Selling Price",
                    value: controller.getDetailsData?.sellingPrice.toString(),
                  ),
                  DetailsBox(
                    title: "Stock",
                    value: controller.getDetailsData?.stock.toString(),
                  ),
                  DetailsBox(
                    title: "Product Image",
                    isImage: true,
                    imagePath: controller.getDetailsData?.imageUrl.toString(),
                  ),
                  DetailsBox(
                    title: "Box Size",
                    value: controller.getDetailsData?.boxSize.toString(),
                  ),
                ],
              );
      },
    );
  }
}

class DetailsBox extends StatelessWidget {
  final title;
  final value;
  final isImage;
  final imagePath;

  const DetailsBox({super.key, this.title, this.value, this.isImage = false, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            fontSize: 13.sp,
          ),
          isImage
              ? Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image.network(
                    '${Constants.imageBaseUrl}${imagePath}',
                    height: 15.h,
                  ),
                )
              : AppText(value ?? ""),
          SizedBox(height: 1.h),
          Divider(),
          SizedBox(height: 1.h)
        ],
      ),
    );
  }
}
