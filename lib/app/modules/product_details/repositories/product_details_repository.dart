import 'package:image_picker/image_picker.dart';
import 'package:true_leaf_inventory_app/app/models/details_response_model.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

abstract class ProductDetailsRepository {
  Future<GetDetailsResponseModel> fetchProductDetails(String id);
  Future<GetDataListResponseModel> fetchCategories();
  Future<GetDataListResponseModel> fetchSubCategories(String categoryId);
  Future<String?> uploadProductImage(XFile image, String fileName);
  Future<dynamic> updateProduct(
    String id,
    Map<String, dynamic> body, {
    bool isLoading = true,
  });
}

class ApiProductDetailsRepository implements ProductDetailsRepository {
  @override
  Future<GetDetailsResponseModel> fetchProductDetails(String id) async {
    final data = await APIFunction().apiCall(
      apiName: '${Constants.products}/$id',
      context: Get.context!,
      token: accessToken,
      type: 'get',
      isLoading: false,
    );

    return GetDetailsResponseModel.fromJson(data);
  }

  @override
  Future<GetDataListResponseModel> fetchCategories() async {
    final data = await APIFunction().apiCall(
      apiName: '${Constants.categories}/0',
      context: Get.context!,
      token: accessToken,
      type: 'get',
      isLoading: false,
    );

    return GetDataListResponseModel.fromJson(data);
  }

  @override
  Future<GetDataListResponseModel> fetchSubCategories(String categoryId) async {
    final data = await APIFunction().apiCall(
      apiName: '${Constants.categories}/$categoryId',
      context: Get.context!,
      token: accessToken,
      type: 'get',
      isLoading: false,
    );

    return GetDataListResponseModel.fromJson(data);
  }

  @override
  Future<String?> uploadProductImage(XFile image, String fileName) async {
    final imageFile = MultipartFile.fromBytes(
      await image.readAsBytes(),
      filename: fileName,
    );
    final formData = FormData.fromMap({'upload_image': imageFile});

    final data = await APIFunction().apiCall(
      apiName: Constants.uploadImage,
      context: Get.context!,
      token: accessToken,
      params: formData,
      isLoading: false,
    );

    final imageUrl = data?['data']?['image_url'];
    if (imageUrl == null) {
      throw Exception('Invalid response from image upload');
    }
    return imageUrl.toString();
  }

  @override
  Future<dynamic> updateProduct(
    String id,
    Map<String, dynamic> body, {
    bool isLoading = true,
  }) {
    return APIFunction().apiCall(
      apiName: '${Constants.products}/$id',
      context: Get.context!,
      token: accessToken,
      type: 'put',
      rawData: jsonEncode(body),
      isLoading: isLoading,
    );
  }
}
