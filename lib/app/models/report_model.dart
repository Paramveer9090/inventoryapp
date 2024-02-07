import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';

import '../widgets/all_import.dart';

class ReportModel {
  final List<Inventories>? inventories;
  final List<String>? status;
  final List<Suppliers>? suppliers;
  final List<Orders>? orders;
  final List<Customers>? customers;
  final List<ExpenseItems>? expenseItems;
  final List<Products>? products;
  final int? accept;
  final int? review;
  final dynamic unpaid;
  final dynamic paid;
  final dynamic totalOrder;
  final CustomerDetails? customerDetails;

  ReportModel({
    this.inventories,
    this.unpaid,
    this.paid,
    this.totalOrder,
    this.status,
    this.suppliers,
    this.orders,
    this.customers,
    this.expenseItems,
    this.products,
    this.accept,
    this.customerDetails,
    this.review,
  });

  ReportModel.fromJson(Map<String, dynamic> json)
      : accept = json['accept'] as int?,
        review = json['review'] as int?,
        unpaid = json['unpaid'],
        paid = json['paid'],
        totalOrder = json['total_order'],
        customerDetails = (json['customer_details'] as Map<String, dynamic>?) != null ? CustomerDetails.fromJson(json['customer_details'] as Map<String, dynamic>) : null,
        inventories = (json['inventories'] as List?)?.map((dynamic e) => Inventories.fromJson(e as Map<String, dynamic>)).toList(),
        status = (json['status'] as List?)?.map((dynamic e) => e as String).toList(),
        orders = (json['orders'] as List?)?.map((dynamic e) => Orders.fromJson(e as Map<String, dynamic>)).toList(),
        customers = (json['customers'] as List?)?.map((dynamic e) => Customers.fromJson(e as Map<String, dynamic>)).toList(),
        expenseItems = (json['expense_items'] as List?)?.map((dynamic e) => ExpenseItems.fromJson(e as Map<String, dynamic>)).toList(),
        products = (json['products'] as List?)?.map((dynamic e) => Products.fromJson(e as Map<String, dynamic>)).toList(),
        suppliers = (json['suppliers'] as List?)?.map((dynamic e) => Suppliers.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
        'accept': accept,
        'unpaid': unpaid,
        'paid': paid,
        'total_order': totalOrder,
        'customer_details': customerDetails?.toJson(),
        'review': review,
        'inventories': inventories?.map((e) => e.toJson()).toList(),
        'status': status,
        'orders': orders?.map((e) => e.toJson()).toList(),
        'customers': customers?.map((e) => e.toJson()).toList(),
        'suppliers': suppliers?.map((e) => e.toJson()).toList(),
        'expense_items': expenseItems?.map((e) => e.toJson()).toList(),
        'products': products?.map((e) => e.toJson()).toList()
      };
}

class Customer {
  final int? id;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final dynamic email;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final String? pincode;
  final String? companyName;
  final dynamic contactName;
  final String? paymentTerms;
  final dynamic creditNoteBalance;

  Customer({
    this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pincode,
    this.companyName,
    this.contactName,
    this.paymentTerms,
    this.creditNoteBalance,
  });

  Customer.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        address = json['address'] as String?,
        phoneNumber = json['phone_number'] as String?,
        email = json['email'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        pincode = json['pincode'] as String?,
        companyName = json['company_name'] as String?,
        contactName = json['contact_name'],
        paymentTerms = json['payment_terms'] as String?,
        creditNoteBalance = json['credit_note_balance'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'phone_number': phoneNumber,
        'email': email,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'pincode': pincode,
        'company_name': companyName,
        'contact_name': contactName,
        'payment_terms': paymentTerms,
        'credit_note_balance': creditNoteBalance
      };
}

class CustomerDetails {
  final int? id;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final dynamic email;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final String? pincode;
  final String? companyName;
  final dynamic contactName;
  final String? paymentTerms;
  final dynamic creditNoteBalance;

  CustomerDetails({
    this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pincode,
    this.companyName,
    this.contactName,
    this.paymentTerms,
    this.creditNoteBalance,
  });

  CustomerDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        address = json['address'] as String?,
        phoneNumber = json['phone_number'] as String?,
        email = json['email'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        pincode = json['pincode'] as String?,
        companyName = json['company_name'] as String?,
        contactName = json['contact_name'],
        paymentTerms = json['payment_terms'] as String?,
        creditNoteBalance = json['credit_note_balance'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'phone_number': phoneNumber,
        'email': email,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'pincode': pincode,
        'company_name': companyName,
        'contact_name': contactName,
        'payment_terms': paymentTerms,
        'credit_note_balance': creditNoteBalance
      };
}

class ExpenseItems {
  final String? name;
  final int? productId;
  final int? stock;
  final int? isBox;
  final int? purchasePrice;
  final int? boxSize;
  final String? expDate;
  final String? invoiceNumber;
  final int? id;
  String? statusTime;
  Color? statusColor;

  ExpenseItems({
    this.name,
    this.productId,
    this.statusTime,
    this.statusColor,
    this.stock,
    this.isBox,
    this.purchasePrice,
    this.boxSize,
    this.expDate,
    this.invoiceNumber,
    this.id,
  });

  ExpenseItems.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        productId = json['product_id'] as int?,
        stock = json['stock'] as int?,
        isBox = json['is_box'] as int?,
        purchasePrice = json['purchase_price'] as int?,
        boxSize = json['box_size'] as int?,
        statusTime = json['statusTime'] ?? "",
        statusColor = json['statusColor'] ?? Colors.white,
        expDate = json['exp_date'] as String?,
        invoiceNumber = json['invoice_number'] as String?,
        id = json['id'] as int?;

  Map<String, dynamic> toJson() => {
        'name': name,
        'product_id': productId,
        'stock': stock,
        'is_box': isBox,
        'purchase_price': purchasePrice,
        'box_size': boxSize,
        'exp_date': expDate,
        'invoice_number': invoiceNumber,
        'id': id,
        'statusTime': statusTime,
        'statusColor': statusColor,
      };
}

class Orders {
  final int? id;
  final dynamic orderTotal;
  final dynamic comments;
  final dynamic deliveryNote;
  final dynamic customerSign;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final int? salesManagerId;
  final int? customerId;
  final dynamic extraDiscount;
  final dynamic deliveryAgentId;
  final dynamic orderTotalWithoutTax;
  final dynamic orderTax;
  final String? dueDate;
  final String? orderDate;
  String? statusTime;
  Color? statusColor;
  final String? discountType;
  final dynamic deliveryPic;
  final SalesManager? salesManager;
  final Customer? customer;
  final Payment? payment;
  final List<dynamic>? media;
  bool? isEdit;

  Orders({
    this.id,
    this.orderTotal,
    this.comments,
    this.deliveryNote,
    this.customerSign,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.salesManagerId,
    this.statusTime,
    this.statusColor,
    this.customerId,
    this.extraDiscount,
    this.deliveryAgentId,
    this.orderTotalWithoutTax,
    this.orderTax,
    this.isEdit,
    this.dueDate,
    this.orderDate,
    this.discountType,
    this.deliveryPic,
    this.salesManager,
    this.customer,
    this.payment,
    this.media,
  });

  Orders.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        orderTotal = json['order_total'],
        comments = json['comments'],
        deliveryNote = json['delivery_note'],
        customerSign = json['customer_sign'],
        status = json['status'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        statusTime = json['statusTime'] ?? "",
        statusColor = json['statusColor'] ?? Colors.white,
        deletedAt = json['deleted_at'],
        isEdit = json['isEdit'] ?? false,
        salesManagerId = json['sales_manager_id'] as int?,
        customerId = json['customer_id'] as int?,
        extraDiscount = json['extra_discount'],
        deliveryAgentId = json['delivery_agent_id'],
        orderTotalWithoutTax = json['order_total_without_tax'],
        orderTax = json['order_tax'],
        dueDate = json['due_date'] as String?,
        orderDate = json['order_date'] as String?,
        discountType = json['discount_type'] as String?,
        deliveryPic = json['delivery_pic'],
        salesManager = (json['sales_manager'] as Map<String, dynamic>?) != null ? SalesManager.fromJson(json['sales_manager'] as Map<String, dynamic>) : null,
        customer = (json['customer'] as Map<String, dynamic>?) != null ? Customer.fromJson(json['customer'] as Map<String, dynamic>) : null,
        payment = (json['payment'] as Map<String, dynamic>?) != null ? Payment.fromJson(json['payment'] as Map<String, dynamic>) : null,
        media = json['media'] as List?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_total': orderTotal,
        'comments': comments,
        'delivery_note': deliveryNote,
        'customer_sign': customerSign,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'statusTime': statusTime,
        'statusColor': statusColor,
        'sales_manager_id': salesManagerId,
        'customer_id': customerId,
        'extra_discount': extraDiscount,
        'delivery_agent_id': deliveryAgentId,
        'order_total_without_tax': orderTotalWithoutTax,
        'order_tax': orderTax,
        'isEdit': isEdit,
        'due_date': dueDate,
        'order_date': orderDate,
        'discount_type': discountType,
        'delivery_pic': deliveryPic,
        'sales_manager': salesManager?.toJson(),
        'customer': customer?.toJson(),
        'payment': payment?.toJson(),
        'media': media
      };
}

class Products {
  final String? name;
  final int? id;
  final dynamic productImage;
  final List<dynamic>? media;

  Products({
    this.name,
    this.id,
    this.productImage,
    this.media,
  });

  Products.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['id'] as int?,
        productImage = json['product_image'],
        media = json['media'] as List?;

  Map<String, dynamic> toJson() => {'name': name, 'id': id, 'product_image': productImage, 'media': media};
}

class Customers {
  final int? id;
  String? name;
  String? address;
  String? phoneNumber;
  dynamic email;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? pincode;
  String? companyName;
  String? totalRevenue;
  dynamic contactName;
  String? paymentTerms;
  int? creditNoteBalance;

  Customers({
    this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pincode,
    this.companyName,
    this.contactName,
    this.paymentTerms,
    this.totalRevenue,
    this.creditNoteBalance,
  });

  Customers.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        address = json['address'] as String?,
        phoneNumber = json['phone_number'] as String?,
        email = json['email'],
        totalRevenue = json['totalRevenue'] ?? "",
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        pincode = json['pincode'] as String?,
        companyName = json['company_name'] as String?,
        contactName = json['contact_name'],
        paymentTerms = json['payment_terms'] as String?,
        creditNoteBalance = json['credit_note_balance'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'phone_number': phoneNumber,
        'totalRevenue': totalRevenue,
        'email': email,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'pincode': pincode,
        'company_name': companyName,
        'contact_name': contactName,
        'payment_terms': paymentTerms,
        'credit_note_balance': creditNoteBalance
      };
}

class Inventories {
  final int? id;
  final String? discountType;
  final int? discount;
  final dynamic finalPrice;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final int? supplierId;
  final String? daysPayableOutstanding;
  final String? imageUrl;
  final String? invoiceNumber;
  final String? dueDate;
  String? status;
  Color? statusColor;
  final int? expenseTotal;
  final dynamic expenseTax;
  final dynamic poFile;
  final Supplier? supplier;
  final List<dynamic>? media;
  final Payment? payment;

  Inventories({
    this.id,
    this.discountType,
    this.discount,
    this.finalPrice,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.supplierId,
    this.daysPayableOutstanding,
    this.imageUrl,
    this.invoiceNumber,
    this.dueDate,
    this.expenseTotal,
    this.expenseTax,
    this.status,
    this.statusColor,
    this.poFile,
    this.supplier,
    this.media,
    this.payment,
  });

  Inventories.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        discountType = json['discount_type'] as String?,
        discount = json['discount'] as int?,
        finalPrice = json['final_price'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        status = json['status'] ?? "",
        supplierId = json['supplier_id'] as int?,
        daysPayableOutstanding = json['days_payable_outstanding'] as String?,
        imageUrl = json['image_url'] as String?,
        invoiceNumber = json['invoice_number'] as String?,
        dueDate = json['due_date'] as String?,
        expenseTotal = json['expense_total'] as int?,
        expenseTax = json['expense_tax'],
        poFile = json['po_file'],
        statusColor = json['statusColor'] ?? AppColors.whiteColor,
        supplier = (json['supplier'] as Map<String, dynamic>?) != null ? Supplier.fromJson(json['supplier'] as Map<String, dynamic>) : null,
        media = json['media'] as List?,
        payment = (json['payment'] as Map<String, dynamic>?) != null ? Payment.fromJson(json['payment'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'discount_type': discountType,
        'discount': discount,
        'final_price': finalPrice,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'supplier_id': supplierId,
        'statusColor': statusColor,
        'days_payable_outstanding': daysPayableOutstanding,
        'image_url': imageUrl,
        'invoice_number': invoiceNumber,
        'status': status,
        'due_date': dueDate,
        'expense_total': expenseTotal,
        'expense_tax': expenseTax,
        'po_file': poFile,
        'supplier': supplier?.toJson(),
        'media': media,
        'payment': payment?.toJson()
      };
}

class Payment {
  final int? id;
  final int? supplierId;
  final String? invoiceNumber;
  final dynamic expenseTotal;
  final int? expensePaid;
  final dynamic expensePending;
  final String? paymentStatus;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final int? expenseId;
  final int? customerId;
  final int? orderNumber;
  final dynamic orderTotal;
  final int? orderPaid;
  final dynamic orderPending;

  Payment({
    this.id,
    this.supplierId,
    this.invoiceNumber,
    this.expenseTotal,
    this.expensePaid,
    this.expensePending,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.expenseId,
    this.customerId,
    this.orderNumber,
    this.orderTotal,
    this.orderPaid,
    this.orderPending,
  });

  Payment.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        supplierId = json['supplier_id'] as int?,
        invoiceNumber = json['invoice_number'] as String?,
        expenseTotal = json['expense_total'],
        expensePaid = json['expense_paid'] as int?,
        expensePending = json['expense_pending'],
        paymentStatus = json['payment_status'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        customerId = json['customer_id'] as int?,
        orderNumber = json['order_number'] as int?,
        orderTotal = json['order_total'],
        orderPaid = json['order_paid'] as int?,
        orderPending = json['order_pending'],
        expenseId = json['expense_id'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'supplier_id': supplierId,
        'invoice_number': invoiceNumber,
        'expense_total': expenseTotal,
        'expense_paid': expensePaid,
        'expense_pending': expensePending,
        'payment_status': paymentStatus,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'expense_id': expenseId,
        'customer_id': customerId,
        'order_number': orderNumber,
        'order_total': orderTotal,
        'order_paid': orderPaid,
        'order_pending': orderPending,
      };
}

class Suppliers {
  final int? id;
  String? supplierName;
  String? supplierNumber;
  String? supplierEmail;
  String? totalExpense;
  final String? createdAt;
  final String? updatedAt;

  Suppliers({
    this.id,
    this.totalExpense,
    this.supplierName,
    this.supplierNumber,
    this.supplierEmail,
    this.createdAt,
    this.updatedAt,
  });

  Suppliers.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        supplierName = json['supplier_name'] as String?,
        supplierNumber = json['supplier_number'] as String?,
        supplierEmail = json['supplier_email'] as String?,
        totalExpense = json['totalExpense'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'supplier_name': supplierName,
        'supplier_number': supplierNumber,
        'totalExpense': totalExpense,
        'supplier_email': supplierEmail,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
