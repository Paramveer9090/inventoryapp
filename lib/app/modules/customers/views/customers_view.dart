import 'package:true_leaf_inventory_app/app/modules/customer_details/views/customer_details_view.dart';
import 'package:true_leaf_inventory_app/app/modules/customers/views/widgets/customer_list_tile.dart';
import 'package:true_leaf_inventory_app/app/modules/customers/views/widgets/customers_empty_state.dart';
import 'package:true_leaf_inventory_app/app/modules/customers/views/widgets/customers_header.dart';
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
              CustomersHeader(
                searchController: searchController,
                onSearchChanged: (value) {
                  controller.onSearchChanged(value);
                  controller.update();
                },
                totalCount: controller.customerList.length,
                filteredCount: controller.filterList.length,
              ),

              // Content Area
              Expanded(
                child: controller.noData.value.isNotEmpty
                    ? CustomersEmptyState(
                        icon: Icons.search_off,
                        message: controller.noData.value,
                      )
                    : controller.customerList.isEmpty
                        ? const CustomersEmptyState(
                            icon: Icons.people_outline,
                            message: 'No customers found',
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(0.8.h),
                            itemCount: controller.customerList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = controller.customerList[index];
                              return CustomerListTile(
                                data: data,
                                controller: controller,
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
