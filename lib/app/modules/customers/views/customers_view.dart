import 'package:true_leaf_inventory_app/app/modules/customer_details/views/customer_details_view.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

import '../controllers/customers_controller.dart';

class CustomersView extends GetView<CustomersController> {
  const CustomersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Get.find to get existing controller or create one if it doesn't exist
    Get.put(CustomersController(), permanent: true);
    
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return GetBuilder<CustomersController>(
          builder: (controller) {
            return homeController.isCustomerDetails.value
                ? CustomerDetailsView(id: controller.id.value)
                : _CustomersListView();
          },
        );
      },
    );
  }
}

class _CustomersListView extends StatefulWidget {
  @override
  _CustomersListViewState createState() => _CustomersListViewState();
}

class _CustomersListViewState extends State<_CustomersListView> {
  final TextEditingController searchController = TextEditingController();
  late CustomersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CustomersController>();
    // Restore search text when widget is created
    searchController.text = controller.searchText.value;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomersController>(
      builder: (controller) {
        // Update search controller if search text changed
        if (searchController.text != controller.searchText.value) {
          searchController.text = controller.searchText.value;
        }
        
        return Scaffold(
          backgroundColor: AppColors.greyLightColor,
          body: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
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
                child: Column(
                  children: [
                    // Search Bar
                    CustomSearchBar(
                      controller: searchController,
                      hint: 'Search customers...',
                      onChanged: (value) {
                        controller.search(text: value);
                        controller.update();
                      },
                    ),
                    SizedBox(height: 1.h),
                    
                    // Customer Count Info
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 0.5.h),
                        Text(
                          '${controller.customerList.length} customers${controller.customerList.length != controller.filterList.length ? " (filtered from ${controller.filterList.length})" : ""}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Content Area
              Expanded(
                child: controller.noData.value.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(height: 2.h),
                            AppText(
                              controller.noData.value,
                              fontSize: 13.sp,
                              color: AppColors.greyColor,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : controller.customerList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 60,
                                  color: AppColors.greyColor,
                                ),
                                SizedBox(height: 2.h),
                                AppText(
                                  'No customers found',
                                  fontSize: 13.sp,
                                  color: AppColors.greyColor,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(1.h),
                            itemCount: controller.customerList.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              Customers data = controller.customerList[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 1.h),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () async {
                                    controller.id.value = await data.id.toString();
                                    controller.update();
                                    if (controller.id.value == customerCartId || cartLength == "" || cartLength == "0") {
                                      controller.id.value = await data.id.toString();
                                      controller.update();
                                      Get.find<HomeController>().isCustomerDetails.value = true;
                                      Get.find<HomeController>().update();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DeletePopup(
                                            isDelete: true,
                                            isConfirmation: true,
                                            confirmationText: "You want to change customer",
                                            onTap: () {
                                              Get.back();
                                              controller.deleteCartAPI();
                                            },
                                          );
                                        },
                                      );
                                      print("else ma jai 6e");
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Customer Avatar
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
                                        
                                        SizedBox(width: 12),
                                        
                                        // Customer Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                data.companyName.toString(),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                maxLines: 2,
                                                color: AppColors.blackColor,
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.person_outline,
                                                    size: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                  SizedBox(width: 4),
                                                  Expanded(
                                                    child: AppText(
                                                      data.name.toString(),
                                                      fontSize: 12.sp,
                                                      maxLines: 1,
                                                      color: Colors.grey[600]!,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone_outlined,
                                                    size: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                  SizedBox(width: 4),
                                                  AppText(
                                                    data.phoneNumber.toString(),
                                                    color: Colors.grey[600]!,
                                                    fontSize: 12.sp,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                        // Arrow Icon
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppColors.primaryColor,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

