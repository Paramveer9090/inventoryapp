import 'package:true_leaf_inventory_app/app/api_repository/api_function.dart';
import 'package:true_leaf_inventory_app/app/models/login_signup_response_model.dart';
import 'package:true_leaf_inventory_app/app/routes/app_pages.dart';
import 'package:true_leaf_inventory_app/app/utils/app_string.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController(text: "tejas+sales@test.com");
  TextEditingController password = TextEditingController(text: "Maven@123");

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
        getStorageData.saveString(Constants.access_token, model.accessToken);
        getStorageData.saveString(Constants.login_id, model.data![0].id);
        await getStorageData.saveObject(getStorageData.loginData, model.data![0]);
        Get.offAllNamed(Routes.HOME);
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
    } else if (!utils.passwordValidator(password.text.trim())) {
      utils.showSnackBar(context: Get.context!, message: AppStrings.errorMessageValidPassword);
      return false;
    }
    return true;
  }
}
