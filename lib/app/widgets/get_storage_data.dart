import 'package:get_storage/get_storage.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

/// <<< To store data in phone storage --------- >>>
class GetStorageData {
  String loginData = "loginData";
  String cartData = "cartData";

  /// <<< To save object data --------- >>>
  saveString(String key, value) async {
    final box = GetStorage();
    return box.write(key, value);
  }

  /// <<< To read object data --------- >>>
  readString(String key) {
    // final box = GetStorage();
    // if (box.hasData(key)) {
    //   return box.read(key);
    // } else {
    //   return null;
    // }

    String value = "";
    final box = GetStorage();

    if (containKey(key) && box.read(key) != null) {
      value = box.read(key);
    }
    return value;
  }

  /// <<< To remove data --------- >>>
  removeData(String key) async {
    if (containKey(key)) {
      final box = GetStorage();
      return box.remove(key);
    }
  }

  /// <<< To Store Key data --------- >>>
  bool containKey(String key) {
    final box = GetStorage();
    return box.hasData(key);
  }

  saveObject(String key, value) {
    final box = GetStorage();
    String allData = jsonEncode(value);
    box.write(key, allData);
  }

  readObject(String key) {
    final box = GetStorage();
    if (containKey(key) && box.read(key) != null) {
      var result = box.read(key);
      return jsonDecode(result);
    }
    return null;

    // LoginSignUpData? value=null;
    // final box = GetStorage();
    //
    // if (containKey(key) && box.read(key) != null) {
    //   var result = box.read(key);
    //   value = LoginSignUpData.fromJson(jsonDecode(result));
    // }
    // return value;
  }
}
