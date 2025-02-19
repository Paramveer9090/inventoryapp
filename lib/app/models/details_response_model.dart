import 'package:flutter/cupertino.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';

import 'login_signup_response_model.dart';

class GetDetailsResponseModel {
  final GetDetailsData? data;
  final GetDetailsData? order;
  final Role? role;
  final int? creditBalance;

  GetDetailsResponseModel({
    this.data,
    this.order,
    this.role,
    this.creditBalance,
  });

  GetDetailsResponseModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String, dynamic>?) != null ? GetDetailsData.fromJson(json['data'] as Map<String, dynamic>) : null,
        order = (json['order'] as Map<String, dynamic>?) != null ? GetDetailsData.fromJson(json['order'] as Map<String, dynamic>) : null,
        role = (json['role'] as Map<String, dynamic>?) != null ? Role.fromJson(json['role'] as Map<String, dynamic>) : null,
        creditBalance = json['credit_balance'] as int?;

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'order': order?.toJson(),
        'role': role?.toJson(),
        'credit_balance': creditBalance,
      };
}

class GetDetailsData {
  final int? id;
  final String? name;
  final dynamic categoryOrder;
  final dynamic categoryId;
  final dynamic subCategoryId;
  final String? createdAt;
  final String? updatedAt;
  String? categoryType;
  String? subCategoryType;
  String? taxType;
  final dynamic deletedAt;
  final String? status;
  final dynamic number;
  final String? date;
  final String? description;
  final dynamic productId;
  final dynamic addedById;
  final String? title;
  final dynamic tax;
  final String? supplierName;
  final String? supplierNumber;
  final dynamic supplierEmail;
  final String? companyName;
  final String? contactName;
  final String? address;
  final String? pincode;
  final String? phoneNumber;
  final String? email;
  final String? paymentTerms;
  final dynamic sellingPrice;
  final dynamic stock;
  final dynamic maximumSellingPrice;
  final dynamic boxSize;
  final dynamic taxId;
  final String? imageUrl;
  final dynamic productImage;
  final List<dynamic>? media;
  final dynamic discountType;
  final dynamic discount;
  final dynamic finalPrice;
  final int? supplierId;
  final dynamic daysPayableOutstanding;
  final String? invoiceNumber;
  final String? dueDate;
  final dynamic expenseTotal;
  final dynamic expenseTax;
  final List<GetDataListResponseData>? orderItem;
  final dynamic poFile;
  final Supplier? supplier;
  final dynamic invoiceId;
  final dynamic paymentId;
  final dynamic amount;
  final dynamic expenseId;
  final String? orderId;
  dynamic orderTotal;
  dynamic comments;
  final String? deliveryNote;
  final String? customerSign;
  final dynamic salesManagerId;
  final dynamic customerId;
  final dynamic extraDiscount;
  final dynamic deliveryAgentId;
  dynamic orderTotalWithoutTax;
  dynamic orderTax;
  final String? orderDate;
  final dynamic deliveryPic;
  final SalesManager? salesManager;
  final Customer? customer;
  final List<CartDetails>? cartDetails;
  final String? subCategoryName;

  final String? categoryName;
  final int? quantity;
  final String? productName;
  final int? isBox;
  final int? price;
  final String? customerName;

  GetDetailsData({
    this.id,
    this.name,
    this.status,
    this.categoryOrder,
    this.categoryId,
    this.createdAt,
    this.categoryType,
    this.updatedAt,
    this.deletedAt,
    this.number,
    this.date,
    this.subCategoryId,
    this.description,
    this.productId,
    this.addedById,
    this.title,
    this.taxType,
    this.orderId,
    this.tax,
    this.supplierName,
    this.supplierNumber,
    this.supplierEmail,
    this.companyName,
    this.subCategoryType,
    this.contactName,
    this.address,
    this.pincode,
    this.phoneNumber,
    this.email,
    this.paymentTerms,
    this.sellingPrice,
    this.stock,
    this.maximumSellingPrice,
    this.boxSize,
    this.taxId,
    this.productImage,
    this.media,
    this.imageUrl,
    this.discountType,
    this.discount,
    this.finalPrice,
    this.supplierId,
    this.daysPayableOutstanding,
    this.invoiceNumber,
    this.dueDate,
    this.expenseTotal,
    this.expenseTax,
    this.orderItem,
    this.poFile,
    this.supplier,
    this.invoiceId,
    this.paymentId,
    this.amount,
    this.expenseId,
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
    this.orderDate,
    this.deliveryPic,
    this.salesManager,
    this.customer,
    this.cartDetails,
    this.subCategoryName,
    this.categoryName,
    this.quantity,
    this.productName,
    this.isBox,
    this.price,
    this.customerName,
  });

  GetDetailsData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        categoryOrder = json['category_order'],
        categoryId = json['category_id'] as dynamic,
        subCategoryId = json['sub_category_id'] as dynamic,
        createdAt = json['created_at'] as String?,
        status = json['status'] as String?,
        categoryType = json['categoryType'] ?? "",
        taxType = json['taxType'] ?? "",
        orderId = json['order_id'] as String?,
        subCategoryType = json['subCategoryType'] ?? "",
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        number = json['number'],
        date = json['date'] as String?,
        description = json['description'] as String?,
        productId = json['product_id'],
        addedById = json['added_by_id'],
        title = json['title'] as String?,
        tax = json['tax'],
        supplierName = json['supplier_name'] as String?,
        supplierNumber = json['supplier_number'] as String?,
        supplierEmail = json['supplier_email'],
        companyName = json['company_name'] as String?,
        contactName = json['contact_name'] as String?,
        address = json['address'] as String?,
        pincode = json['pincode'] as String?,
        phoneNumber = json['phone_number'] as String?,
        email = json['email'] as String?,
        paymentTerms = json['payment_terms'] as String?,
        sellingPrice = json['selling_price'],
        stock = json['stock'],
        maximumSellingPrice = json['maximum_selling_price'],
        boxSize = json['box_size'],
        taxId = json['tax_id'],
        productImage = json['product_image'],
        media = json['media'] as List?,
        discountType = json['discount_type'],
        discount = json['discount'],
        finalPrice = json['final_price'],
        supplierId = json['supplier_id'] as int?,
        daysPayableOutstanding = json['days_payable_outstanding'],
        imageUrl = json['image_url'] as String?,
        invoiceNumber = json['invoice_number'] as String?,
        dueDate = json['due_date'] as String?,
        expenseTotal = json['expense_total'],
        expenseTax = json['expense_tax'],
        invoiceId = json['invoice_id'],
        paymentId = json['payment_id'],
        amount = json['amount'],
        expenseId = json['expense_id'],
        orderItem = (json['order_item'] as List?)?.map((dynamic e) => GetDataListResponseData.fromJson(e as Map<String, dynamic>)).toList(),
        poFile = json['po_file'],
        orderTotal = json['order_total'],
        comments = json['comments'],
        deliveryNote = json['delivery_note'] as String?,
        customerSign = json['customer_sign'] as String?,
        salesManagerId = json['sales_manager_id'],
        customerId = json['customer_id'],
        extraDiscount = json['extra_discount'],
        deliveryAgentId = json['delivery_agent_id'],
        orderTotalWithoutTax = json['order_total_without_tax'],
        orderTax = json['order_tax'],
        orderDate = json['order_date'] as String?,
        deliveryPic = json['delivery_pic'],
        subCategoryName = json['sub_category_name'] as String?,
        categoryName = json['category_name'] as String?,
        quantity = json['quantity'] as int?,
        productName = json['product_name'] as String?,
        isBox = json['is_box'] as int?,
        price = json['price'] as int?,
        customerName = json['customer_name'] as String?,
        cartDetails = (json['cart_details'] as List?)?.map((dynamic e) => CartDetails.fromJson(e as Map<String, dynamic>)).toList(),
        salesManager = (json['sales_manager'] as Map<String, dynamic>?) != null ? SalesManager.fromJson(json['sales_manager'] as Map<String, dynamic>) : null,
        customer = (json['customer'] as Map<String, dynamic>?) != null ? Customer.fromJson(json['customer'] as Map<String, dynamic>) : null,
        supplier = (json['supplier'] as Map<String, dynamic>?) != null ? Supplier.fromJson(json['supplier'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'category_order': categoryOrder,
        'category_id': categoryId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'categoryType': categoryType,
        'deleted_at': deletedAt,
        'sub_category_id': subCategoryId,
        'number': number,
        'date': date,
        'description': description,
        'taxType': taxType,
        'product_id': productId,
        'added_by_id': addedById,
        'subCategoryType': subCategoryType,
        'title': title,
        'order_id': orderId,
        'tax': tax,
        'supplier_name': supplierName,
        'supplier_number': supplierNumber,
        'supplier_email': supplierEmail,
        'company_name': companyName,
        'contact_name': contactName,
        'order_total': orderTotal,
        'comments': comments,
        'delivery_note': deliveryNote,
        'customer_sign': customerSign,
        'sales_manager_id': salesManagerId,
        'customer_id': customerId,
        'extra_discount': extraDiscount,
        'delivery_agent_id': deliveryAgentId,
        'order_total_without_tax': orderTotalWithoutTax,
        'order_tax': orderTax,
        'due_date': dueDate,
        'order_date': orderDate,
        'discount_type': discountType,
        'delivery_pic': deliveryPic,
        'order_item': orderItem?.map((e) => e.toJson()).toList(),
        'sales_manager': salesManager?.toJson(),
        'customer': customer?.toJson(),
        'address': address,
        'pincode': pincode,
        'phone_number': phoneNumber,
        'email': email,
        'payment_terms': paymentTerms,
        'selling_price': sellingPrice,
        'stock': stock,
        'maximum_selling_price': maximumSellingPrice,
        'invoice_id': invoiceId,
        'payment_id': paymentId,
        'amount': amount,
        'expense_id': expenseId,
        'box_size': boxSize,
        'tax_id': taxId,
        'product_image': productImage,
        'media': media,
        'image_url': imageUrl,
        'discount': discount,
        'final_price': finalPrice,
        'supplier_id': supplierId,
        'days_payable_outstanding': daysPayableOutstanding,
        'invoice_number': invoiceNumber,
        'expense_total': expenseTotal,
        'expense_tax': expenseTax,
        'po_file': poFile,
        'sub_category_name': subCategoryName,
        'category_name': categoryName,
        'quantity': quantity,
        'product_name': productName,
        'is_box': isBox,
        'price': price,
        'customer_name': customerName,
        'cart_details': cartDetails?.map((e) => e.toJson()).toList(),
        'supplier': supplier?.toJson(),
      };
}

class Role {
  final int? id;
  final String? title;
  final dynamic createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final Pivot? pivot;

  Role({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  Role.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        createdAt = json['created_at'],
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        pivot = (json['pivot'] as Map<String, dynamic>?) != null ? Pivot.fromJson(json['pivot'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'created_at': createdAt, 'updated_at': updatedAt, 'deleted_at': deletedAt, 'pivot': pivot?.toJson()};
}

class CartDetails {
  final int? customerId;
  final int? productId;
  dynamic quantity;
  final String? productName;
  int? isBox;
  final int? stock;
  final dynamic price;
  final int? taxId;
  final int? boxSize;
  final String? title;
  final int? tax;
  final String? customerName;
  String? amountWithoutTax;
  String? amountOnlyTax;
  String? finalAmount;
  final String? subCategoryName;
  final int? subCategoryId;
  final String? categoryName;
  final int? categoryId;
  final String? imageUrl;
  final TextEditingController? description;
  final TextEditingController? comment;
  final int? salesManagerId;

  CartDetails({
    this.customerId,
    this.productId,
    this.comment,
    this.description,
    this.boxSize,
    this.quantity,
    this.stock,
    this.productName,
    this.isBox,
    this.price,
    this.taxId,
    this.title,
    this.tax,
    this.amountWithoutTax,
    this.amountOnlyTax,
    this.finalAmount,
    this.customerName,
    this.subCategoryName,
    this.subCategoryId,
    this.categoryName,
    this.categoryId,
    this.imageUrl,
    this.salesManagerId,
  });

  CartDetails.fromJson(Map<String, dynamic> json)
      : customerId = json['customer_id'] as int?,
        productId = json['product_id'] as int?,
        quantity = json['quantity'],
        productName = json['product_name'] as String?,
        isBox = json['is_box'] as int?,
        price = json['price'],
        boxSize = json['box_size'] as int?,
        stock = json['stock'] as int?,
        taxId = json['tax_id'] as int?,
        title = json['title'] as String?,
        description = json['description'] ?? TextEditingController(text: ""),
        comment = json['comment'] ?? TextEditingController(text: ""),
        amountWithoutTax = json['amountWithoutTax'] as String?,
        amountOnlyTax = json['amountOnlyTax'] as String?,
        finalAmount = json['finalAmount'] as String?,
        tax = json['tax'] as int?,
        customerName = json['customer_name'] as String?,
        subCategoryName = json['sub_category_name'] as String?,
        subCategoryId = json['sub_category_id'] as int?,
        categoryName = json['category_name'] as String?,
        categoryId = json['category_id'] as int?,
        imageUrl = json['image_url'] as String?,
        salesManagerId = json['sales_manager_id'] as int?;

  Map<String, dynamic> toJson() => {
        'customer_id': customerId,
        'product_id': productId,
        'quantity': quantity,
        'product_name': productName,
        'is_box': isBox,
        'price': price,
        'stock': stock,
        'tax_id': taxId,
        'title': title,
        'boxSize': boxSize,
        'tax': tax,
        'amountWithoutTax': amountWithoutTax,
        'description': description,
        'comment': comment,
        'amountOnlyTax': amountOnlyTax,
        'finalAmount': finalAmount,
        'customer_name': customerName,
        'sub_category_name': subCategoryName,
        'sub_category_id': subCategoryId,
        'category_name': categoryName,
        'category_id': categoryId,
        'box_size': boxSize,
        'image_url': imageUrl,
        'sales_manager_id': salesManagerId
      };
}
