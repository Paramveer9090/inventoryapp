import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/all_import.dart';
import '../../controllers/add_customer_controller.dart';

class CustomerFormSection extends StatelessWidget {
  final AddCustomerController controller;

  const CustomerFormSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Customer Information', required: true),
        SizedBox(height: 1.h),
        _buildTextField(
          controller: controller.nameController,
          label: 'Customer Name *',
          hint: 'Enter customer name',
          icon: Icons.person_outline,
        ),
        SizedBox(height: 1.5.h),
        _buildTextField(
          controller: controller.companyNameController,
          label: 'Company Name *',
          hint: 'Enter company name',
          icon: Icons.business_outlined,
        ),
        SizedBox(height: 1.5.h),
        _buildTextField(
          controller: controller.contactNameController,
          label: 'Contact Name *',
          hint: 'Enter contact name',
          icon: Icons.badge_outlined,
        ),
        SizedBox(height: 1.5.h),
        _buildTextField(
          controller: controller.phoneNumberController,
          label: 'Phone Number *',
          hint: 'Enter phone number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 2.h),
        _buildSectionTitle('Required Details', required: true),
        SizedBox(height: 1.h),
        _buildTextField(
          controller: controller.addressController,
          label: 'Address *',
          hint: 'Enter address',
          icon: Icons.location_on_outlined,
          maxLines: 3,
        ),
        SizedBox(height: 1.5.h),
        _buildTextField(
          controller: controller.paymentTermsController,
          label: 'Payment Terms *',
          hint: 'e.g. Net 30',
          icon: Icons.payments_outlined,
        ),
        SizedBox(height: 2.h),
        _buildSectionTitle('Optional Details'),
        SizedBox(height: 1.h),
        _buildTextField(
          controller: controller.emailController,
          label: 'Email',
          hint: 'Enter email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 1.5.h),
        _buildTextField(
          controller: controller.pincodeController,
          label: 'Pincode',
          hint: 'Enter pincode',
          icon: Icons.pin_outlined,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {bool required = false}) {
    return Text(
      required ? '$title *' : title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.blackColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return CustomTextFormField(
      controller: controller,
      label: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}