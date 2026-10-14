import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/modules/products/controllers/products_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/products/repositories/products_repository.dart';

class _FakeProductsRepository implements ProductsRepository {
  _FakeProductsRepository({required this.products, required this.categories});

  final Future<GetDataListResponseModel> products;
  final Future<GetDataListResponseModel> categories;

  @override
  Future<GetDataListResponseModel> fetchProducts() => products;

  @override
  Future<GetDataListResponseModel> fetchCategories() => categories;
}

GetDataListResponseModel _response(List<GetDataListResponseData>? data) {
  return GetDataListResponseModel(data: data);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('keeps zero-stock products in inventory but excludes them from display',
      () async {
    final controller = ProductsController(
      repository: _FakeProductsRepository(
        products: Future.value(_response([
          GetDataListResponseData(id: 1, name: 'Available', stock: 4),
          GetDataListResponseData(id: 2, name: 'Out', stock: 0),
          GetDataListResponseData(id: 3, name: 'Unknown', stock: null),
        ])),
        categories: Future.value(_response([])),
      ),
    );

    await controller.loadInitialData();

    expect(controller.allInventoryProducts, hasLength(3));
    expect(controller.productList.map((product) => product.id), [1]);
    controller.onClose();
  });

  test('shows an empty state when the API has no product data', () async {
    final controller = ProductsController(
      repository: _FakeProductsRepository(
        products: Future.value(_response(null)),
        categories: Future.value(_response(null)),
      ),
    );

    await controller.loadInitialData();

    expect(controller.productList, isEmpty);
    expect(controller.noData.value, 'No products in stock');
    controller.onClose();
  });

  test('shows a recoverable state when a request fails', () async {
    final controller = ProductsController(
      repository: _FakeProductsRepository(
        products: Future.error(Exception('network unavailable')),
        categories: Future.value(_response([])),
      ),
    );

    await controller.loadInitialData();

    expect(controller.productList, isEmpty);
    expect(controller.noData.value, contains('try again'));
    controller.onClose();
  });

  test('maps categories even when products resolve first', () async {
    final productCompleter = Completer<GetDataListResponseModel>();
    final categoryCompleter = Completer<GetDataListResponseModel>();
    final product = GetDataListResponseData(
      id: 10,
      name: 'Leaf mix',
      stock: 3,
      categoryId: 7,
      subCategoryId: 8,
    );
    final controller = ProductsController(
      repository: _FakeProductsRepository(
        products: productCompleter.future,
        categories: categoryCompleter.future,
      ),
    );

    final load = controller.loadInitialData();
    productCompleter.complete(_response([product]));
    await Future<void>.delayed(Duration.zero);
    categoryCompleter.complete(_response([
      GetDataListResponseData(id: 7, name: 'Plants'),
      GetDataListResponseData(id: 8, name: 'Indoor'),
    ]));
    await load;

    expect(product.categoryType, 'Plants');
    expect(product.subCategoryType, 'Indoor');
    controller.onClose();
  });

  test('opens and closes product details without a HomeController', () {
    Get.reset();
    final controller = ProductsController(
      repository: _FakeProductsRepository(
        products: Future.value(_response([])),
        categories: Future.value(_response([])),
      ),
    );
    final product = GetDataListResponseData(
      id: 20,
      categoryType: 'Plants',
      subCategoryType: 'Indoor',
      description: 'Product description',
    );

    controller.openProductDetails(product);

    expect(controller.productDetails.value, isTrue);
    expect(controller.id.value, '20');
    expect(controller.categoryType.value, 'Plants');
    expect(controller.subCategoryType.value, 'Indoor');
    expect(controller.descriptionText.value, 'Product description');

    controller.closeProductDetails();
    expect(controller.productDetails.value, isFalse);
    controller.onClose();
    Get.reset();
  });
}
