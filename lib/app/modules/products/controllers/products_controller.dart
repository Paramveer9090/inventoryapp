import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class ProductsController extends GetxController {
  List<GetDataListResponseData> productList = <GetDataListResponseData>[];
  List<GetDataListResponseData> categoryList = <GetDataListResponseData>[];

  List<GetDataListResponseData> filterList = [];
  var productDetails = false.obs;
  var noData = "".obs;

  ///for sendData
  var categoryType = "".obs;
  var subCategoryType = "".obs;
  var id = "".obs;

  // Selection and UI state
  var selectedProducts = <GetDataListResponseData>[].obs;
  var isGridView = true.obs;
  var selectAll = false.obs;
  var isSelectionMode = false.obs;

  // Pagination state
  var currentPage = 1.obs;
  var itemsPerPage = 50; // Show 50 products per page
  var isLoadingMore = false.obs;
  var hasMoreItems = true.obs;
  List<GetDataListResponseData> allProductsList = []; // Store all products
  List<GetDataListResponseData> paginatedProductList = <GetDataListResponseData>[].obs; // Currently displayed products

  @override
  void onInit() {
    getProductAPI();
    getCategoriesAPI();
    super.onInit();
  }

  // Pagination Methods
  void loadMoreProducts() {
    if (!hasMoreItems.value || isLoadingMore.value) return;
    
    isLoadingMore.value = true;
    print('📄 Loading more products - Page: ${currentPage.value + 1}');
    
    int startIndex = currentPage.value * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, productList.length);
    
    if (startIndex < productList.length) {
      List<GetDataListResponseData> newItems = productList.sublist(startIndex, endIndex);
      paginatedProductList.addAll(newItems);
      currentPage.value++;
      
      print('📄 Added ${newItems.length} products. Total displayed: ${paginatedProductList.length}');
      
      // Check if we have more items
      hasMoreItems.value = endIndex < productList.length;
    } else {
      hasMoreItems.value = false;
    }
    
    isLoadingMore.value = false;
    update();
  }

  void resetPagination() {
    print('📄 Resetting pagination');
    currentPage.value = 1;
    hasMoreItems.value = true;
    paginatedProductList.clear();
    
    // Load first page
    if (productList.isNotEmpty) {
      int endIndex = itemsPerPage.clamp(0, productList.length);
      paginatedProductList.addAll(productList.sublist(0, endIndex));
      hasMoreItems.value = endIndex < productList.length;
      print('📄 Initial load: ${paginatedProductList.length} products');
    }
    update();
  }

  /// Search
  search({required String text}) async {
    if (text.trim().isEmpty) {
      productList = filterList; // filterList already contains only products with stock
      noData.value = "";
    } else {
      List<GetDataListResponseData> tempList = [];
      for (int i = 0; i < filterList.length; i++) {
        // filterList already contains only products with stock > 0
        if (filterList[i]
                .name
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            filterList[i]
                .categoryType!
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            filterList[i]
                .subCategoryType!
                .toLowerCase()
                .contains(text.toLowerCase())) {
          tempList.add(filterList[i]);
        }
      }
      
      // Set noData message only after checking all items
      if (tempList.isEmpty) {
        noData.value = "No result found";
      } else {
        noData.value = "";
      }
      
      productList = tempList;
    }
    
    // Reset pagination after search
    resetPagination();
    update();
  }

  /// Get Products (filtered to show only products with stock > 0)
  getProductAPI({bool isLoading = true}) async {
    final data = await APIFunction().apiCall(
      apiName: Constants.products,
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: isLoading,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      // Filter out products with zero stock - only show products with stock > 0
      List<GetDataListResponseData> productsWithStock = model.data!
          .where((product) => product.stock != null && product.stock! > 0)
          .toList();
      
      productList = productsWithStock;
      filterList = productsWithStock;
      allProductsList = productsWithStock; // Store all products with stock

      // Initialize pagination
      resetPagination();
      update();
    }
  }

  /// Get Category
  getCategoriesAPI() async {
    final data = await APIFunction().apiCall(
      apiName: "${Constants.categories}/0",
      context: Get.context!,
      token: accessToken,
      type: "get",
      isLoading: false,
    );

    GetDataListResponseModel model = GetDataListResponseModel.fromJson(data);

    if (model.data!.isNotEmpty) {
      categoryList = model.data!;
      update();
    } else {
      print("In else part");
    }
  }

  // Selection Methods
  void toggleProductSelection(GetDataListResponseData product) {
    print('🔧 toggleProductSelection called for: ${product.name}');
    print('🔧 Product ID: ${product.id}');
    print('🔧 Selected products before: ${selectedProducts.length}');
    print('🔧 Is product currently selected: ${selectedProducts.contains(product)}');
    
    if (selectedProducts.contains(product)) {
      print('🔧 REMOVING product from selection');
      selectedProducts.remove(product);
      print('🔧 Remove result - Selected products after: ${selectedProducts.length}');
    } else {
      print('🔧 ADDING product to selection');
      selectedProducts.add(product);
      print('🔧 Add result - Selected products after: ${selectedProducts.length}');
    }
    
    print('🔧 Final selection state - Contains product: ${selectedProducts.contains(product)}');
    updateSelectAllState();
  }

  void toggleSelectAll() {
    if (selectAll.value) {
      // Deselect all currently displayed products
      for (var product in paginatedProductList) {
        selectedProducts.remove(product);
      }
      selectAll.value = false;
    } else {
      // Select all currently displayed products
      for (var product in paginatedProductList) {
        if (!selectedProducts.contains(product)) {
          selectedProducts.add(product);
        }
      }
      selectAll.value = true;
    }
  }

  void updateSelectAllState() {
    // Check if all currently displayed products are selected
    selectAll.value = paginatedProductList.isNotEmpty && 
                     paginatedProductList.every((product) => selectedProducts.contains(product));
  }

  void clearSelection() {
    selectedProducts.clear();
    selectAll.value = false;
  }

  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      // Exit selection mode - clear all selections
      selectedProducts.clear();
      selectAll.value = false;
    }
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedProducts.clear();
    selectAll.value = false;
  }

  // PDF Export Methods
  Future<Uint8List> generateSelectedProductsPdf() async {
    final pdf = pw.Document();

    // Load logo
    Uint8List? logoBytes;
    try {
      final ByteData data = await rootBundle.load('assets/images/logo.png');
      logoBytes = data.buffer.asUint8List();
    } catch (e) {
      // Handle logo loading error silently
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                logoBytes != null
                    ? pw.Image(pw.MemoryImage(logoBytes), width: 60, height: 60)
                    : pw.Container(),
                pw.Text(
                  'Selected Products Export',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          );
        },
        build: (context) => [
          pw.SizedBox(height: 20),
          pw.Text(
            'Exported on: ${DateTime.now().toString().split('.')[0]}',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Text(
            'Total Products: ${selectedProducts.length}',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          
          // Table format
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(1.5),
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'ID',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Product Name',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Category',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Sub Category',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Price (\$)',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Stock',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
              
              // Data rows - limit to first 100 products to avoid too many pages
              ...selectedProducts.take(100).map((product) => pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      product.id?.toString() ?? 'N/A',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      product.name ?? 'No Name',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      product.categoryType ?? 'No Category',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      product.subCategoryType ?? 'No Sub-Category',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      '${product.sellingPrice ?? 0}',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      '${product.stock ?? 0}',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              )).toList(),
            ],
          ),
          
          if (selectedProducts.length > 100)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 20),
              child: pw.Text(
                'Note: Only first 100 products are shown in this export to prevent performance issues.',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey600,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> exportSelectedProductsPdf() async {
    if (selectedProducts.isEmpty) {
      Get.snackbar(
        'No Selection',
        'Please select at least one product to export.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final pdfBytes = await generateSelectedProductsPdf();
      
      // On mobile, use share instead of file picker
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'selected_products_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      
      Get.snackbar(
        'Success',
        'PDF export initiated! Choose where to save or share.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle PDF export error silently
      Get.snackbar(
        'Error',
        'Failed to export PDF. Please try with fewer products.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> sharePdf() async {
    if (selectedProducts.isEmpty) {
      Get.snackbar(
        'No Selection',
        'Please select at least one product to share.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final pdfBytes = await generateSelectedProductsPdf();
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'selected_products_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      // Handle PDF sharing error silently
      Get.snackbar(
        'Error',
        'Failed to share PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
