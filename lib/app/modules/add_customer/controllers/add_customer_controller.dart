import '../../../widgets/all_import.dart';
import '../../customers/controllers/customers_controller.dart';

class AddCustomerController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController paymentTermsController = TextEditingController();

  final isLoading = false.obs;

  void _showError(String message) {
    Get.snackbar(
      'Customer',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(2.h),
      borderRadius: 12,
      backgroundColor: Colors.red.shade600,
      colorText: AppColors.whiteColor,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    companyNameController.dispose();
    contactNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    paymentTermsController.dispose();
    super.onClose();
  }

  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      _showError('Please enter customer name');
      return false;
    }

    if (companyNameController.text.trim().isEmpty) {
      _showError('Please enter company name');
      return false;
    }

    if (contactNameController.text.trim().isEmpty) {
      _showError('Please enter contact name');
      return false;
    }

    if (phoneNumberController.text.trim().isEmpty) {
      _showError('Please enter phone number');
      return false;
    }

    if (addressController.text.trim().isEmpty) {
      _showError('Please enter address');
      return false;
    }

    if (paymentTermsController.text.trim().isEmpty) {
      _showError('Please enter payment terms');
      return false;
    }

    return true;
  }

  Future<void> saveCustomer() async {
    if (!validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Saving customer...');

      final payload = {
        'name': nameController.text.trim(),
        'company_name': companyNameController.text.trim(),
        'contact_name': contactNameController.text.trim(),
        'phone_number': phoneNumberController.text.trim(),
        'address': addressController.text.trim(),
        'payment_terms': paymentTermsController.text.trim(),
        if (emailController.text.trim().isNotEmpty) 'email': emailController.text.trim(),
        if (pincodeController.text.trim().isNotEmpty) 'pincode': pincodeController.text.trim(),
      };

      final data = await APIFunction().apiCall(
        apiName: Constants.customers,
        context: Get.context!,
        token: accessToken,
        type: 'post',
        rawData: jsonEncode(payload),
        isLoading: false,
      );

      final bool hasExplicitFailure = data is Map &&
          (data['success'] == false || data['status'] == false || data['error'] != null);

      if (hasExplicitFailure) {
        throw Exception(data['message']?.toString() ?? 'Failed to add customer');
      }

      if (Get.isRegistered<CustomersController>()) {
        await Get.find<CustomersController>().getCustomerAPI(isLoading: false);
      }

      EasyLoading.showSuccess('Customer added successfully');
      Get.back();
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      _showError(message);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}