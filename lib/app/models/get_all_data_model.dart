import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class GetDataListResponseModel {
  final List<GetDataListResponseData>? data;
  final List<Suppliers>? suppliers;
  final List<Customers>? customers;
  final List<Payments>? payments;
  final int? totalOrder;
  final int? deliver;
  final int? pending;

  GetDataListResponseModel({
    this.data,
    this.customers,
    this.suppliers,
    this.payments,
    this.totalOrder,
    this.deliver,
    this.pending,
  });

  GetDataListResponseModel.fromJson(Map<String, dynamic> json)
      : totalOrder = json['total_order'] as int?,
        deliver = json['deliver'] as int?,
        pending = json['pending'] as int?,
        suppliers = (json['suppliers'] as List?)?.map((dynamic e) => Suppliers.fromJson(e as Map<String, dynamic>)).toList(),
        customers = (json['customers'] as List?)?.map((dynamic e) => Customers.fromJson(e as Map<String, dynamic>)).toList(),
        payments = (json['payments'] as List?)?.map((dynamic e) => Payments.fromJson(e as Map<String, dynamic>)).toList(),
        data = (json['data'] as List?)?.map((dynamic e) => GetDataListResponseData.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
        'total_order': totalOrder,
        'deliver': deliver,
        'pending': pending,
        'customers': customers?.map((e) => e.toJson()).toList(),
        'data': data?.map((e) => e.toJson()).toList(),
        'payments': payments?.map((e) => e.toJson()).toList(),
        'suppliers': suppliers?.map((e) => e.toJson()).toList(),
      };
}

class GetDataListResponseData {
  int? id;
  String? name;
  final int? categoryOrder;
  dynamic categoryId;
  String? categoryType;
  String? subCategoryType;
  String? taxType;
  final String? createdAt;
  final String? order_date;
  final String? delivery_note;
  final String? updatedAt;
  final dynamic deletedAt;
  dynamic sellingPrice;
  int? stock;
  dynamic maximumSellingPrice;
  final Tax? taxDetail;
  int? boxSize;
  String? imageUrl;
  int? taxId;
  int? subCategoryId;
  dynamic productImage;
  final List<dynamic>? media;
  String? title;
  dynamic tax;
  String? status;
  dynamic number;
  dynamic isEdit;
  String? date;
  dynamic quantityCount;
  String? description;
  final dynamic productId;
  dynamic isUnitSelected;
  final dynamic addedById;
  final Product? product;
  final AddedBy? addedBy;
  String? supplierName;
  String? supplierNumber;
  dynamic supplierEmail;
  final dynamic amount;
  final dynamic invoiceId;
  dynamic paymentId;
  final int? expenseId;
  final Expense? expense;
  Payment? payment;
  String? address;
  String? phoneNumber;
  dynamic email;
  String? pincode;
  String? companyName;
  dynamic contactName;
  String? paymentTerms;
  int? creditNoteBalance;
  final dynamic orderTotal;
  final dynamic comments;
  final dynamic deliveryNote;
  final dynamic customerSign;
  final int? salesManagerId;
  final int? customerId;
  final dynamic extraDiscount;
  final int? deliveryAgentId;
  final int? orderTotalWithoutTax;
  final dynamic orderTax;
  final String? dueDate;
  final int? editKey;
  final SalesManager? salesManager;
  final Customer? customer;
  int? orderId;
  Order? order;
  final String? discountType;
  final int? discount;
  final dynamic finalPrice;
  final int? supplierId;
  final String? daysPayableOutstanding;
  final String? invoiceNumber;
  final dynamic expenseTotal;
  final dynamic expenseTax;
  final dynamic poFile;
  final Supplier? supplier;
  final int? expensePending;
  final int? orderNumber;
  final dynamic orderPending;
  final dynamic emailVerifiedAt;
  final int? orderPaid;

  final List<Roles>? roles;

  GetDataListResponseData({
    this.id,
    this.name,
    this.categoryOrder,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.subCategoryType,
    this.deletedAt,
    this.sellingPrice,
    this.stock,
    this.categoryType,
    this.quantityCount,
    this.maximumSellingPrice,
    this.boxSize,
    this.imageUrl,
    this.taxType,
    this.taxId,
    this.subCategoryId,
    this.orderPaid,
    this.productImage,
    this.media,
    this.title,
    this.taxDetail,
    this.order_date,
    this.isUnitSelected,
    this.isEdit,
    this.expensePending,
    this.tax,
    this.status,
    this.number,
    this.date,
    this.delivery_note,
    this.description,
    this.productId,
    this.addedById,
    this.product,
    this.addedBy,
    this.supplierName,
    this.supplierNumber,
    this.supplierEmail,
    this.amount,
    this.invoiceId,
    this.paymentId,
    this.expenseId,
    this.expense,
    this.payment,
    this.address,
    this.phoneNumber,
    this.email,
    this.pincode,
    this.companyName,
    this.contactName,
    this.paymentTerms,
    this.creditNoteBalance,
    this.orderTotal,
    this.comments,
    this.deliveryNote,
    this.customerSign,
    this.salesManagerId,
    this.customerId,
    this.extraDiscount,
    this.deliveryAgentId,
    this.orderTotalWithoutTax,
    this.orderTax,
    this.dueDate,
    this.editKey,
    this.salesManager,
    this.customer,
    this.orderId,
    this.order,
    this.discountType,
    this.discount,
    this.finalPrice,
    this.supplierId,
    this.daysPayableOutstanding,
    this.invoiceNumber,
    this.expenseTotal,
    this.expenseTax,
    this.poFile,
    this.supplier,
    this.orderNumber,
    this.orderPending,
    this.emailVerifiedAt,
    this.roles,
  });

  GetDataListResponseData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'],
        categoryOrder = json['category_order'] as int?,
        categoryId = json['category_id'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        delivery_note = json['delivery_note'] as String?,
        deletedAt = json['deleted_at'],
        subCategoryType = json['subCategoryType'] ?? "",
        categoryType = json['categoryType'] ?? "",
        taxType = json['taxType'] ?? "",
        sellingPrice = json['selling_price'],
        stock = json['stock'] as int?,
        quantityCount = json['quantityCount'],
        orderPaid = json['order_paid'] as int?,
        maximumSellingPrice = json['maximum_selling_price'],
        boxSize = json['box_size'] as int?,
        imageUrl = json['image_url'] as String?,
        taxId = json['tax_id'] as int?,
        subCategoryId = json['sub_category_id'] as int?,
        productImage = json['product_image'],
        isEdit = json['isEdit'] ?? false,
        media = json['media'] as List?,
        taxDetail = (json['tax_details'] as Map<String, dynamic>?) != null ? Tax.fromJson(json['tax_details'] as Map<String, dynamic>) : null,
        title = json['title'] as String?,
        tax = json['tax'],
        status = json['status'] as String?,
        number = json['number'] as int?,
        date = json['date'] as String?,
        description = json['description'] as String?,
        productId = json['product_id'],
        addedById = json['added_by_id'],
        supplierName = json['supplier_name'] as String?,
        supplierNumber = json['supplier_number'] as String?,
        supplierEmail = json['supplier_email'],
        amount = json['amount'],
        invoiceId = json['invoice_id'],
        isUnitSelected = json['isUnitSelected'] ?? 0,
        paymentId = json['payment_id'],
        expenseId = json['expense_id'] as int?,
        address = json['address'] as String?,
        phoneNumber = json['phone_number'] as String?,
        email = json['email'],
        pincode = json['pincode'] as String?,
        companyName = json['company_name'] as String?,
        contactName = json['contact_name'],
        paymentTerms = json['payment_terms'] as String?,
        creditNoteBalance = json['credit_note_balance'] as int?,
        orderTotal = json['order_total'],
        comments = json['comments'],
        deliveryNote = json['delivery_note'],
        customerSign = json['customer_sign'],
        salesManagerId = json['sales_manager_id'] as int?,
        customerId = json['customer_id'] as int?,
        extraDiscount = json['extra_discount'],
        deliveryAgentId = json['delivery_agent_id'] as int?,
        orderTotalWithoutTax = json['order_total_without_tax'] as int?,
        orderTax = json['order_tax'],
        dueDate = json['due_date'] as String?,
        order_date = json['order_date'] as String?,
        editKey = json['edit_key'] as int?,
        expensePending = json['expense_pending'] as int?,
        orderId = json['order_id'] as int?,
        discountType = json['discount_type'] as String?,
        discount = json['discount'] as int?,
        finalPrice = json['final_price'],
        supplierId = json['supplier_id'] as int?,
        daysPayableOutstanding = json['days_payable_outstanding'] as String?,
        invoiceNumber = json['invoice_number'] as String?,
        expenseTotal = json['expense_total'],
        expenseTax = json['expense_tax'],
        poFile = json['po_file'],
        orderNumber = json['order_number'] as int?,
        orderPending = json['order_pending'],
        emailVerifiedAt = json['email_verified_at'],
        roles = (json['roles'] as List?)?.map((dynamic e) => Roles.fromJson(e as Map<String, dynamic>)).toList(),
        supplier = (json['supplier'] as Map<String, dynamic>?) != null ? Supplier.fromJson(json['supplier'] as Map<String, dynamic>) : null,
        order = (json['order'] as Map<String, dynamic>?) != null ? Order.fromJson(json['order'] as Map<String, dynamic>) : null,
        salesManager = (json['sales_manager'] as Map<String, dynamic>?) != null ? SalesManager.fromJson(json['sales_manager'] as Map<String, dynamic>) : null,
        customer = (json['customer'] as Map<String, dynamic>?) != null ? Customer.fromJson(json['customer'] as Map<String, dynamic>) : null,
        expense = (json['expense'] as Map<String, dynamic>?) != null ? Expense.fromJson(json['expense'] as Map<String, dynamic>) : null,
        payment = (json['payment'] as Map<String, dynamic>?) != null ? Payment.fromJson(json['payment'] as Map<String, dynamic>) : null,
        product = (json['product'] as Map<String, dynamic>?) != null ? Product.fromJson(json['product'] as Map<String, dynamic>) : null,
        addedBy = (json['added_by'] as Map<String, dynamic>?) != null ? AddedBy.fromJson(json['added_by'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category_order': categoryOrder,
        'category_id': categoryId,
        'isEdit': isEdit,
        'quantityCount': quantityCount,
        'created_at': createdAt,
        'order_date': order_date,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'selling_price': sellingPrice,
        'stock': stock,
        'maximum_selling_price': maximumSellingPrice,
        'isUnitSelected': isUnitSelected,
        'box_size': boxSize,
        'delivery_note': delivery_note,
        'subCategoryType': subCategoryType,
        'categoryType': categoryType,
        'order_paid': orderPaid,
        'image_url': imageUrl,
        'tax_id': taxId,
        'taxType': taxType,
        'sub_category_id': subCategoryId,
        'product_image': productImage,
        'media': media,
        'tax_details': tax?.toJson(),
        'title': title,
        'tax': tax,
        'status': status,
        'number': number,
        'date': date,
        'description': description,
        'product_id': productId,
        'added_by_id': addedById,
        'product': product?.toJson(),
        'added_by': addedBy?.toJson(),
        'supplier_name': supplierName,
        'supplier_number': supplierNumber,
        'supplier_email': supplierEmail,
        'amount': amount,
        'invoice_id': invoiceId,
        'payment_id': paymentId,
        'expense_id': expenseId,
        'expense': expense?.toJson(),
        'payment': payment?.toJson(),
        'address': address,
        'email_verified_at': emailVerifiedAt,
        'roles': roles?.map((e) => e.toJson()).toList(),
        'phone_number': phoneNumber,
        'email': email,
        'pincode': pincode,
        'company_name': companyName,
        'contact_name': contactName,
        'payment_terms': paymentTerms,
        'credit_note_balance': creditNoteBalance,
        'order_total': orderTotal,
        'comments': comments,
        'expense_pending': expensePending,
        'delivery_note': deliveryNote,
        'customer_sign': customerSign,
        'sales_manager_id': salesManagerId,
        'customer_id': customerId,
        'extra_discount': extraDiscount,
        'delivery_agent_id': deliveryAgentId,
        'order_total_without_tax': orderTotalWithoutTax,
        'order_tax': orderTax,
        'due_date': dueDate,
        'edit_key': editKey,
        'sales_manager': salesManager?.toJson(),
        'customer': customer?.toJson(),
        'order_id': orderId,
        'order': order?.toJson(),
        'discount_type': discountType,
        'discount': discount,
        'supplier_id': supplierId,
        'days_payable_outstanding': daysPayableOutstanding,
        'invoice_number': invoiceNumber,
        'expense_total': expenseTotal,
        'expense_tax': expenseTax,
        'po_file': poFile,
        'supplier': supplier?.toJson(),
        'order_number': orderNumber,
        'order_pending': orderPending
      };
}

class Tax {
  final int? id;
  final String? title;
  final int? tax;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  Tax({
    this.id,
    this.title,
    this.tax,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Tax.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        tax = json['tax'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'];

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'tax': tax, 'created_at': createdAt, 'updated_at': updatedAt, 'deleted_at': deletedAt};
}

class Payments {
  final String? invoiceNumber;
  final int? expenseTotal;
  final int? expensePaid;
  final int? expensePending;
  final int? expenseId;
  final String? supplierName;
  final String? supplierNumber;
  final String? supplierEmail;

  Payments({
    this.invoiceNumber,
    this.expenseTotal,
    this.expensePaid,
    this.expensePending,
    this.expenseId,
    this.supplierName,
    this.supplierNumber,
    this.supplierEmail,
  });

  Payments.fromJson(Map<String, dynamic> json)
      : invoiceNumber = json['invoice_number'] as String?,
        expenseTotal = json['expense_total'] as int?,
        expensePaid = json['expense_paid'] as int?,
        expensePending = json['expense_pending'] as int?,
        expenseId = json['expense_id'] as int?,
        supplierName = json['supplier_name'] as String?,
        supplierNumber = json['supplier_number'] as String?,
        supplierEmail = json['supplier_email'] as String?;

  Map<String, dynamic> toJson() => {
        'invoice_number': invoiceNumber,
        'expense_total': expenseTotal,
        'expense_paid': expensePaid,
        'expense_pending': expensePending,
        'expense_id': expenseId,
        'supplier_name': supplierName,
        'supplier_number': supplierNumber,
        'supplier_email': supplierEmail
      };
}

class Supplier {
  final int? id;
  final String? supplierName;
  final String? supplierNumber;
  final String? supplierEmail;
  final String? createdAt;
  final String? updatedAt;

  Supplier({
    this.id,
    this.supplierName,
    this.supplierNumber,
    this.supplierEmail,
    this.createdAt,
    this.updatedAt,
  });

  Supplier.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        supplierName = json['supplier_name'] as String?,
        supplierNumber = json['supplier_number'] as String?,
        supplierEmail = json['supplier_email'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'supplier_name': supplierName, 'supplier_number': supplierNumber, 'supplier_email': supplierEmail, 'created_at': createdAt, 'updated_at': updatedAt};
}

class Order {
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
  final int? extraDiscount;
  final int? deliveryAgentId;
  final int? orderTotalWithoutTax;
  final dynamic orderTax;
  final String? dueDate;

  Order({
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
    this.customerId,
    this.extraDiscount,
    this.deliveryAgentId,
    this.orderTotalWithoutTax,
    this.orderTax,
    this.dueDate,
  });

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        orderTotal = json['order_total'],
        comments = json['comments'],
        deliveryNote = json['delivery_note'],
        customerSign = json['customer_sign'],
        status = json['status'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        salesManagerId = json['sales_manager_id'] as int?,
        customerId = json['customer_id'] as int?,
        extraDiscount = json['extra_discount'] as int?,
        deliveryAgentId = json['delivery_agent_id'] as int?,
        orderTotalWithoutTax = json['order_total_without_tax'] as int?,
        orderTax = json['order_tax'],
        dueDate = json['due_date'] as String?;

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
        'sales_manager_id': salesManagerId,
        'customer_id': customerId,
        'extra_discount': extraDiscount,
        'delivery_agent_id': deliveryAgentId,
        'order_total_without_tax': orderTotalWithoutTax,
        'order_tax': orderTax,
        'due_date': dueDate
      };
}

class Product {
  final int? id;
  String? name = "";
  final int? sellingPrice;
  final int? stock;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final int? categoryId;
  final int? maximumSellingPrice;
  final int? boxSize;
  final String? imageUrl;
  final int? taxId;
  final dynamic subCategoryId;
  final dynamic productImage;
  final List<dynamic>? media;

  Product({
    this.id,
    this.name,
    this.sellingPrice,
    this.stock,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.categoryId,
    this.maximumSellingPrice,
    this.boxSize,
    this.imageUrl,
    this.taxId,
    this.subCategoryId,
    this.productImage,
    this.media,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] ?? "",
        sellingPrice = json['selling_price'] as int?,
        stock = json['stock'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        categoryId = json['category_id'] as int?,
        maximumSellingPrice = json['maximum_selling_price'] as int?,
        boxSize = json['box_size'] as int?,
        imageUrl = json['image_url'] as String?,
        taxId = json['tax_id'] as int?,
        subCategoryId = json['sub_category_id'],
        productImage = json['product_image'],
        media = json['media'] as List?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'selling_price': sellingPrice,
        'stock': stock,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'category_id': categoryId,
        'maximum_selling_price': maximumSellingPrice,
        'box_size': boxSize,
        'image_url': imageUrl,
        'tax_id': taxId,
        'sub_category_id': subCategoryId,
        'product_image': productImage,
        'media': media
      };
}

class AddedBy {
  final int? id;
  String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  AddedBy({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  AddedBy.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        emailVerifiedAt = json['email_verified_at'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email, 'email_verified_at': emailVerifiedAt, 'created_at': createdAt, 'updated_at': updatedAt, 'deleted_at': deletedAt};
}

class Expense {
  final int? id;
  final String? discountType;
  final int? discount;
  final int? finalPrice;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final int? supplierId;
  final String? daysPayableOutstanding;
  final String? imageUrl;
  final String? invoiceNumber;
  final String? dueDate;
  final int? expenseTotal;
  final int? expenseTax;
  final dynamic poFile;
  final List<dynamic>? media;

  Expense({
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
    this.poFile,
    this.media,
  });

  Expense.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        discountType = json['discount_type'] as String?,
        discount = json['discount'] as int?,
        finalPrice = json['final_price'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        supplierId = json['supplier_id'] as int?,
        daysPayableOutstanding = json['days_payable_outstanding'] as String?,
        imageUrl = json['image_url'] as String?,
        invoiceNumber = json['invoice_number'] as String?,
        dueDate = json['due_date'] as String?,
        expenseTotal = json['expense_total'] as int?,
        expenseTax = json['expense_tax'] as int?,
        poFile = json['po_file'],
        media = json['media'] as List?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'discount_type': discountType,
        'discount': discount,
        'final_price': finalPrice,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'supplier_id': supplierId,
        'days_payable_outstanding': daysPayableOutstanding,
        'image_url': imageUrl,
        'invoice_number': invoiceNumber,
        'due_date': dueDate,
        'expense_total': expenseTotal,
        'expense_tax': expenseTax,
        'po_file': poFile,
        'media': media
      };
}

class Payment {
  final int? id;
  final String? name;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  Payment({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Payment.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        status = json['status'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'status': status, 'created_at': createdAt, 'updated_at': updatedAt, 'deleted_at': deletedAt};
}

class SalesManager {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  SalesManager({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  SalesManager.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        emailVerifiedAt = json['email_verified_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email, 'email_verified_at': emailVerifiedAt, 'created_at': createdAt, 'updated_at': updatedAt, 'deleted_at': deletedAt};
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
  final int? creditNoteBalance;

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
        creditNoteBalance = json['credit_note_balance'] as int?;

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
