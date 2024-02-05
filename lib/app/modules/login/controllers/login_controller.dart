import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController(/*text: "tejas+sales@test.com"*/);
  TextEditingController password = TextEditingController(/*text: "Maven@123"*/);

  @override
  void onInit() {
    super.onInit();
  }

  loginAPI() async {
    try {
      FormData formData = FormData.fromMap({
        'email': email.text,
        'password': password.text,
      });

      final data = await APIFunction().apiCall(
        apiName: Constants.login,
        context: Get.context!,
        params: formData,
      );

      LoginAndSignUpResponseModel model = LoginAndSignUpResponseModel.fromJson(data);

      if (model.message == null) {
        if (model.data![0].roles![0].title != "Admin" && model.data![0].roles![0].title != "Website Admin") {
          getStorageData.saveString(Constants.access_token, model.accessToken);
          getStorageData.saveString(Constants.login_id, model.data![0].id);

          await getStorageData.saveObject(getStorageData.loginData, model.data![0]);
          Get.offAllNamed(Routes.HOME);
        } else {
          utils.showSnackBar(context: Get.context!, message: "This credentials for admin so you can login in the website.");
        }
        update();
      } else {
        print("In else part");
      }
    } on Exception catch (error) {
      print(error);
      utils.showSnackBar(context: Get.context!, message: "Invalid credentials");
    }
  }

  /// validation
  bool isValidation() {
    if (utils.isValidationEmpty(email.text.trim())) {
      utils.showSnackBar(context: Get.context!, message: AppStrings.errorMessageEmail);
      return false;
    } else if (!utils.emailValidator(email.text.trim())) {
      utils.showSnackBar(context: Get.context!, message: AppStrings.errorMessageValidEmail);
      return false;
    } else if (utils.isValidationEmpty(password.text.trim())) {
      utils.showSnackBar(context: Get.context!, message: AppStrings.errorMessagePassword);
      return false;
    }
    return true;
  }
}
