import 'package:intl/intl.dart';

import '../../../../widgets/all_import.dart';

class MyOrdersFilters extends StatelessWidget {
  final MyOrdersController controller;

  const MyOrdersFilters({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.8.h),
          child: CustomSearchBar(
            hint: 'Search orders...',
            onChanged: controller.onSearchChanged,
          ),
        ),
        SizedBox(height: 1.5.h),
        _buildFilters(context),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return GetBuilder<MyOrdersController>(
      builder: (_) => ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: const Icon(
          Icons.filter_list,
          color: AppColors.primaryColor,
        ),
        title: AppText(
          "Filters",
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
        subtitle: _activeFiltersText(),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _customerFilter(),
                SizedBox(height: 2.h),
                _dateRange(context),
                SizedBox(height: 2.h),
                _statusFilters(),
                SizedBox(height: 1.5.h),
                _clearFiltersButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerFilter() {
    return CustomDropDownSearch<Customers>(
      items: controller.customerList,
      itemAsString: (customer) => customer.name ?? '',
      label: AppStrings.selectCustomer,
      validator: (value) => Validators.canNotBeEmpty(
        value?.name,
        message: 'Please Select Customer',
      ),
      onChanged: (selectedCustomer) async {
        if (selectedCustomer == null) {
          controller.clearCustomerFilter();
        } else if (selectedCustomer.id != null) {
          controller.customer_id.value = selectedCustomer.id!.toString();
          controller.customerSearch(id: controller.customer_id.value);
          controller.update();
        }
      },
    );
  }

  Widget _dateRange(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: KeyedSubtree(
            key: ValueKey(controller.fromDateString.value),
            child: CustomDatePicker(
              initialValue: controller.fromDateString.value,
              hint: 'From',
              onTap: () => _pickDate(context, isFrom: true),
            ),
          ),
        ),
        SizedBox(width: 1.h),
        Expanded(
          child: KeyedSubtree(
            key: ValueKey(controller.toDateString.value),
            child: CustomDatePicker(
              initialValue: controller.toDateString.value,
              hint: 'To',
              onTap: () => _pickDate(context, isFrom: false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusFilters() {
    return Row(
      children: [
        _statusButton(
          label: "Pending",
          isSelected: controller.isPaidSelected.value,
          selectedColor: Colors.orange,
          onTap: () {
            controller.isUnPaidSelected.value = false;
            controller.isOverDueSelected.value = false;
            controller.isPaidSelected.value = !controller.isPaidSelected.value;
            if (controller.isPaidSelected.value) {
              controller.statusFilter('Pending');
            } else {
              controller.myOrderList = controller.filterList;
            }
            controller.update();
          },
        ),
        SizedBox(width: 1.w),
        _statusButton(
          label: "Ready",
          isSelected: controller.isOverDueSelected.value,
          selectedColor: Colors.blue,
          onTap: () {
            controller.isPaidSelected.value = false;
            controller.isUnPaidSelected.value = false;
            controller.isOverDueSelected.value = !controller.isOverDueSelected.value;
            if (controller.isOverDueSelected.value) {
              controller.statusFilter('Ready');
            } else {
              controller.myOrderList = controller.filterList;
            }
            controller.update();
          },
        ),
        SizedBox(width: 1.w),
        _statusButton(
          label: "Delivered",
          isSelected: controller.isUnPaidSelected.value,
          selectedColor: AppColors.lightGreen,
          onTap: () {
            controller.isPaidSelected.value = false;
            controller.isOverDueSelected.value = false;
            controller.isUnPaidSelected.value = !controller.isUnPaidSelected.value;
            if (controller.isUnPaidSelected.value) {
              controller.statusFilter('Delivered');
            } else {
              controller.myOrderList = controller.filterList;
            }
            controller.update();
          },
        ),
      ],
    );
  }

  Widget _statusButton({
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 4.h,
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: AppText(
              label,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.whiteColor : Colors.grey.shade600,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _clearFiltersButton() {
    return TextButton.icon(
      onPressed: controller.clearAllFilters,
      icon: const Icon(Icons.clear_all, size: 16),
      label: Text(
        'Clear All Filters',
        style: TextStyle(fontSize: 12.sp),
      ),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _activeFiltersText() {
    final List<String> activeFilters = [];

    if (controller.isPaidSelected.value) activeFilters.add("Pending");
    if (controller.isOverDueSelected.value) activeFilters.add("Ready");
    if (controller.isUnPaidSelected.value) activeFilters.add("Delivered");
    if (controller.customer_id.value.isNotEmpty) activeFilters.add("Customer");
    if (controller.fromDateString.value.isNotEmpty ||
        controller.toDateString.value.isNotEmpty) {
      activeFilters.add("Date Range");
    }

    if (activeFilters.isEmpty) {
      return AppText(
        "No filters applied",
        fontSize: 11.sp,
        color: Colors.grey.shade500,
      );
    }

    return AppText(
      "${activeFilters.length} filter${activeFilters.length > 1 ? 's' : ''} applied: ${activeFilters.join(', ')}",
      fontSize: 11.sp,
      color: AppColors.primaryColor,
    );
  }

  Future<void> _pickDate(BuildContext context, {required bool isFrom}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(-1000),
      lastDate: DateTime(3000),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(pickedDate);
      if (isFrom) {
        controller.fromDateString.value = formatted;
      } else {
        controller.toDateString.value = formatted;
      }

      if (controller.fromDateString.value.isNotEmpty &&
          controller.toDateString.value.isNotEmpty) {
        controller.dateFilter(
          startDate: DateTime.parse(controller.fromDateString.value),
          endDate: DateTime.parse(controller.toDateString.value),
        );
      }
      controller.update();
    }
  }
}
