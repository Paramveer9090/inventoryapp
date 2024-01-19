import 'package:get_storage/get_storage.dart';
import 'package:true_leaf_inventory_app/app/utils/utils.dart';
import 'package:true_leaf_inventory_app/app/widgets/get_storage_data.dart';

Utils utils = Utils();
GetStorageData getStorageData = GetStorageData();
// final cartStoreData = GetStorage();

class Constants {
  /// Save String
  static const String access_token = "access_token";
  static const String login_id = "login_id";

  static const String baseUrl = 'http://trueleaf.mydevsite.co.za/api/v1/';

  /// Endpoints
  static const String login = 'login';
  static const String changePassword = 'change_password';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String taxes = 'taxes';
  static const String paymentMethods = 'payment-methods';
  static const String shrinkages = 'shrinkages';
  static const String suppliers = 'suppliers';
  static const String expenses = 'expenses';
  static const String creditNotes = 'credit-notes';
  static const String expensePayments = 'expense-payments';
  static const String customers = 'customers';
  static const String revenue = 'revenue';
  static const String orders = 'orders';
  static const String orderPayments = 'order-payments';
  static const String productCategory = 'product-category';
  static const String uploadImage = 'upload-image';
  static const String driverDashboard = 'driver-dashboard';
  static const String inventories = 'inventories';
  static const String getInvoices = 'get-invoices';
  static const String invoiceWithPendingAmt = 'invoice-with-pending-amt';
  static const String orderWithPendingAmt = 'order-with-pending-amount';
  static const String users = 'users';
  static const String payment = 'payment';
  static const String roles = 'roles';
  static const String dashboard = 'dashboard';
  static const String supplierDashboard = 'supplier-dashboard';
  static const String get_expense_report = 'reports/get_expense_report';
  static const String get_order_report = 'reports/get_order_report';
  static const String get_sales_person_orderreport = 'get_sales_person_orderreport';
  static const String get_product_expiry_report = 'reports/get_product_expiry_report';

  /// image url
  static const imageBaseUrl = 'https://inventoryapp.nyc3.cdn.digitaloceanspaces.com/staging/';
}
