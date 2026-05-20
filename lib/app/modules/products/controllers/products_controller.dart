import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  var descriptionText = ""
      .obs; // holds description_invoice/description fallback for routing to details

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
  List<GetDataListResponseData> paginatedProductList =
      <GetDataListResponseData>[].obs; // Currently displayed products

  // Debouncing for search
  Timer? _debounce;

  int _compareByName(GetDataListResponseData a, GetDataListResponseData b) {
    final aName = (a.name ?? '').trim().toLowerCase();
    final bName = (b.name ?? '').trim().toLowerCase();
    return aName.compareTo(bName);
  }

  @override
  void onInit() {
    getProductAPI();
    getCategoriesAPI();
    super.onInit();
  }

  // Pagination Methods
  /// Debounced search - only runs after user stops typing
  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(text: value);
    });
  }

  void loadMoreProducts() {
    if (!hasMoreItems.value || isLoadingMore.value) return;

    isLoadingMore.value = true;

    int startIndex = currentPage.value * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, productList.length);

    if (startIndex < productList.length) {
      List<GetDataListResponseData> newItems =
          productList.sublist(startIndex, endIndex);
      paginatedProductList.addAll(newItems);
      currentPage.value++;

      // Check if we have more items
      hasMoreItems.value = endIndex < productList.length;
    } else {
      hasMoreItems.value = false;
    }

    isLoadingMore.value = false;
    update();
  }

  void resetPagination() {
    currentPage.value = 1;
    hasMoreItems.value = true;
    paginatedProductList.clear();

    // Load first page
    if (productList.isNotEmpty) {
      int endIndex = itemsPerPage.clamp(0, productList.length);
      paginatedProductList.addAll(productList.sublist(0, endIndex));
      hasMoreItems.value = endIndex < productList.length;
    }
    update();
  }

  /// Improved search with better performance and relevance ranking
  search({required String text}) async {
    // Trim whitespace from search text
    final searchText = text.trim();

    if (searchText.isEmpty) {
      productList =
          filterList; // filterList already contains only products with stock
      noData.value = "";
    } else {
      // Convert search text to lowercase once for efficiency
      final searchLower = searchText.toLowerCase();

      // Use where() instead of loop for better performance
      List<GetDataListResponseData> tempList = filterList.where((product) {
        // Search in product name
        final nameMatch =
            product.name?.toLowerCase().contains(searchLower) ?? false;

        // Search in category type
        final categoryMatch =
            product.categoryType?.toLowerCase().contains(searchLower) ?? false;

        // Search in sub-category type
        final subCategoryMatch =
            product.subCategoryType?.toLowerCase().contains(searchLower) ??
                false;

        // Search in product ID (for quick lookup by ID)
        final idMatch = product.id?.toString().contains(searchText) ?? false;

        // Search in description if available
        final descriptionMatch =
            product.description?.toLowerCase().contains(searchLower) ?? false;

        // Return true if any field matches
        return nameMatch ||
            categoryMatch ||
            subCategoryMatch ||
            idMatch ||
            descriptionMatch;
      }).toList();

      // Sort results by relevance: exact matches first, then starts-with, then contains
      tempList.sort((a, b) {
        final aName = a.name?.toLowerCase() ?? '';
        final bName = b.name?.toLowerCase() ?? '';

        // Exact name matches come first (highest priority)
        if (aName == searchLower && bName != searchLower) return -1;
        if (bName == searchLower && aName != searchLower) return 1;

        // Then matches that start with the search text
        final aStartsWith = aName.startsWith(searchLower);
        final bStartsWith = bName.startsWith(searchLower);
        if (aStartsWith && !bStartsWith) return -1;
        if (bStartsWith && !aStartsWith) return 1;

        // Tie-breaker: alphabetical by product name
        return aName.compareTo(bName);
      });

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

      // Map category names to products ONCE here instead of in UI
      _mapCategoryNamesToProducts(productsWithStock);

      // Keep base product collections alphabetically sorted by name
      productsWithStock.sort(_compareByName);

      productList = productsWithStock;
      filterList = productsWithStock;
      allProductsList = productsWithStock; // Store all products with stock

      // Initialize pagination
      resetPagination();
      update();
    }
  }

  /// Map category and subcategory names to products
  /// This is done ONCE when data is fetched, not repeatedly in UI
  /// Uses Map for O(n) performance instead of nested loops O(n*m)
  void _mapCategoryNamesToProducts(List<GetDataListResponseData> products) {
    if (categoryList.isEmpty) return;

    // Create a fast lookup map: categoryId -> categoryName
    Map<int, String> categoryMap = {};
    for (var cat in categoryList) {
      if (cat.id != null) {
        categoryMap[cat.id!] = cat.name ?? '';
      }
    }

    // Update all products at once using the map
    for (var product in products) {
      if (product.categoryId != null) {
        product.categoryType = categoryMap[product.categoryId] ?? '';
      }
      if (product.subCategoryId != null) {
        product.subCategoryType = categoryMap[product.subCategoryId] ?? '';
      }
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
    }
  }

  // Selection Methods
  void toggleProductSelection(GetDataListResponseData product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
    updateSelectAllState();
  }

  void toggleSelectAll() {
    if (selectAll.value) {
      // Deselect everything
      selectedProducts.clear();
      selectAll.value = false;
    } else {
      // Select every loaded product, not just the currently visible page.
      selectedProducts.assignAll(allProductsList);
      selectAll.value = true;
    }
  }

  void updateSelectAllState() {
    // Check if all currently displayed products are selected
    selectAll.value = paginatedProductList.isNotEmpty &&
        paginatedProductList
            .every((product) => selectedProducts.contains(product));
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
                    ? pw.Image(pw.MemoryImage(logoBytes),
                        width: 60, height: 60, fit: pw.BoxFit.contain)
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
            'Exported on: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
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
              2: const pw.FlexColumnWidth(4),
              3: const pw.FlexColumnWidth(1.5),
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
                      'S.No',
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
                      'Description',
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
                ],
              ),

              // Data rows (use sequential serial numbers starting at 1)
              ...selectedProducts.asMap().entries.map((entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              '${entry.key + 1}',
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              entry.value.name ?? 'No Name',
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              entry.value.descriptionInvoice ??
                                  entry.value.description ??
                                  'No description',
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              '${entry.value.sellingPrice ?? 0}',
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      )).toList(),
            ],
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
        filename:
            'selected_products_${DateTime.now().millisecondsSinceEpoch}.pdf',
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
        filename:
            'selected_products_${DateTime.now().millisecondsSinceEpoch}.pdf',
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
