import 'package:true_leaf_inventory_app/app/modules/product_details/views/product_details_view.dart';
import '../../../widgets/all_import.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      init: ProductsController(),
      assignId: true,
      builder: (controller) {
        return controller.productDetails.value
            ? ProductDetailsView(
                id: controller.id.value,
                categoryName: controller.categoryType.value,
                subCategoryName: controller.subCategoryType.value,
              )
            : GestureDetector(
                onTap: () {
                  utils.hideKeyboard(context);
                },
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CustomSearchBar(
                        hint: 'Search',
                        onChanged: (value) {
                          controller.search(text: value);
                          controller.update();
                        },
                      ),
                    ),
                    controller.noData.value != ""
                        ? Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Center(
                                child: AppText(
                              controller.noData.value,
                              fontSize: 13.sp,
                              color: AppColors.greyColor,
                            )),
                          )
                        : CustomTable(
                            dataLength: controller.productList.length,
                            columns: [
                              DataColumn(
                                label: AppText(
                                  'Id',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Name',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Category',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Sub-Category',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Max Sell Price',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Min Sell Price',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Stock',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Image',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Box Size',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                              DataColumn(
                                label: AppText(
                                  'Action',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                            rows: [
                              ...controller.productList.asMap().entries.map(
                                (product) {
                                  for (int i = 0; i < controller.categoryList.length; i++) {
                                    if (controller.categoryList[i].id == product.value.categoryId) {
                                      product.value.categoryType = controller.categoryList[i].name!;
                                    }

                                    if (controller.categoryList[i].id == product.value.subCategoryId) {
                                      product.value.subCategoryType = controller.categoryList[i].name!;
                                    }
                                  }

                                  controller.update();
                                  return DataRow(
                                    color: MaterialStatePropertyAll(
                                      product.key.isEven ? AppColors.greyLightColor : AppColors.whiteColor,
                                    ),
                                    cells: [
                                      DataCell(
                                        Text(product.value.id.toString()),
                                      ),
                                      DataCell(
                                        Text(product.value.name.toString()),
                                      ),
                                      DataCell(
                                        Text(product.value.categoryType.toString()),
                                      ),
                                      DataCell(
                                        Text(product.value.subCategoryType.toString()),
                                      ),
                                      DataCell(
                                        Text(product.value.maximumSellingPrice.toString()),
                                      ),
                                      DataCell(
                                        Text(product.value.sellingPrice.toString()),
                                      ),
                                      DataCell(
                                        Text(product.value.stock.toString()),
                                      ),
                                      DataCell(
                                        product.value.imageUrl == null
                                            ? const Text('No Image')
                                            : Image.network(
                                                '${Constants.imageBaseUrl}${product.value.imageUrl}',
                                                width: 48,
                                              ),
                                      ),
                                      DataCell(
                                        Text(product.value.boxSize.toString()),
                                      ),
                                      DataCell(
                                        CustomTableCellActionButtons(
                                          showEditButton: false,
                                          showDeleteButton: false,
                                          onView: () {
                                            controller.productDetails.value = true;
                                            Get.find<HomeController>().update();
                                            controller.update();
                                            print(controller.productDetails.value);
                                            print("controller.productDetails.value");
                                            controller.id.value = product.value.id.toString();
                                            controller.categoryType.value = product.value.categoryType!;
                                            controller.subCategoryType.value = product.value.subCategoryType!;
                                            // Get.toNamed(Routes.PRODUCT_DETAILS, arguments: {
                                            //   "id": product.value.id.toString(),
                                            //   "name": product.value.name,
                                            //   "category": product.value.categoryType,
                                            //   "sub-category": product.value.subCategoryType,
                                            //   "maxSellPrice": product.value.maximumSellingPrice.toString(),
                                            //   "minSellPrice": product.value.sellingPrice.toString(),
                                            //   "stock": product.value.stock.toString(),
                                            //   // "tax": product.value.taxDetail != null ? product.value.taxDetail!.title : "",
                                            //   // "tax_id": product.value.taxId,
                                            //   "image": '${Constants.imageBaseUrl}${product.value.imageUrl}',
                                            //   "boxSize": product.value.boxSize.toString(),
                                            //   "screen": "product",
                                            // });
                                          },
                                          onEdit: () {},
                                          onDelete: () {},
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).toList()
                            ],
                          ),
                  ],
                ),
              );
      },
    );
  }
}
