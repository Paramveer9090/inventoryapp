import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class ChangePasswordController extends GetxController {
  TextEditingController newPassword = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  LoginSignUpData? loginData;

  @override
  void onInit() {
    getLoginData();
    super.onInit();
  }

  getLoginData() async {
    final data = getStorageData.readObject(getStorageData.loginData);
    if (data != null) {
      loginData = LoginSignUpData.fromJson(data);
    }
    update();
  }

  changePasswordAPI() async {
    try {
      FormData formData = FormData.fromMap({
        'password': newPassword.text,
        'password_confirmation': repeatPassword.text,
        "email": loginData!.email,
      });

      final data = await APIFunction().apiCall(
        apiName: Constants.changePassword,
        context: Get.context!,
        params: formData,
        token: accessToken,
      );

      LoginAndSignUpResponseModel model = LoginAndSignUpResponseModel.fromJson(data);

      if (model.message!.isNotEmpty) {
        utils.showSnackBar(context: Get.context!, message: model.message.toString());
        Get.find<HomeController>().isSelected.value = 0;
        Get.find<HomeController>().update();
        update();
      } else {
        print("In else part");
      }
    } on Exception catch (error) {
      print(error);
      utils.showSnackBar(context: Get.context!, message: "Invalid credentials");
    }
  }

  bool isValidation() {
    if (utils.isValidationEmpty(newPassword.text.trim())) {
      utils.showSnackBar(context: Get.context!, message: AppStrings.errorMessagePassword);
      return false;
    } else if (utils.isValidationEmpty(newPassword.text.trim())) {
      utils.showSnackBar(context: Get.context!, message: AppStrings.errorMessageNewPassword);
      return false;
    } else if (utils.isValidationEmpty(repeatPassword.text.trim())) {
      utils.showSnackBar(context: Get.context!, message: AppStrings.errorMessageConfirmNewPassword);
      return false;
    } else if (newPassword.text.trim() != repeatPassword.text.trim()) {
      utils.showSnackBar(context: Get.context!, message: AppStrings.errorMessageValidConfirmPassword);
      return false;
    } else {
      return true;
    }
  }
}
